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
open class AppModel: ObservableObject {

  @Published var handledInactive = false
  @Published var me: UserEntryAdmin?

  @Published var login: String = ""
  @Published var password: String = ""
  @Published var privkey: String = ""
  @Published var pubKey: String = ""
  @Published var domain: String = ""

  var onConnectExecutor: OnConnectExecutor = OnConnectExecutor()
  var endpointContainer: EndpointContainer = EndpointContainer()

  @Published var storesModel: StoresModel = StoresModel(storeModel: StoreModel())
  @Published var threadsModel: ThreadsModel = ThreadsModel(threadModel: ThreadModel())

  var apiConnect: ApiConnect?

  open func updateDomain(_ givenDomain: String? = nil) -> Bool {
    if let newDomain = givenDomain {
      self.domain = newDomain
    }
    if let validDomain = self.domain.cleanDomain() {
      self.apiConnect = ApiConnect(domain: validDomain)
      return true
    }
    return false
  }
    
    open func set(privKey:String){
        self.privkey = privKey
    }

  /// Configuring platform with ApiConnect result
  ///
  /// > Warning: It requires ApiConnect to successfully
  /// > authorize with Chatee API
  /// > and to provide contextID and user Information.
  ///
  /// - Parameters:
  ///     - none.
  ///
  /// - Returns: AppSetupState.
  open func setup() throws -> AppSetupState {
    guard let CONTEXTID = apiConnect?.contextId else { return .failed }
    let USERNAME = login
    let USERPUBKEY = pubKey

    guard let ISSTAFF = apiConnect?.isStaff else { return .failed }
    self.me = UserEntryAdmin(name: USERNAME, publicKey: USERPUBKEY, isStaff: ISSTAFF)

    try self.endpointContainer.setCertsPath(
      directoryPath: FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask)[0],
      filename: "cacert.pem")

    onConnectExecutor.onConnect {
      if let endpointWrapper = self.endpointContainer.endpoints[ENDPOINT_NAME] {
        self.storesModel = StoresModel(storeModel: StoreModel())
        self.threadsModel = ThreadsModel(threadModel: ThreadModel())
        self.storesModel.configure(endpointWrapper: endpointWrapper, contextID: CONTEXTID)
        self.threadsModel.configure(endpointWrapper: endpointWrapper, contextID: CONTEXTID)
        self.threadsModel.threadModel.storesModel = self.storesModel

      }
    }

    return .success
  }

  func setup(
    endpointName: String,
    domain: String,
    password: String,
    privkey: String,
    login: String,
    pubKey: String
  ) {
    endpointContainer.endpoints.removeValue(forKey: endpointName)
    endpointContainer.endpoints[endpointName]?.stopListening()
    self.apiConnect = ApiConnect(domain: domain)
    self.password = password
    self.privkey = privkey
    self.login = login
    self.pubKey = pubKey
  }

  open func disconnect() {
    if !(endpointContainer.endpoints.isEmpty) {
      endpointContainer.endpoints[ENDPOINT_NAME]?.stopListening()
//      endpointContainer.endpoints[ENDPOINT_NAME]?.storesApi = nil
//      endpointContainer.endpoints[ENDPOINT_NAME]?.threadsApi = nil
        try? endpointContainer.endpoints[ENDPOINT_NAME]?.coreApi.disconnect()
      if !(endpointContainer.endpoints.isEmpty) {
        endpointContainer.endpoints.removeValue(forKey: ENDPOINT_NAME)
      }
    }
  }

  /// Connecting to PrivMX Platform.
  /// After successfull connections it clears
  /// password and privkey AppModel properties.
  ///
  /// > Warning: It requires ApiConnect to successfully
  /// > authorize with Chatee API
  /// > and to provide platformURL and  solutionID
  /// > as well as Users PrivateKey.
  ///
  /// - Parameters:
  ///     - none.
  ///
  open func connect() {
    guard let PMXENDPOINT = apiConnect?.platformURL else { return }
    guard let PMXSOLUTION = apiConnect?.solutionID else { return }
    do {
      if try setup() == .success {
        try endpointContainer.newEndpoint(
          ENDPOINT_NAME,
          modules: [.thread, .store], userPrivKey: self.privkey,
          solutionId: PMXSOLUTION, platformUrl: PMXENDPOINT)
        onConnectExecutor.performOnConnect()
        threadsModel.setup()
        storesModel.setup()
        ApplicationStateManager.global?.enter(PlatformConnectedState.self)
      } else {
        ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
      }
    } catch PrivMXEndpointError.failedConnecting(_) {
      ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
    } catch {
      ApplicationStateManager.global?.enter(PlatformConenctionErrorState.self)
    }
  }

  /// Clearing password and key cache
  public func clearPasswordCache() {
    self.password = ""
    self.privkey = ""
  }

  /// Manages app state.
  /// Pauses and restarts endpoint event sertvices upon scene phase changes
  ///
  /// - Parameters:
  ///     - scenePhase: ScenePhase.
  ///
  public func manage(scenePhase: ScenePhase) {
    switch scenePhase {
    case .active:
        try? self.endpointContainer.endpoints[ENDPOINT_NAME]?.startListening(){ err in}
      handledInactive = false
    case .inactive:
      if !handledInactive && nil != self.apiConnect?.signInResponse {
        self.endpointContainer.endpoints[ENDPOINT_NAME]?.stopListening()
      }
    case .background:
      if !handledInactive && nil != self.apiConnect?.signInResponse {
        self.endpointContainer.endpoints[ENDPOINT_NAME]?.stopListening()
        self.handledInactive = true
      }
    @unknown default:
      fatalError()
    }

  }

  /// Manages PrivMX Endpoint State.
  /// Manages reactions on Endpoint Connections State and provides proper UI Reaction
  ///
  /// - Parameters:
  ///     - none.
  ///
  public func registerLibEventCallbacks() {
    _ = self.endpointContainer.endpoints[ENDPOINT_NAME]?.registerCallback(
      for: privmx.endpoint.core.LibConnectedEvent.self, from: .platform
    ) {
      _ in
      //PrivMX Endpoint connected
    }
    _ = self.endpointContainer.endpoints[ENDPOINT_NAME]?.registerCallback(
      for: privmx.endpoint.core.LibPlatformDisconnectedEvent.self, from: .platform
    ) {
      _ in
      //PrivMX Endpoint disconnected
      self.endpointContainer.endpoints[ENDPOINT_NAME]?.stopListening()

    }
    _ = self.endpointContainer.endpoints[ENDPOINT_NAME]?.registerCallback(
      for: privmx.endpoint.core.LibDisconnectedEvent.self, from: .platform
    ) {
      _ in
      //PrivMX Endpoint disconnected
      if !self.handledInactive {
        NotificationCenter.default.post(
          name: NSNotification.DefaultToast, object: nil,
          userInfo: [
            "content":
              "Lost Connection, returning to login screen"
          ])
        ApplicationStateManager.global?.enter(
          PlatformConenctionErrorState.self)
      }
    }
  }

  //Configuring domain with data saved in UserDefaults
  public func configureDomain() {
    if let storedDomain = UserDefaults.standard.string(forKey: "storedDomain") {

      if updateDomain(storedDomain) {
        ApplicationStateManager.global?.enter(
          LoginScreenDisplayState.self)
      }
    } else {
      ApplicationStateManager.global?.enter(DomainScreenDisplayState.self)
    }
  }

}
