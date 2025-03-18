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

import Alamofire
import Foundation
import SwiftUI

/// `ChateeDataController` is responsible for managing the data and network interactions
/// for the PrivMX Chatee Client. It handles user login, account creation, and connection
/// to the platform's services via a secure API.
@MainActor
public class ChateeDataController: ObservableObject {

  // MARK: - Properties

  /// Client for making API requests to the Chatee server.
  var apiClient: ChateeServerClient?

  /// Router responsible for handling startup navigation.
  var startupRouter: StartupRouter?

  /// Network changes listener from Alamofire.
  let reachabilityManager = NetworkReachabilityManager()

  /// Controller for managing the endpoint connection and state.
  var endpointController = EndpointController()

  /// Token for domain authentication.
  @Published var domainToken: String = ""

  /// Name of the domain the user is connecting to.
  @Published var domainName: String = ""

  /// Full domain URL.
  @Published var fullDomain: String = ""

  /// Currently authenticated user.
  @Published var currentUser: UserEntry?
	
  /// Connection status
  @Published  var connectionState = ConnectionState.notConnected
  
  /// All cached connection data
  @Published var contextId: String?
  @Published var solutionId: String?
  @Published var bridgeURL: String?
  private var privKey: String?
	
  // MARK: - Initializer

  /// Initializes a new instance of `ChateeDataController`.
  init() {

    self.manageNetworkState()

  }

  // MARK: - Methods

  /// Clears the stored data including user information and tokens.
  func clearData() {
	//Clearing connection data
	self.connectionState = .notConnected
	self.domainToken = ""
	self.currentUser = nil
	self.privKey = nil
	self.contextId = nil
	self.solutionId = nil
	self.bridgeURL = nil
  }

  /// Sets up the startup router for navigation.
  /// - Parameter startupRouter: Router responsible for startup navigation.
  func setRouters(startupRouter: StartupRouter) {
    self.startupRouter = startupRouter

  }


  /// Configures the platform connection data.
  /// - Parameters:
  ///   - privKey: Private key of the user.
  ///   - contextId: The context ID, provided by the chatee server.
  ///   - solutionId: The solution ID for the Brifge, provided by the chatee server
  ///   - bridgeURL: The URL of the Bridge to connect to, provided by the chatee server
  func setPlatformConnectionData(
    privKey: String, contextId: String, solutionId: String, bridgeURL: String
  ) async {
	  
    self.privKey = privKey
    self.contextId = contextId
    self.solutionId = solutionId
    self.bridgeURL = bridgeURL
    
  }

  /// Establishes a secure connection with PrivMX Bridge
  func connect() async throws {
	  if self.connectionState == .connected { throw ChateeError.alreadyConnected }
   

	  let localEndpointController = endpointController
	  guard let privKey = privKey else { throw ChateeError.noConnectionData }
	  guard let contextId = contextId else { throw ChateeError.noConnectionData }
	  guard let solutionId = solutionId else { throw ChateeError.noConnectionData }
	  guard let bridgeURL = bridgeURL else { throw ChateeError.noConnectionData }
	
	  Task {
		
	  if let connectionId = await localEndpointController.connect(
		platformURL: bridgeURL,
		solutionId: solutionId,
		contextId: contextId,
		currentUserPrivKey: privKey) {
		  
		  //connection established
		  await localEndpointController.enableEvents()
		  self.connectionState = .connected
		  
		}
	  }
  }

  /// Restarts the connection
  func reviveConnection() async throws {
	try await self.connect()
  }

  /// Pauses the connection
  func pauseConnection() async throws {
    if self.connectionState == .notConnected { throw ChateeError.notConnected }

	let localEndpointController = self.endpointController

    Task {
      do {
        try await localEndpointController.stopConnection()
      } catch (let e) {
        //stopping connection error.
      }
      self.connectionState = .notConnected
    }
  }
 
  /// Helper function managing network state with use of Alamofir
  /// In real world app it requires additional steps for handling other steps.
  func manageNetworkState() {
    reachabilityManager?.startListening { status in
      switch status {
      case .notReachable:
        Task {
		  try? await self.showUnreachable()
          try? await self.dropConnection()
          await self.clearData()

        }
      default:
        print("Handle other states here")
        // Handle unknown state here
      }
    }
  }

  /// Drops Connections on network Loss.
	func dropConnection() async throws {
	  try await pauseConnection()
	  self.clearData()
	}

	/// changes View  route for unreachable information
	func showUnreachable() async throws {
		self.startupRouter?.navigate(to: .networkUnreachable)
	}

  /// Validates and sets the domain name, stripping HTTP/HTTPS if necessary.
  /// - Parameter fullDomain: Full domain URL.
  /// - Throws: `ChateeError.invalidDomain` if the domain is invalid.
  func setdomainName(_ fullDomain: String) throws {
    var _fullDomain = fullDomain
    if fullDomain.starts(with: "http://") {
      _fullDomain =
        _fullDomain
        .replacingOccurrences(of: "http://", with: "")
	} else if fullDomain.starts(with: "https://"){
		_fullDomain =
		_fullDomain
			.replacingOccurrences(of: "https://", with: "")
	} else {
		throw ChateeError.invalidDomain
	}
    if _fullDomain.isValidDomain() {
      self.fullDomain = fullDomain
      self.domainName = String(_fullDomain.split(separator: ".").first ?? "")
      startupRouter?.navigate(to: StartupRouter.Destination.login)

      self.setupSession()

    } else {
      throw ChateeError.invalidDomain
    }
  }

  /// Sets up the session for the user with or without a domain token. Token is required for all authorized requests.
  /// - Parameter domainToken: Token for authentication (optional).
  func setupSession(domainToken: String = "") {
    self.domainToken = domainToken
    if domainToken.isEmpty {

		let customTrustManager = ServerTrustManager(evaluators: ["\(fullDomain)": DisabledTrustEvaluator()])
		let sessionManager = Session(serverTrustManager: customTrustManager)
      self.apiClient = ChateeServerClient(
        baseURL: "\(self.fullDomain)",
        sessionManager: sessionManager,
        defaultHeaders: [:])
    } else {
      let sessionManager = Session()
      self.apiClient = ChateeServerClient(
        baseURL: "\(self.fullDomain)",
        sessionManager: sessionManager,
        defaultHeaders: ["Authorization": "Bearer \(domainToken)"])
    }
  }

  /// Logs in the user with the provided username and password, establishing a session.
  /// - Parameters:
  ///   - username: The user's username.
  ///   - password: The user's password.
  /// - Throws: `ChateeError.invalidLogin` if login fails.
  func login(username: String, password: String) async throws {

    do {
      guard
        let privKey = try? self.endpointController.endpointContainer
          .cryptoApi.derivePrivateKey2(from: username, and: password)
      else {
        throw ChateeError.errorGeneratingPrivKey
      }

      guard let userNameData = username.data(using: .utf8) else {
        throw ChateeError.invalidSignature
      }

      guard
        let signedUserName = try? self.endpointController.endpointContainer
          .cryptoApi.signData(userNameData, with: privKey)
          .hexEncodedString()
      else {
        throw ChateeError.invalidSignature
      }

      guard
        let pubKey = try? self.endpointController.endpointContainer
          .cryptoApi.derivePublicKey(from: privKey)
      else {
        throw ChateeError.errorGeneratingPubKey
      }

      let signInBody = SignInBody(
        sign: signedUserName, domainName: self.domainName,
        username: username)
      let signInRequest = API.SignIn.PostSignIn.Request(body: signInBody)

      switch await self.apiClient?.makeRequest(signInRequest) {
      case .success(let r):

        self.setupSession(domainToken: r.token)
        self.currentUser = UserEntry(
          name: username, publicKey: pubKey,
          isStaff: r.isStaff)
        await self.setPlatformConnectionData(
          privKey: privKey, contextId: r.cloudData.contextId,
          solutionId: r.cloudData.solutionId,
          bridgeURL: r.cloudData.platformUrl)

        try? await self.connect()

      case .failure(_):

        self.clearData()

      default:

        self.clearData()
        throw ChateeError.unknownError
      }

    } catch {
      throw ChateeError.invalidLogin
    }

  }

  /// Creates a new user account with the provided credentials and invitation token.
  /// - Parameters:
  ///   - username: The desired username.
  ///   - password: The user's password.
  ///   - invitationToken: Invitation token required for account creation.
  /// - Throws: `ChateeError.unknownError` if account creation fails.
  /// - Returns: Boolean indicating whether account creation was successful.
  func createAccount(username: String, password: String, invitationToken: String) async throws
    -> Bool
  {

    do {
      guard
        let privKey = try? self.endpointController.endpointContainer
          .cryptoApi.derivePrivateKey2(from: username, and: password)
      else {
        throw ChateeError.errorGeneratingPrivKey
      }
      guard
        let pubKey = try? self.endpointController.endpointContainer
          .cryptoApi.derivePublicKey(from: privKey)
      else {
        throw ChateeError.errorGeneratingPubKey
      }

      let signUpBody = SignUpBody(
        inviteToken: invitationToken, publicKey: pubKey, username: username)

      let signUpRequest = API.SignUp.PostSignUp.Request(body: signUpBody)

      switch await self.apiClient?.makeRequest(signUpRequest) {
      case .success(_):
        return true

      default:

        self.clearData()
        throw ChateeError.unknownError
      }

    } catch {
      return false
    }
  }

  /// Fetches the list of all users from the server, and coverts it to `UserEntry` array .
  /// - Returns: An array of `UserEntry` representing the users.
  /// - Throws: An error if the users could not be retrieved.
  func getAllUsers() async throws -> [UserEntry] {
    if let allUsers = try await retrieveAllUsers()?.contacts.map({
      UserEntry(name: $0.username, publicKey: $0.publicKey, isStaff: $0.isStaff)
    }) {
      return allUsers
    } else {
      return [UserEntry]()
    }
  }

  /// Retrieves the list of all users from the server.
  /// - Returns: A `ContactsResponse` containing the user data, or nil if there was an error.
  private func retrieveAllUsers() async throws -> ContactsResponse? {
    let getContactsRequest = API.Contacts.GetContacts.Request(body: EmptyBody())

    switch await self.apiClient?.makeRequest(getContactsRequest) {
    case .success(let r):
      return r
    default:
      NotificationCenter.toast("Error getting users from Chatee Server")
      return nil
    }
  }

}
