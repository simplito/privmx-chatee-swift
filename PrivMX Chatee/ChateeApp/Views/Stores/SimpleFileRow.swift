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
import SwiftUI

struct SimpleFileRow: View {
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var storeModel: StoreModel
  @State var fileId: String
  @State var fileName: String

  var body: some View {
    HStack(spacing: 0) {
      HStack(spacing: 0) {
        Spacer()
        MultiplatformFileDownloader(fileId: fileId, filename: fileName)
      }
      .overlay {
        ZStack {
          RoundedRectangle(cornerRadius: 5)
            .stroke(Color.frame(colorScheme), lineWidth: 1)
        }.padding([.leading, .trailing], -5)
      }
    }.padding([.leading], 60)
  }
}
