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

/// `StoresModel` is responsible for managing the list of stores within a specific context.
/// It handles data retrieval, store creation, deletion, and the management of store events.
@MainActor
open class StoresModel: ObservableObject {
	// MARK: - Properties

	/// Reference to the PrivMX endpoint for connection.
	var endpoint: PrivMXEndpoint?

	/// The context ID associated with the current session.
	var contextID: String?

	/// Data model implementing `ListModelProtocol`, used for maintaining the list of stores in the context.
	@Published public var model: StoreInfoListModel

	/// The default limit for pagination.
	var limit: Int32 = 10

	// MARK: - Initialization

	/// Initializes a new instance of `StoresModel`.
	init() {
		model = StoreInfoListModel()
	}

	// MARK: - Methods

	/// Configures the `StoresModel` with an endpoint and context ID.
	///
	/// > Warning: Requires a valid instance of `PrivMXEndpoint` to manage the stores available in the provided context ID.
	///
	/// - Parameters:
	///   - endpoint: An instance of `PrivMXEndpoint` for the connection.
	///   - contextID: The context ID managed at `PrivMXBridge`.
	public func configure(
		endpoint: PrivMXEndpoint,
		contextID: String
	) {
		self.contextID = contextID
		self.endpoint = endpoint
		self.model.sortOrder = "desc"
		self.model.thesame = { $0.storeId == $1.storeId }
		self.model.compare = { $0.filesCount < $1.filesCount }
		self.model.loader = { skip, count, sortOrder, rc in

			Task {
				if let contextId = self.contextID {
					do {
						let storesResponse = try self.endpoint?
							.storeApi?.listStores(
								from: String(contextId),
								basedOn: privmx.endpoint.core
									.PagingQuery(
										skip: skip,
										limit: 10,
										sortOrder: sortOrder
											.pmxSortOrder
									))
						let stores =
							storesResponse?.readItems.map { $0 } ?? []
						let available = Int64(
							storesResponse?.totalAvailable ?? 0)
						rc(available, stores)
					} catch PrivMXEndpointError.failedGettingStore(_) {
						NotificationCenter.toast("Failed getting Stores")
						NotificationCenter.critical(in: "listStores")
					} catch _ {
						NotificationCenter.toast(
							"Unexpected error when getting Stores")
						NotificationCenter.critical(in: "listStores")

					}
				}
			}

		}
	}

	/// Sets up the `StoresModel` by clearing the current data model and loading the next set of data.
	/// Registers listeners for store-related events.
	public func setup() {
		self.model.clear()
		self.model.loadNext()
		
		_ = try? self.endpoint?.registerCallback(
			for: privmx.endpoint.store.StoreCreatedEvent.self, from: EventChannel.store, identified: ""
		) {
			data in
			if let store = data as? privmx.endpoint.store.Store {
				Task {
					await self.model.addNew(store)
				}
			}
		}
	}

	/// Retrieves the `StoreInfo` for a given store ID.
    ///
    /// - Parameter storeId: The store identifier obtained from the PrivMX bridge.
    /// - Throws: An error if the store could not be retrieved.
    /// - Returns: The `StoreInfo` for the specified store ID.
    public func getStore(for storeId: String) throws -> privmx.endpoint.store.Store {
		if let store = try (self.endpoint?.storeApi?.getStore(storeId)) {
			return store
		} else {
			var err = privmx.InternalError()
			err.name = "Get Store Error"
			err.message = std.string("Exception while getting StoreInfo for \(storeId)")
			throw PrivMXEndpointError.otherFailure(err)
		}
	}

	/// Creates a new store with the specified name and users.
    ///
    /// - Parameters:
    ///   - name: The name of the new store.
    ///   - users: A list of users who will have access to the store.
    ///   - managers: A list of users who will manage the store.
    /// - Throws: An error if the store could not be created.
    /// - Returns: The created `Store` object.
    public func newStore(
		name: String,
		for users: [UserEntry],
		managedBy managers: [UserEntry]
	) async throws -> privmx.endpoint.store.Store {
		let storePrivateMeta = StorePrivateMeta(name: name)
		let storePrivateMetaEncoded = try JSONEncoder().encode(storePrivateMeta)
		guard let contextID = self.contextID else {
			var err = privmx.InternalError()
			err.name = "New Store Error"
			err.message = "ContextId is not set"
			throw PrivMXEndpointError.otherFailure(err)
		}
		guard
			let newStoreId = try self.endpoint?.storeApi?.createStore(
				in: contextID, for: users.toUserWithPubKey(),
				managedBy: managers.toUserWithPubKey(), withPublicMeta: Data(),
				withPrivateMeta: storePrivateMetaEncoded)
		else {
			var err = privmx.InternalError()
			err.name = "New Store Error"
			err.message = "newStore failed"
			throw PrivMXEndpointError.otherFailure(err)
		}

		return try getStore(for: newStoreId)

	}

	/// Removes an existing store from the context.
	///
	/// - Parameter storeID: The identifier of the store to remove.
	/// - Throws: An error if the store could not be removed.
	/// - Returns: A boolean indicating whether the removal was successful.
	public func remove(store storeID: String) async throws -> Bool {

		guard (try? self.endpoint?.storeApi?.getStore(storeID)) != nil else {
			return false
		}
		reload()
		return true
	}
	
	/// Reloads the store list model, triggering a refresh of data.
	public func reload() {
		self.model.reload()
	}

}
