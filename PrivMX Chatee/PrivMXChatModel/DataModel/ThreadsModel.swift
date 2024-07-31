//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT Licence.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
 
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
import SwiftUI

@MainActor
open class ThreadsModel: Observable, ObservableObject {

  /// Reference to endpointWrapper for connection
  var endpointWrapper: PrivMXEndpointWrapper?

  var contextID: String?

  /// Data model implementing ListModelProtocol, used for maitaining list of threads in the context
  @Published public var model: ThreadInfoListModel

  /// Dependend model for managing content of single thread
  @Published public var threadModel: ThreadModel

  public init(threadModel: ThreadModel) {
    self.model = ThreadInfoListModel()
    self.threadModel = threadModel
  }

  var limit: Int64 = 10

  /// Initialization of ThreadsModel
  ///
  /// > Warning: It requires proer instance of PrivMXEndpointWrapper to successfully
  /// > manage Threads available in provided ContextID
  ///
  /// - Parameters:
  ///     - endpointWrapper : PrivMXEndpointWrapper  - instance of conected endpointWrapper
  ///     - contextID:String - contextID managed at PrivMXBridge
  ///     - model - instance of class implementing ListModelProtocol, used for maitaining list of threads in the context
  ///
  public func configure(
    endpointWrapper: PrivMXEndpointWrapper,
    contextID: String
  ) {
    self.contextID = contextID
    self.endpointWrapper = endpointWrapper
    self.threadModel.configure(endpointWrapper: endpointWrapper)
      self.model.sortOrder = "desc" 
    self.model.thesame = { $0.id == $1.id }
    self.model.compare = { $0.id < $1.id }
    self.model.loader = { skip, count, sortOrder, rc in
      AsyncCall {
        var thrs = [privmx.endpoint.thread.ThreadInfo]()
        var available: Int64 = 0
          do {
              let thrsResponse = try self.endpointWrapper?.threadsApi?.listThreads(
                from: self.contextID!,  // threads in context
                query: privmx.endpoint.core.ListQuery(
                    skip: skip,  // number of skipped elements
                    limit: self.limit,  // upper limit of response size
                    sortOrder: self.model.sortOrder.pmxSortOrder  // sort order
                )
              )
              thrs = thrsResponse?.threads.map { $0 } ?? []
              available = Int64(thrsResponse?.threadsTotal ?? 0)
              
          } catch PrivMXEndpointError.failedGettingThread(_) {
          NotificationCenter.default.post(
            name: NSNotification.DefaultToast, object: nil,
            userInfo: ["content": "Failed getting Threads"])
          NotificationCenter.default.post(
            name: NSNotification.CriticalError, object: nil,
            userInfo: ["function": "getThreadsList"])
        } catch _ {
          NotificationCenter.default.post(
            name: NSNotification.DefaultToast, object: nil,
            userInfo: ["content": "Unexpected error when getting Threads"])
          NotificationCenter.default.post(
            name: NSNotification.CriticalError, object: nil,
            userInfo: ["function": "getThreadsList"])
        }
        return (available, thrs)
      }
      .then { available, thrs in
        rc(available, thrs)
      }.run() 
    }
  }

  /// Setup of ThreadsModel
  ///
  /// This function:
  /// - clears data model,
  /// - triggers loading first part of data
  /// - registers listeners for all stores callbacks
  ///
  public func setup() {
  
    endpointWrapper?.clearCallbacks(for: privmx.endpoint.thread.ThreadCreatedEvent.self)
    endpointWrapper?.clearCallbacks(for: privmx.endpoint.thread.ThreadUpdatedEvent.self)
    endpointWrapper?.clearCallbacks(for: privmx.endpoint.thread.ThreadStatsEvent.self)
    self.model.clear()
    self.model.loadNext()
    _ = endpointWrapper?.registerCallback(
      for: privmx.endpoint.thread.ThreadCreatedEvent.self, from: EventChannel.thread2
    ) {
      data in
      if let newThreadInfoData = data as? privmx.endpoint.thread.ThreadInfo {
        self.add(newData: newThreadInfoData)
      }
    }
    _ = endpointWrapper?.registerCallback(
      for: privmx.endpoint.thread.ThreadUpdatedEvent.self, from: EventChannel.thread2
    ) {
      data in
      if let data = data as? privmx.endpoint.thread.ThreadInfo {
        //self.model.update(data)
        self.updateModelWith(newData: data)
      }
    }
    _ = endpointWrapper?.registerCallback(
      for: privmx.endpoint.thread.ThreadStatsEvent.self, from: EventChannel.thread2
    ) {
      data in

      if let data = data as? privmx.endpoint.thread.ThreadStatsEventData {

        if let i = self.model.data.firstIndex(where: { d in d.threadId == data.threadId }) {
          var newData = self.model.data[i]
          newData.lastMsgDate = data.lastMsgDate
          newData.messagesCount = data.messages
          self.updateModelWith(newData: newData)

        }
      }
    }
  }

  func add(newData threadInfo: privmx.endpoint.thread.ThreadInfo) {
      Task{
          self.model.add(element: threadInfo)
      }
  }

  func updateModelWith(newData threadInfo: privmx.endpoint.thread.ThreadInfo) {
      Task{
           self.model.update(threadInfo)
      }
  }

  /// Geting ThreadInfo
  ///
  /// This function returns ThreadInfo structure for provided threadId
  ///
  /// - Parameters:
  ///     - threadId: Thread Identifier obtained from PrivMX Bridge
  ///
  public func getThreadInfo(for threadId: String) throws -> privmx.endpoint.thread.ThreadInfo {
    if let thread = try (self.endpointWrapper?.threadsApi?.getThread(threadId)) {
      return thread
    } else {
      throw PrivMXEndpointError.otherFailure(
        msg: "Exception while getting ThreadInfo for \(threadId)")
    }
  }

  /// Creating new thread
  ///
  /// This function creates new Thread with given name. Name can repeat in the container.
  /// After successfull creation model is refreshed
  ///
  /// - Parameters:
  ///     - name: String with name
  ///     - users: List of structs UserEntry
  ///     - cb: callback fired when store is created, with ThreadId as parameter.
  ///
  public func newThread(
    _ name: String, for users: [UserEntry], managedBy managers: [UserEntry],
    cb: @escaping ((String) -> Void)
  ) throws {
    OptionalAsyncCall {
      do {
        if let generatedThreadId = try self.endpointWrapper?.threadsApi?.createThread(
          name, with: users.toUserWithPubKey(), managedBy: managers.toUserWithPubKey(),
          in: self.contextID!)
        {
          return generatedThreadId
        }
      } catch {}

      return nil

    }.then { threadId in
      if let threadId = threadId {
        Task {
          await self.model.loadNew()
          cb(threadId)
        }
      }

    }.run()
  }

  /// Remove existing  thread
  ///
  /// This function removes given Thread from context
  /// After successfull removal model is refreshed
  ///
  /// - Parameters:
  ///     - threadId:String with Thread Identifier
  ///     - cb: callback with result.
  ///
  public func remove(thread threadId: String, cb: @escaping ((Bool) -> Void)) {
    AsyncCall {
      do {
        guard let threadInfo = try? self.endpointWrapper?.threadsApi?.getThread(threadId) else {
          return false
        }
        if let correspondingStoreId = threadInfo.data.storeId {
          try self.endpointWrapper?.storesApi?.deleteStore(correspondingStoreId)
        }
        try self.endpointWrapper?.threadsApi?.deleteThread(threadId)
        return true
      } catch {
        return false
      }
    }.then { success in
      Task {
        await self.model.reload()
        cb(success)
      }
    }.run()
  }
}
