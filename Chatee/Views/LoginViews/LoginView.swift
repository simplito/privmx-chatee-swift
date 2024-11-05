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

import SwiftUI

import AuthenticationServices
import Foundation
import SwiftUI

struct LoginView: View {
  @EnvironmentObject var router: StartupRouter
  @EnvironmentObject var chateeDataController: ChateeDataController

  @State var username: String = ""
  @State var password: String = ""
    
  var body: some View {

    VStack(spacing: 10) {
      Spacer()
      ChateeIcon()
      HStack {
        Text("Log in").font(.title)
        Spacer()
      }
      VerticalSpacer(size: 10)

      HStack {
        Text("Username").font(.headline)
        Spacer()
      }
      TextInput(content: $username)
      HStack {
        Text("Pasword").font(.headline)
        Spacer()
      }
        PasswordInput(content: $password)

      ButtonComponentChatee(
        title: {
          Text("Log In")
        },
        style: .wide
      ) { onFinish in
          Task{
              try? await chateeDataController.login(username: username, password: password)
             
              onFinish()
          }
   
      }

      HStack {
        Text("No Account?")

        ButtonComponentChateeText(
          title: {
            Text("Create new")
          },
          style: .normal
        ) { onFinish in
            router.navigate(to: .createAccount)
          onFinish()
        }

      }
      VerticalSpacer(size: 20)
      HStack {

        
        ButtonComponentChateeText(
          title: {
            Text("Change domain")
          }, style: .normal
        ) { onFinish in
            router.navigateToRoot()
          onFinish()
        }

      }

      Spacer()

    }.padding(40) 
      
  }
}

