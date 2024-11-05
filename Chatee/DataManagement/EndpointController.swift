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

import Combine
import Foundation
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative

/// `EndpointController` manages the connection between the client and the PrivMX platform.
/// It handles the creation, management, and lifecycle of the endpoint used for communication.

class EndpointController: ObservableObject {

	// MARK: - Properties
		
	
	/// Container that manages the lifecycle and state of the endpoints.
	var endpointContainer: PrivMXEndpointContainer = PrivMXEndpointContainer()

	/// The current connection ID, if any.
	var currentConnectionId: Int64?


	/// The current active endpoint, if a connection exists.
	var currentEndpoint: PrivMXEndpoint? {
		if let currentConnectionId = currentConnectionId {
			return endpointContainer.getEndpoint(currentConnectionId)
		} else {
			return nil
		}
	}

	
	// MARK: - Methods

	/// Sets the current connection ID for the active session.
	/// - Parameter connectionId: The connection ID to set as the current connection.
	func setCurrentConnectionId(_ connectionId: Int64) {
		self.currentConnectionId = connectionId
	}

	/// Initiates a new connection to the platform using the provided private key.
	/// If an existing connection is active, it is disconnected first.
	/// - Parameter currentUserPrivKey: The private key for authenticating the connection.
	/// - Throws: An error if the connection could not be established.
	func performConnect(currentUserPrivKey: String, solutionId:String, platformURL:String) async throws -> Int64?{

		
		// Disconnect the current connection if one exists
		if self.currentConnectionId != nil {
			self.currentEndpoint?.clearAllCallbacks()
			try? self.currentEndpoint?.connection.disconnect()
		}

		// Establish a new connection with the specified parameters
		let currentConnection = try await self.endpointContainer.newEndpoint(
			enabling: [.store, .thread], connectingAs: currentUserPrivKey,
			to: solutionId, on: platformURL)

		// Store the new connection ID
		self.currentConnectionId = currentConnection.id
		return currentConnectionId
		
	}
	
	/// Ends all PrivMX Bridge connections and stops Event Loops.
	func stopConnection() async throws{
		guard let brokenConnectionId:Int64 = currentConnectionId else {return}
		try await endpointContainer.stopListening()
		endpointContainer.getEndpoint(brokenConnectionId)?.clearAllCallbacks()
		try endpointContainer.disconnectAll()
		currentConnectionId = nil
	}
	
	/// Prepares connection to the PrivMX platform with the specified parameters.
    /// - Parameters:
    ///   - platformURL: The URL of the platform to connect to.
    ///   - solutionId: The solution ID for the connection.
    ///   - contextId: The context ID for the current session.
    ///   - currentUserPrivKey: The private key of the current user (optional).
    /// If the private key is provided, the connection is established.
	func connect(
		platformURL: String, solutionId: String, contextId: String,
		currentUserPrivKey: String?
	) async -> Int64? {
		
		if let currentUserPrivKey = currentUserPrivKey {

			try! self.endpointContainer.setCertsPath(
				to: Bundle.main.url(forResource: "cacert", withExtension: "pem")!.path()
				)

			return try? await performConnect(currentUserPrivKey: currentUserPrivKey, solutionId:solutionId, platformURL: platformURL)

		}
		
		return nil

	}

	/// starts Event Loops.
	func enableEvents() async {
			try? await self.endpointContainer.startListening()
	}

	

}
