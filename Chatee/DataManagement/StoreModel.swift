//
// PrivMX Chatee Client
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is project demonstrating usage of PrivMX Platform (https://privmx.dev).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative
import SwiftUI

/// `StoreModel` manages the interaction with the PrivMX store, including listing, uploading,
/// and managing files within the connected store. It handles data operations and state management
/// for file-related tasks.
@MainActor
open class StoreModel: ObservableObject {
	
	// MARK: - Properties
		
	/// Reference to the PrivMX endpoint for connection.
	var endpoint: PrivMXEndpoint?

	/// Currently configured store information.
	@Published public var storeInfo: privmx.endpoint.store.Store?

	/// Data model implementing `ListModelProtocol`, used for maintaining the list of files in the opened store.
	@Published public var model = StoreFileInfoListModel()

	// MARK: - Initialization
	
	/// Initializes a new instance of `StoreModel`.
	init() {
		model = StoreFileInfoListModel()
	}
	
	/// Sets the store information for the model.
	/// - Parameter storeInfo: The store information to be configured.
	func set(storeInfo: privmx.endpoint.store.Store) {
		self.storeInfo = storeInfo
	}


	/// Configures the `StoreModel` with an endpoint connection.
   ///
   /// - Parameters:
   ///     - endpoint: The instance of `PrivMXEndpoint` to connect to.
   ///
   /// This method sets up the model with necessary configurations,
   /// including sorting order, comparison logic, and a loader function for files.
   public func configure(
		endpoint: PrivMXEndpoint
	) {

		self.endpoint = endpoint

		self.model.sortOrder = "desc"
		self.model.thesame = { $0.id == $1.id }
		self.model.compare = { $0.info.createDate < $1.info.createDate }
		self.model.loader = { _skip, _count, _sortOrder, _rc in
			Task {
				if let storeInfo = self.storeInfo {
					do {
						let storeResponse = try self.endpoint?
							.storeApi?.listFiles(
								from: String(storeInfo.storeId),
								basedOn: privmx.endpoint.core
									.PagingQuery(
										skip: _skip,
										limit: 10,
										sortOrder:
											_sortOrder
											.pmxSortOrder
									))
						let files =
							storeResponse?.readItems.map { $0 } ?? []
						let available = Int64(
							storeResponse?.totalAvailable ?? 0)
						_rc(available, files)
					} catch PrivMXEndpointError.failedGettingStore(_) {
						NotificationCenter.toast(
							"Failed getting store Files")
						NotificationCenter.critical(in: "getStoreFilesList")
					} catch _ {
						NotificationCenter.toast(
							"Unexpected error when getting store Files")
						NotificationCenter.critical(in: "getStoreFilesList")

					}
				}
			}

		}
	}

	// MARK: - Store Management
	
	/// Sets up the model for a specific store.
	/// - Parameter storeId: The store ID to configure.
	public func setup(store storeId: String) {
		if let store = try? self.endpoint?.storeApi?.getStore(storeId) {
			self.setup(for: store)
		}
	}

	/// Configures the model for a specific store, clearing data and registering callbacks.
	/// - Parameter store: The store information to be set up.
	public func setup(for store: privmx.endpoint.store.Store) {
		self.objectWillChange.send()
		self.storeInfo = store
		self.model.clear()
		self.model.loadNext()
		 
		_ = try? self.endpoint?.registerCallback(
			for: privmx.endpoint.store.StoreFileCreatedEvent.self,
			from: EventChannel.storeFiles(storeID: String(store.storeId)), identified: ""
		) {
			f in
			if let file = f as? privmx.endpoint.store.File {
				Task {
					await self.model.addNew(file)
				}
			}
		}
		_ = try? self.endpoint?.registerCallback(
			for: privmx.endpoint.store.StoreFileDeletedEvent.self,
			from: EventChannel.storeFiles(storeID: String(store.storeId)), identified: ""
		) {
			f in
			if let _ = f as? privmx.endpoint.store.StoreFileDeletedEventData {

			}
		}
		_ = try? self.endpoint?.registerCallback(
			for: privmx.endpoint.store.StoreFileUpdatedEvent.self,
			from: EventChannel.storeFiles(storeID: String(store.storeId)), identified: ""
		) {
			f in
			if let data = f as? privmx.endpoint.store.File {
				Task {
					await self.model.update(data)
				}
			}
		}
	}

	/// Removes a file from the store and reloads the model.
    /// - Parameter file: The file to be removed.
    /// - Throws: An error if the file could not be deleted.
	public func remove(file: privmx.endpoint.store.File) async throws {
		try self.endpoint?.storeApi?.deleteFile(String(file.info.fileId))
		reload()
	}

	/// Reloads the store model, re-fetching the list of files.
    public func reload() {
		self.model.reload()
	}

	/// Removes a file from the store using its ID.
    /// - Parameter fileId: The ID of the file to be removed.
    /// - Throws: An error if the file could not be deleted.
    public func remove(fileId: String) async throws {
		try self.endpoint?.storeApi?.deleteFile(fileId)
		reload()
	}
	
	
	// MARK: - File Upload & Download

	/// Uploads a new file to the store.
	///
	/// - Parameters:
	///     - fileHandle: The handle for the file to be uploaded.
	///     - size: The size of the file.
	///     - store: The ID of the store to upload the file to.
	///     - publicMeta: Public metadata for the file.
	///     - privateMeta: Private metadata for the file.
	/// - Throws: An error if the file could not be uploaded.
	/// - Returns: The ID of the uploaded file, if successful.
	public func uploadNewFile(
		_ fileHandle: FileHandle, withSize size: Int64, to store: String, publicMeta: Data, privateMeta: Data
	) async throws -> String? {

		try await Task {
			return try await self.endpoint?
				.startUploadingNewFile(
					fileHandle,
					to: store,
					withPublicMeta: publicMeta,
					withPrivateMeta: privateMeta,
					sized: size,
					onChunkUploaded: { bytes in

					})
		}.value

	}
	
	/// Creates a new file in the store with the provided metadata.
    ///
    /// - Parameters:
    ///     - storeId: The store ID where the file will be stored.
    ///     - threadId: The thread ID associated with the file (optional).
    ///     - name: The name of the file.
    ///     - fileHandle: The handle for the file to be created.
    ///     - mimetype: The MIME type of the file.
    ///     - size: The size of the file.
    /// - Throws: An error if the file could not be created.
    /// - Returns: The ID of the newly created file, if successful.
    public func newFile(
		in storeId: String, for threadId: String?, name: String, fileHandle: FileHandle,withSize size:Int64,
		mimetype: String
	) async throws -> String? {
		let filePublicMeta = FilePublicMeta(
			name: name, chatId: threadId ?? "", mimetype: mimetype)
		guard let encodedFilePublicMeta = try? JSONEncoder().encode(filePublicMeta) else {
			return nil
		}
		do {
			let newFileId = try await self.uploadNewFile(
				fileHandle,withSize:size, to: storeId, publicMeta: encodedFilePublicMeta,
				privateMeta: Data())
			self.reload()
			return newFileId
		} catch (let err) {
			NotificationCenter.toast(
				"Failed uploading new file: \(err.localizedDescription)")
			NotificationCenter.critical(in: "uploadNewFile")
			return nil
		}

	}

	/// Retrieves file information from the platform.
    /// - Parameter fileId: The ID of the file to retrieve.
    /// - Throws: An error if the file could not be found or retrieved.
    /// - Returns: The file object corresponding to the provided file ID.
    public func fileInfo(fileId: String) throws -> privmx.endpoint.store.File {
		if let file = try (self.endpoint?.storeApi?.getFile(fileId)) {
			return file
		} else {
			var err = privmx.InternalError()
			err.name = "File Info error"
			err.message = "got nil file or stores api was not initialised"
			throw PrivMXEndpointError.otherFailure(err)
		}
	}

	/// Downloads a file from the platform and writes it to a provided file handle.
    ///
    /// - Parameters:
    ///     - fileId: The ID of the file to download.
    ///     - fileHandle: The handle of the local file to write the downloaded data to.
    ///     - onChunkDownloaded: Closure executed for each chunk downloaded.
    /// - Throws: An error if the file could not be downloaded.
    /// - Returns: The ID of the downloaded file, if successful.
    public func downloadFile(
		fileId: String, to fileHandle: FileHandle,
		onChunkDownloaded: @escaping ((Int) -> Void)
		
	) async throws  -> String?{
		
			do {
				guard let fileId = try await self.endpoint?.startDownloadingToFile(
					fileHandle,
					from: fileId,
					onChunkDownloaded: {_ in})
				else {
					var err = privmx.InternalError()
					err.name = "Failed getting file"
					err.message = std.string("File Id: \(fileId)")
					throw PrivMXEndpointError.failedGettingFile(err)
				}
				return fileId
			} catch {
				NotificationCenter.default.post(
					name: NSNotification.DefaultToast, object: nil,
					userInfo: ["content": "Failed downloading File"])
				NotificationCenter.default.post(
					name: NSNotification.CriticalError, object: nil, userInfo: ["function": "getFile"])
			}
		return nil
	}

}

