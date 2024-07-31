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
open class StoresModel: ObservableObject {
  /// Reference to endpointWrapper for connection
  var endpointWrapper: PrivMXEndpointWrapper?

  var contextID: String = ""

  /// Data model implementing ListModelProtocol, used for maitaining list of stores in the context
  @Published public var model: StoreInfoListModel
  //any ListModelProtocol<privmx.endpoint.store.StoreInfo>

  /// Dependend model for managing content of single store
  @Published public var storeModel: StoreModel

  var limit: Int32 = 10

  init(storeModel: StoreModel) {
    model = StoreInfoListModel()
    self.storeModel = storeModel
  }

  /// Initialization of StoresModel
  ///
  /// > Warning: It requires proer instance of PrivMXEndpointWrapper to successfully
  /// > manage Stores available in provided ContextID
  ///
  /// - Parameters:
  ///     - endpointWrapper : PrivMXEndpointWrapper  - instance of conected endpointWrapper
  ///     - contextID:String - contextID managed at PrivMXBridge
  ///     - model - instance of class implementing ListModelProtocol, used for maitaining list of stores in the context
  ///
  public func configure(
    endpointWrapper: PrivMXEndpointWrapper,
    contextID: String
  ) {
    self.storeModel.configure(endpointWrapper: endpointWrapper)
    self.contextID = contextID
    self.endpointWrapper = endpointWrapper
      self.model.sortOrder = "desc" 
    self.model.thesame = { $0.storeId == $1.storeId }
    self.model.compare = { $0.filesCount < $1.filesCount }
    self.model.loader = { skip, count, sortOrder, rc in
      AsyncCall {
        var stores = [privmx.endpoint.store.StoreInfo]()
        var available: Int64 = 0

        do {
          let storeResponse = try self.endpointWrapper?.storesApi?.listStores(
            from: self.contextID,
            query: privmx.endpoint.core.ListQuery(
                skip: skip, limit: count, sortOrder: sortOrder.pmxSortOrder))
          stores = storeResponse?.stores.map { $0 } ?? []
          available = Int64(storeResponse?.storesTotal ?? 0)
        } catch PrivMXEndpointError.failedGettingStore(_) {
          NotificationCenter.default.post(
            name: NSNotification.DefaultToast, object: nil,
            userInfo: ["content": "Failed getting Stores"])
          NotificationCenter.default.post(
            name: NSNotification.CriticalError, object: nil, userInfo: ["function": "getStoresList"]
          )
        } catch _ {
          NotificationCenter.default.post(
            name: NSNotification.DefaultToast, object: nil,
            userInfo: ["content": "Unexpected error while getting Stores"])
          NotificationCenter.default.post(
            name: NSNotification.CriticalError, object: nil, userInfo: ["function": "getStoresList"]
          )
        }
        return (available, stores)
      }
      .then { available, stores in
        rc(available, stores)
      }.run() 
    }
  }

  /// Setup of StoresModel
  ///
  /// This function:
  /// - clears data model,
  /// - triggers loading first part of data
  /// - registers listeners for all stores callbacks
  ///
  public func setup() {
    self.model.clear()
    self.model.loadNext()
      self.endpointWrapper?.clearCallbacks(for: EventChannel.store)
      //privmx.endpoint.store.StoreCreatedEvent.self)
      //self.endpointWrapper?.clearCallbacks(for: privmx.endpoint.store.StoreStatsChangedEvent.self)
    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.store.StoreCreatedEvent.self, from: EventChannel.store
    ) {
      data in
      if let store = data as? privmx.endpoint.store.StoreInfo {
        self.model.addNew(store)
      }
    }
    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.store.StoreStatsChangedEvent.self, from: EventChannel.store
    ) {
      data in
      if let data = data as? privmx.endpoint.store.StoreStatsChangedEventData {
        if let i = self.model.data.firstIndex(where: { x in x.storeId == data.storeId }) {
          var newData = self.model.data[i]
          newData.filesCount = data.files
          //no lastFileData in StoreInfo
          self.model.update(newData)
        }
      }
    }
  }

  /// Geting StoreInfo
  ///
  /// This function returns StoreInfo structure for provided storeId
  ///
  /// - Parameters:
  ///     - storeId: Store Identifier obtained from PrivMX Bridge
  ///
  public func getStoreInfo(for storeId: String) throws -> privmx.endpoint.store.StoreInfo {
    if let store = try (self.endpointWrapper?.storesApi?.getStore(storeId)) {
      return store
    } else {
      throw PrivMXEndpointError.otherFailure(
        msg: "Exception while getting StoreInfo for \( storeId)")
    }
  }

  /// Creating new store
  ///
  /// This function creates new Store with given name. Name can repeat in the container.
  /// After successfull creation model is refreshed
  ///
  /// - Parameters:
  ///     - name: String with name
  ///     - users: List of structs UserEntry
  ///     - cb: callback fired when store is created, with StoreId as parameter.
  ///
  public func newStore(
    _ name: String, for users: [UserEntry], managedby managers: [UserEntry],
    cb: @escaping (@Sendable (String) -> Void)
  ) throws {
    if name == "" { return }
    OptionalAsyncCall {
      if let newStoreId = try? self.endpointWrapper?.storesApi?.createStore(
        in: self.contextID, with: users.toUserWithPubKey(), managedBy: managers.toUserWithPubKey(),
        named: name)
      {
        return newStoreId
      }
      return nil
    }.then { newStoreId in
      if let unwrappedNewStoreId = newStoreId {
        Task {
          await self.model.loadNew()
          cb(unwrappedNewStoreId)
        }
      }
    }.run()
  }

  /// Remove existing  store
  ///
  /// This function removes given Store from context
  /// After successfull removal model is refreshed
  ///
  /// - Parameters:
  ///     - storeID:String with Store Identifier
  ///     - cb: callback with result.
  ///
  public func remove(store storeID: String, cb: @escaping (@Sendable (Bool) -> Void)) {
    AsyncCall {
      do {
        guard let storeInfo = try? self.endpointWrapper?.storesApi?.getStore(storeID) else {
          return false
        }
        try self.endpointWrapper?.storesApi?.deleteStore(String(storeInfo.storeId))
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

  public func update(
    users: [UserEntry], managers: [UserEntry], name: String? = nil, force: Bool = false,
    generateNewKeyId: Bool? = nil, accessToOldDataForNewUsers: Bool? = nil,
    cb: @escaping (@Sendable (privmx.endpoint.store.StoreInfo) -> Void)
  ) throws {

    try self.storeModel.update(
      users: users, managers: managers, name: name, force: force, generateNewKeyId: generateNewKeyId
    ) { storeInfo in
      Task {
        await MainActor.run {
          self.model.update(storeInfo)

          self.storeModel.setup(for: storeInfo)
          cb(storeInfo)
        }
      }
    }
  }

}
