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

@available(macOS 10.15, *)
@MainActor
open class StoreModel: ObservableObject {
  /// Reference to endpointWrapper for connection
  var endpointWrapper: PrivMXEndpointWrapper?

  /// Currently configured store
  @Published public var storeInfo: privmx.endpoint.store.StoreInfo?

  /// Data model implementing ListModelProtocol, used for maitaining list of files in opened store
  @Published public var model = StoreFileInfoListModel()

  func set(storeInfo: privmx.endpoint.store.StoreInfo) {
    self.storeInfo = storeInfo
  }

  init() {
    model = StoreFileInfoListModel()

  }

  /// Initialization of StoreModel
  ///
  /// > Warning: It requires proper instance of PrivMXEndpointWrapper to successfully
  /// > manage Stores available in provided ContextID
  ///
  /// - Parameters:
  ///     - endpointWrapper : PrivMXEndpointWrapper  - instance of conected endpointWrapper
  ///     - model - instance of class implementing ListModelProtocol, used for maitaining list of files in the store
  ///
  public func configure(
    endpointWrapper: PrivMXEndpointWrapper
  ) {

    self.endpointWrapper = endpointWrapper

    self.model.sortOrder = "desc" 
    self.model.thesame = { $0.fileId == $1.fileId }
    self.model.compare = { $0.createDate < $1.createDate }
    self.model.loader = { _skip, _count, _sortOrder, _rc in
        AsyncCall {
            var files = [privmx.endpoint.core.FileInfo]()
            var available: Int64 = 0
            if let storeInfo = self.storeInfo {
                do {
                    let storeResponse = try self.endpointWrapper?.storesApi?.listFiles(
                        from: String(storeInfo.storeId),
                        query: privmx.endpoint.core.ListQuery(skip: _skip, limit: 10, sortOrder: _sortOrder.pmxSortOrder ))
                    files = storeResponse?.files.map { $0 } ?? []
                    available = Int64(storeResponse?.filesTotal ?? 0)
                } catch PrivMXEndpointError.failedGettingStore(_) {
                    NotificationCenter.default.post(
                        name: NSNotification.DefaultToast, object: nil,
                        userInfo: ["content": "Failed getting store Files"])
                    NotificationCenter.default.post(
                        name: NSNotification.CriticalError, object: nil,
                        userInfo: ["function": "getStoreFilesList"])
                } catch _ {
                    NotificationCenter.default.post(
                        name: NSNotification.DefaultToast, object: nil,
                        userInfo: ["content": "Unexpected error when getting store Files"])
                    NotificationCenter.default.post(
                        name: NSNotification.CriticalError, object: nil,
                        userInfo: ["function": "getStoreFilesList"])
                }
            }
            return (available, files)
        }
        .then { available, files in
            _rc(available, files)
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
  ///     - store : StoreInfo  - newly confiugred Store
  ///
  public func setup(for store: privmx.endpoint.store.StoreInfo) {
    self.objectWillChange.send()
    self.storeInfo = store
    self.model.clear()
    self.model.loadNext()
    self.endpointWrapper?.clearCallbacks(for:EventChannel.store)
//    self.endpointWrapper?.clearCallbacks(for: privmx.endpoint.store.StoreFileCreatedEvent.self)
//    self.endpointWrapper?.clearCallbacks(for: privmx.endpoint.store.StoreFileDeletedEvent.self)
//    self.endpointWrapper?.clearCallbacks(for: privmx.endpoint.store.StoreFileUpdatedEvent.self)
    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.store.StoreFileCreatedEvent.self,
      from: EventChannel.storeFiles(storeID: String(store.storeId))
    ) {
      f in
      if let file = f as? privmx.endpoint.core.FileInfo {
        Task {
          self.model.addNew(file)
        }
      }
    }
    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.store.StoreFileDeletedEvent.self,
      from: EventChannel.storeFiles(storeID: String(store.storeId))
    ) {
      f in
      if let data = f as? privmx.endpoint.store.StoreFileDeletedEventData {
        Task {
          self.model.data.removeAll(where: { f in
            f.fileId == data.fileId
          })
        }
      }
    }
    _ = self.endpointWrapper?.registerCallback(
      for: privmx.endpoint.store.StoreFileUpdatedEvent.self,
      from: EventChannel.storeFiles(storeID: String(store.storeId))
    ) {
      f in
      if let data = f as? privmx.endpoint.core.FileInfo {
        Task {
          self.model.update(data)
        }
      }
    }
  }

  public func getFirstFileInfo(
    byName name: String, cb: @escaping @Sendable (privmx.endpoint.core.FileInfo?) -> Void
  ) {
    model.getFilesFromRepository(first: 100) { files in
      Task {
        for file in files {
          if String(file.data.name) == name {
            cb(file)
            return
          }
        }
        cb(nil)
      }
    }
  }
  public func remove(file: privmx.endpoint.core.FileInfo) {
    AsyncCall {
      var resp = false
      do {
        resp = try self.endpointWrapper?.storesApi?.deleteFile(String(file.fileId)) ?? false
      } catch _ {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed deleting file"])
      }
      return resp
    }.then { success in
      Task {
        await self.reload()
      }
    }.run()
  }

  public func reload() {
    self.model.reload()
  }
  public func remove(fileId: String) {
    AsyncCall {
      var resp = false
      do {
        resp = try self.endpointWrapper?.storesApi?.deleteFile(fileId) ?? false
      } catch _ {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed deleting file"])
      }
      return resp
    }.then { success in
      Task {
        await self.reload()
      }
    }.run()
  }

  public func uploadNewFile(
    _ file: FileHandle, to store: String, named: String, sized: Int64, mimetype: String,
    onChunkUploaded: @escaping ((Int) -> Void) = { _ in },
    onFileUploaded: @escaping ((String) -> Void) = { _ in }
  ) {
    AsyncCall {
        Task{
            do {
                
                try await self.endpointWrapper?.startUploadingNewFile(
                    file, to: store, sized: sized, mimetype: mimetype, named: named,
                    onChunkUploaded: onChunkUploaded, onFileUploaded: onFileUploaded)
            } catch {
                NotificationCenter.default.post(
                    name: NSNotification.DefaultToast, object: nil,
                    userInfo: ["content": "Failed uploading new File"])
                NotificationCenter.default.post(
                    name: NSNotification.CriticalError, object: nil, userInfo: ["function": "uploadNewFile"])
            }
        }
    }.run()
  }

  public func uploadUpdatedFile(
    _ file: FileHandle, storeFileId: String, name: String, size: Int64, mimetype: String,
    onFileUploaded: @escaping ((String) -> Void)
  ) {
    AsyncCall {
      do {
        try self.endpointWrapper?.startUploadingUpdatedFile(
          file,
          storeFile: storeFileId,
          sized: size,
          mimetype: mimetype,
          named: name,
          onFileUploaded: onFileUploaded)
      } catch {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed uploading updated File"])
        NotificationCenter.default.post(
          name: NSNotification.CriticalError, object: nil,
          userInfo: ["function": "uploadupdatedFile"])
      }
    }.run()
  }

  public func newFile(
    _ name: String, data: Data, mimetype: String, cb: @escaping ((String) -> Void)
  ) {
    guard let storeId = self.storeInfo?.storeId else { return }
    Task {
      guard
        let newFileID = try? self.endpointWrapper?.uploadNewFile(
          in: String(storeId), data: data, mimetype: mimetype, name: name)
      else {
        cb("?")
        return
      }
      cb(String(newFileID))
      //reload()
    }
  }

  @MainActor
  public func updateFile(
    _ name: String, data: Data, mimetype: String, cb: @escaping (@Sendable (String) -> Void)
  ) {
    guard let storeId = self.storeInfo?.storeId else { return }
    Task {
      let storeFileData = privmx.endpoint.store.StoreFileData(
        mimetype: std.string(mimetype), name: std.string(name), data: data.rawCppString(),
        size: Int64(data.count))

      getFirstFileInfo(byName: String(storeFileData.name)) { fileinfo in
        Task {
          if let fileInfo = fileinfo {

            if let newFileID = try? await self.endpointWrapper?.uploadUpdatedFile(
              String(fileInfo.fileId), data: data, mimetype: mimetype, name: name)
            {
              cb(String(newFileID))
            }
          } else {
            if let newFileID = try? await self.endpointWrapper?.uploadNewFile(
              in: String(storeId), data: data, mimetype: mimetype, name: name)
            {
              cb(String(newFileID))
            }

          }

        }
      }
    }
  }

  public func updateFile(
    id fileId: String, name: String, fileHandle: FileHandle, mimetype: String, fileSize: Int64,
    onChunkUploaded: @escaping ((Int) -> Void) = { _ in },
    onFileUploaded: @escaping ((String) -> Void) = { _ in }
  ) {
    Task {
      try? self.endpointWrapper?.startUploadingUpdatedFile(
        fileHandle, storeFile: fileId, sized: fileSize, mimetype: mimetype, named: name,
        onChunkUploaded: onChunkUploaded, onFileUploaded: onFileUploaded)
    }
  }

    public func fileInfo(fileId: String) throws -> privmx.endpoint.core.FileInfo {
    if let file = try (self.endpointWrapper?.storesApi?.getFile(fileId)) {
      return file
    } else {
      throw PrivMXEndpointError.otherFailure(msg: "got nil file or stores api was not initialised")
    }
  }

  public func getFile(fileId: String, cb: @escaping (@Sendable (Data) -> Void)) {
    AsyncCall {
      do {
        if let filedata = try self.endpointWrapper?.downloadFile(fileId: fileId) {
          return filedata
        }
      } catch (_) {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed reading File"])
        NotificationCenter.default.post(
          name: NSNotification.CriticalError, object: nil, userInfo: ["function": "downloadFile"])
      }
      return Data(from: "")
    }.then { data in
      cb(data)
    }.run()
  }

  /// Adding store users
  ///
  /// This function updates  Store with given Users. It replaces user and manager list for the store with provided lists.
  /// Unless specified, the name and version will be taken from the stored StoreInfo
  ///
  /// - Parameters:
  ///     - users: List of structs UserEntry
  ///     - managers: List of structs UserEntry
  ///     - name: Optional String representing new name
  ///     - verion: Optional Int64 representing the version to be updated
  ///     - force: Bool declaring if the update ought to be forced
  ///     - generateNewKeyID: Optional Bool
  ///     - accessToOldDataForNewUsers: Optional Bool
  ///     - cb: callback fired when store is updated.
  ///
  public func update(
    users: [UserEntry], managers: [UserEntry], name: String? = nil, force: Bool = false,
    generateNewKeyId: Bool? = nil, accessToOldDataForNewUsers: Bool? = nil,
    cb: @escaping (@Sendable (privmx.endpoint.store.StoreInfo) -> Void)
  ) throws {

    OptionalAsyncCall {
      do {
        try? self.endpointWrapper?.storesApi?.updateStore(
          String(self.storeInfo!.storeId),
          users: users.toUserWithPubKey(),
          managers: managers.toUserWithPubKey(),
          name: name ?? String(self.storeInfo!.data.name),
          version: self.storeInfo!.version,
          force: force,
          generateNewKeyId: generateNewKeyId ?? false,
          accessToOldDataForNewUsers: accessToOldDataForNewUsers ?? false)

        let storeInfo = try self.endpointWrapper?.storesApi?.getStore("\(self.storeInfo!.storeId)")
        if let storeInfo = storeInfo {
          self.set(storeInfo: storeInfo)
        }

        return storeInfo
      } catch {}
      return self.storeInfo!
    }.then { result in
      Task {
        await MainActor.run {
          cb(result!)
        }
      }

    }.run()
  }

  /// Getting file with stream...
  ///
  /// This function updates  Store with removing given Users. It only adds provided users if not existent
  ///
  /// - Parameters:
  ///     - fileId: File ID
  ///     - fileHandle: FileHandle to local file
  ///     - onChunkDownloaded: /size/ fired each time a chunk was downloaded
  ///     - onFileDownloaded: /fileId/ fired when the file finishes downloading.
  ///
  public func getFile(
    fileId: String, fileHandle: FileHandle, onChunkDownloaded: @escaping ((Int) -> Void),
    onFileDownloaded: @escaping ((String) -> Void)
  ) throws {
    AsyncCall {
      do {
        try self.endpointWrapper?.startDownloadingToFile(
          fileHandle,
          from: fileId,
          onChunkDownloaded: onChunkDownloaded,
          onFileDownloaded: onFileDownloaded)
      } catch {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: ["content": "Failed downloading File"])
        NotificationCenter.default.post(
          name: NSNotification.CriticalError, object: nil, userInfo: ["function": "getFile"])
      }
    }.then {}.run()
  }

}

extension String: Sendable {}
