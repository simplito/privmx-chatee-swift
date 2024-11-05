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

import Alamofire
 
import SwiftUI

let ENDPOINT_NAME = "Chatee"

@main
struct ChateeApp: App {

  @Environment(\.scenePhase) var scenePhase
  @ObservedObject var appModel = AppModel()

  var body: some Scene {
    #if os(iOS)
      WindowGroup {
        ContentView().environmentObject(appModel)

          .onAppear {
          }
          .environmentObject(self.appModel)
      }
    #else
      Window("PrivMX Chatee", id: "Chatee") {
        ContentView().environmentObject(appModel)

          .onAppear {
          }
          .environmentObject(self.appModel)

      }.commands {
        CommandGroup(replacing: .newItem, addition: {})
      }
    #endif
  }
}
