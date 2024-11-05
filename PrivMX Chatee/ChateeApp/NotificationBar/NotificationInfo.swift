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
import SwiftUI

struct NotificationInfo: View {

  @EnvironmentObject var dataprovider: NotificationModel
  var body: some View {

    VStack {
      Spacer()
      if let content = dataprovider.content {
        HStack {
          Text(content).foregroundColor(.white)
        }.padding(10)
          .background(Color.black).cornerRadius(10)
      }
      VerticalSpacer(size: 20)
    }
  }

}
