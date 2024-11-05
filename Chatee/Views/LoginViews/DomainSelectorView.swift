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

struct DomainSelectorView: View {
    @EnvironmentObject var router: StartupRouter
    @EnvironmentObject var chateeDataController: ChateeDataController
    @State var domain = ""
    var body: some View {
        
        VStack(spacing: 10) {
            Spacer()
            
            ChateeIcon()
            
            HStack {
                Text("What is Your Domain? ").font(.title)
                Spacer()
            }
            VerticalSpacer(size: 10)
            
            HStack {
                Text("Domain name").font(.headline)
                Spacer()
            }
            TextInput(content: $domain)
            
            ButtonComponentChatee(
                title: {
                    Text("Next")
                },
                style: .wide
            ) { onFinish in
                try? self.chateeDataController.setdomainName( self.domain )
            }
            
            Spacer()
        }.padding(40)
        
    }
    
    
    
}
