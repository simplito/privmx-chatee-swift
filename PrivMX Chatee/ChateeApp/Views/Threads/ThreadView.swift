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

struct ThreadView: View {
  @Environment(\.colorScheme) var colorScheme

  @EnvironmentObject var threadModel: ThreadModel
  @EnvironmentObject var appModel: AppModel

  var thread: privmx.endpoint.thread.ThreadInfo
  @State var textToSend = ""
  @State var showFiles = false
  @Binding var selected: String

  init(thread: privmx.endpoint.thread.ThreadInfo, selected: Binding<String>) {
    self.thread = thread
    self._selected = selected
  }

  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        VStack(spacing: 0) {

          HStack {
            Image(systemName: "text.bubble").frame(width: 20)

            Text(String(thread.data.titleDecoded)).font(.title2)
            Spacer()

            HStack(spacing: 0) {

              ToggleComponentChatee(
                isActive: $showFiles,
                title: {
                  Icon(
                    size: 25, icon: "messages",
                    color: showFiles
                      ? Color.buttonBackgrouund(colorScheme) : Color.buttonFront(colorScheme))
                }, style: .normal
              ) { onFinish in
                showFiles.toggle()
                onFinish()
              }
              ToggleComponentChatee(
                isActive: !$showFiles,
                title: {
                  Icon(
                    size: 25, icon: "files",
                    color: !showFiles
                      ? Color.buttonBackgrouund(colorScheme) : Color.buttonFront(colorScheme))

                }, style: .normal
              ) { onFinish in
                showFiles.toggle()
                onFinish()
              }
            }.background { Color.buttonFront(colorScheme) }.cornerRadius(5)
            ButtonComponentChatee(
              title: {
                Icon(size: 25, icon: "paperclip", color: Color.buttonFront(colorScheme))

              }, style: .normal
            ) { onFinish in
              MultiplatformFileSelector(
                { name, data, mimetype in
                  threadModel.storesModel?.storeModel.newFile(name, data: data, mimetype: mimetype)
                  { result in

                    let messageFileUpload = MessageFileUpload(
                      type: "fileupload",
                      storeId: String(threadModel.storesModel!.storeModel.storeInfo!.storeId),
                      fileId: result, fileName: name, fileMimeType: mimetype)
                    let content = JSONEncoder().encodeToString(messageFileUpload)
                    self.threadModel.send(message: content, from: appModel.me!.userEntry)

                    onFinish()
                  }
                },
                onCancel: {
                  onFinish()
                }
              )
              .selectFile()
            }

          }
          .padding()

          Rectangle().foregroundColor(.black.opacity(0.1)).frame(height: 1)
          if showFiles {
            VStack {
              if let storeInfo = self.threadModel.storesModel?.storeModel.storeInfo {
                FolderView(folder: storeInfo)
                  .environmentObject(threadModel.storesModel!.storeModel)
              }
            }
          } else {
            ListComponent<privmx.endpoint.core.Message, String, HStack, ZStack>(
              .reversed,
              withArrow: .onOther,
              groupingBy: {
                  let author = String($0.info.author)
                  let date = $0.info.createDate.threeMinutesAgo()
                  return "\(author) - \(date) - \($0.info.threadId)"
              },
              sortedBy: { $0.info.createDate > $1.info.createDate },
              filteredBy: { element in true },
              header: {
                name, firstEntry in
                HStack {
                  AuthorContentRow(
                    author: firstEntry!.info.author.toString(),
                    date: firstEntry!.info.createDate.convertInt64ToDate() ?? "?"
                  ).environmentObject(threadModel)

                }
              }
            ) { message in

              ZStack {
                HStack {
                  if let filemessage = message.data.fileMessage,
                    let storeModel = threadModel.storesModel?.storeModel
                  {
                    SimpleFileRow(fileId: filemessage.fileId, fileName: filemessage.fileName)
                      .environmentObject(storeModel)
                  }
                }
                VStack {
                  if let content = message.data.contentMessage {
                    SimpleContentRow(content: content.content)
                  }
                  if let filemessage = message.data.fileMessage {
                    SimpleContentRow(content: filemessage.fileName)
                  }
                }
                .contextMenu {
                    if message.info.author.toString() == appModel.me!.name || appModel.me!.isStaff {
                    Button {
                      self.threadModel.deleteMessage(message: message)
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
            }.environmentObject(
              self.threadModel.model as ListModel<privmx.endpoint.core.Message>)
            HStack {
              PlainTextInput<HStack>(content: self.$textToSend) {
                HStack {
                  Text("New message in \"\(self.thread.data.titleDecoded)\"")

                }
              }
              .focusable(false)

              .padding(10)
              HStack(spacing: 0) {
                ButtonComponentChatee(
                  title: {
                    Icon(size: 25, icon: "send", color: Color.buttonFront(colorScheme))

                  }, style: .normal
                ) { onFinish in
                  if self.textToSend != "" {
                    let messageContent = MessageContent(type: "text", text: self.textToSend)
                    let content = JSONEncoder().encodeToString(messageContent)
                    threadModel.send(message: content, from: appModel.me!.userEntry)
                    self.textToSend = ""
                  }
                  onFinish()
                }
              }.padding([.trailing], 7)

            }.padding(3.0)
              .border(colorScheme: colorScheme)
              .padding(10)
          }
        }
        .mainBorder(colorScheme: colorScheme)
      }

    }.onAppear {
      self.threadModel.setup(thread: self.thread)
      self.selected = self.thread.threadId.toString()
    }
    .onChange(of: thread) {
      self.threadModel.setup(thread: self.thread)
      self.selected = self.thread.threadId.toString()
    }
  }

}


