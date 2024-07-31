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

struct FolderView: View {
  @Environment(\.colorScheme) var colorScheme

  var folder: privmx.endpoint.store.StoreInfo
  @State var textToSend = ""
  @EnvironmentObject var storeModel: StoreModel

  @EnvironmentObject var appModel: AppModel
  init(folder: privmx.endpoint.store.StoreInfo) {
    self.folder = folder
  }

  var body: some View {
    VStack(spacing: 0) {

      ListComponent<privmx.endpoint.core.FileInfo, String, EmptyView, VStack>(
        .normal,

        withArrow: .none,
        groupingBy: { $0.id },
        sortedBy: { $0.createDate > $1.createDate },
        filteredBy: { element in !element.data.name.toString().starts(with: ".") },
        header: { t, firstEntry in
          EmptyView()
        }
      ) { file in
        VStack {
          FileRow(file: file).environmentObject(self.storeModel).padding(.bottom, 5)
            .contextMenu {
              if file.author.toString() == appModel.me!.name || appModel.me!.isStaff {
                Button {
                  Task {
                    self.storeModel.remove(fileId: file.fileId.toString())
                  }
                } label: {
                  HStack {
                    Icon(size: 15, icon: "trash", color: Color.buttonFront(colorScheme))
                    Text("Delete")
                  }
                }
              } else {
                Text("No actions available for this message.")
              }

            }
        }
      }.environmentObject(self.storeModel.model as ListModel<privmx.endpoint.core.FileInfo>)

    }.onAppear {

      storeModel.setup(for: folder)
    }
    .onChange(of: folder) {
      storeModel.setup(for: folder)
    }
  }
}
