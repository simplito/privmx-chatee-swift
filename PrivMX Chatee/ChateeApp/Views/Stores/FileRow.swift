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

#if os(iOS)
  import MobileCoreServices
  import UniformTypeIdentifiers
#endif

struct FileRow: View {

  @Environment(\.colorScheme) var colorScheme
  @State var file: privmx.endpoint.core.FileInfo
  @EnvironmentObject var filesList: StoreModel

  init(file: privmx.endpoint.core.FileInfo) {
    self._file = State(initialValue: file)
  }

  var body: some View {
    HStack {

      VStack {
        HStack {

          VStack {
            HStack {
              HStack {
                Icon(size: 25, icon: "file", color: Color.buttonBackgrouund(colorScheme))
              }.frame(width: 30)
              VStack {
                HStack(spacing: 0) {
                  Text(String(file.data.name)).lineLimit(1).fontWeight(.bold)
                  Spacer()
                }
                HStack(spacing: 0) {
                  AvatarSmall(author: .constant(file.author.toString()))
                  Text(file.author.toString()).font(.subheadline).padding(.trailing, 10)
                  Text(String(file.createDate.convertInt64ToDate() ?? "")).font(.subheadline)
                    .padding(.trailing, 10)
                  Text(String(file.size / 1024)).font(.footnote)
                  Text(" KB").font(.footnote)
                  Spacer()
                }
              }
              Spacer()

              HStack {
                MultiplatformFileDownloader(
                  fileId: $file.fileId.wrappedValue.toString(),
                  filename: $file.data.name.wrappedValue.toString())

              }

            }

          }
          Spacer()

        }.padding(10)

      }
      .overlay {
        VStack {
          RoundedRectangle(cornerRadius: 5).stroke(Color.frame(colorScheme), lineWidth: 1)
        }
      }

    }
  }
}
