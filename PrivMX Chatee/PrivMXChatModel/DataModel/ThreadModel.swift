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
open class ThreadModel: Observable, ObservableObject {

  /// Reference to endpointWrapper for connection
  var endpointWrapper: PrivMXEndpointWrapper?

  /// Currently configured thread
  @Published public var thread: privmx.endpoint.thread.ThreadInfo?

  /// Data model implementing ListModelProtocol, used for maitaining list of messags in the thread
  @Published public var model: ThreadMessageListModel

  /// All Stores model
  @Published public var storesModel: StoresModel?

  init() {
    model = ThreadMessageListModel()

  }

  /// Initialization of StoreModel
  ///
  /// > Warning: It requires proer instance of PrivMXEndpointWrapper to successfully
  /// > manage Stores available in provided ContextID
  ///
  /// - Parameters:
  ///     - endpointWrapper : PrivMXEndpointWrapper  - instance of conected endpointWrapper
  ///     - model - instance of class implementing ListModelProtocol, used for maitaining list of messages  in the store.
  public func configure(
    endpointWrapper: PrivMXEndpointWrapper
  ) {

    self.endpointWrapper = endpointWrapper
    self.model.sortOrder = "desc" 
    self.model.thesame = { $0.id == $1.id }
      self.model.compare = { $0.info.createDate > $1.info.createDate }

    self.model.loader = { skip, count, sortOrder, rc in 
        
        AsyncCall {
            var messages = [privmx.endpoint.core.Message]()
            var available: Int64 = 0
            do {
                if let threadID = self.thread?.id {
                    let msglist = try self.endpointWrapper?.threadsApi?.listMessages(
                          from: threadID,
                          query: privmx.endpoint.core.ListQuery(skip: skip, limit: 10, sortOrder: "desc".pmxSortOrder ))
                    messages = msglist?.messages.map { $0 } ?? [privmx.endpoint.core.Message]()
                }
            }catch{
                NotificationCenter.default.post(
                name: NSNotification.DefaultToast, object: nil,
                userInfo: ["content": "Unexpected error when getting messages"])
            }
            return (available,messages)
        }
        .then { available, messages in
            rc(available, messages)
        }.run()

    }
      

  }

  /// Setup of ThreadModel
  ///
  /// This function:
  /// - clears data model,
  /// - triggers loading first part of data
  /// - registers listeners for all messages callbacks
  ///
  /// - Parameters:
  ///     - thread : ThreadInfo  - newly confiugred Thread
  ///     - initDependentStore - initialization of dpendent store (extracted from metadata)
  ///     - cb: callback function fired when
  public func setup(thread: privmx.endpoint.thread.ThreadInfo, initDependentStore: Bool = true) {
    
      if nil != self.thread{
		  self.endpointWrapper?.clearCallbacks(for:EventChannel.threadMessages(threadID: self.thread!.id))
	  }
    self.thread = thread
    self.model.clear()
    self.model.loadNext()

    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.thread.ThreadNewMessageEvent.self,
      from: EventChannel.threadMessages(threadID: thread.id)
    ) {
      data in
      if let data = data as? privmx.endpoint.core.Message {

          if data.info.threadId == self.thread?.threadId {
          self.add(newData: data)
        }
      }

      
    }
    if initDependentStore {
      if nil != self.thread?.contextId,
        let storeId = self.thread?.data.storeId,
        let store = try? storesModel?.getStoreInfo(for: storeId)
      {
        self.storesModel?.storeModel.setup(for: store)

      }
    }
  }

  func add(newData threadMessage: privmx.endpoint.core.Message) {
    Task {
      model.add(element: threadMessage)
    }
  }

  /// Send a message
  ///
  /// This function:
  /// - sends an message in currently configured thread
  ///
  /// - Parameters:
  ///     - content : String  - new message content
  ///
  public func send(message content: String, from user: UserEntry) {

    AsyncCall {
      do {
        if let thread = self.thread {
          //_ = try self.endpointWrapper?.threadsApi?.sendTextMessage(
          //  content, in: thread.id, as: user.name)
            
            _ = try self.endpointWrapper?.threadsApi?.sendMessage(in: thread.id, publicMeta: Data(), privateMeta: Data(), data: content.data(using: .utf8) ?? Data())
            
            
            
        }
      } catch PrivMXEndpointError.failedCreatingMessage(_) {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed creating Message"])
        NotificationCenter.default.post(
          name: NSNotification.CriticalError, object: nil,
          userInfo: ["function": "createTextMessage"])
      } catch _ {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Unexpected error when creating message"])
        NotificationCenter.default.post(
          name: NSNotification.CriticalError, object: nil,
          userInfo: ["function": "createTextMessage"])
      }
    }.then {
      Task {
        await self.model.loadNew()
      }
    }.run()
  }

  /// Delete exising message
  ///
  /// This function:
  /// - removes provided message from thread
  /// - removes file, if message has special structure containing file id
  ///
  /// - Parameters:
  ///     - message : ThreadMessage  - message object
  ///
  public func deleteMessage(message: privmx.endpoint.core.Message) {
    AsyncCall {

      _ = try? self.endpointWrapper?.threadsApi?.deleteMessage(message.id)

        if let fileinfo = message.data.fileMessage {
             self.storesModel?.storeModel.remove(fileId: fileinfo.fileId)
        }

    }.then {
      Task {
        await self.model.remove(message)
      }
    }.run()
  }

}
