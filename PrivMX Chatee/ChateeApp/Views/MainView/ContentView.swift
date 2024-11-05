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

import AuthenticationServices
import Foundation
 
import NotificationCenter
import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme

  @Environment(\.scenePhase) var appScenePhase
  @EnvironmentObject var appModel: AppModel

  @State var showLogIn: Bool = false
  @State var showCreateAccount: Bool = false
  @State var showUserDetailsAndLogout = false
  @State var showDomain = false
  @State var showUserDetails = false
  @State var showConnectionError = false

  @ObservedObject var notificationModel = NotificationModel()

  var body: some View {
    ZStack {
      VStack {

        if showUserDetailsAndLogout && !showConnectionError {
          LeftPanel(showUserDetails: $showUserDetails)
            .environmentObject(appModel)
        }
        if showLogIn {
          LogInView()
            .environmentObject(appModel)
        }
        if showDomain {
          DomainView()
            .environmentObject(appModel)
        }
        if showConnectionError {
          ConnectionErrorView()
        }

      }
      NotificationInfo()
        .environmentObject(self.notificationModel)
    }
    .onChange(of: appScenePhase) {
      appModel.manage(scenePhase: appScenePhase)
    }
    .sheet(isPresented: $showCreateAccount) {
      CreateAccountView()
        .environmentObject(appModel)
    }
    .onAppear {
      self.setupStates()
      self.appModel.configureDomain()
    }
  }

  func setupStates() {
    ApplicationStateManager.global = ApplicationStateManager(states: [
      DomainScreenDisplayState(show: $showDomain),
      LoginScreenDisplayState(show: $showLogIn, appModel: self.appModel),
      GeneratingPrivateKeyState(appModel: self.appModel),
      AuthorizingState(appModel: self.appModel),
      CreatingAccountState(show: $showCreateAccount),
      PlatformConnectingState {
        appModel.connect()
        appModel.registerLibEventCallbacks()
      },
      PlatformConnectedState(
        show: $showUserDetailsAndLogout, appModel: self.appModel),
      PlatformConenctionErrorState(
        show: $showConnectionError, appModel: self.appModel),
    ])
  }

}
