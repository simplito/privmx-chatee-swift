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

#if os(iOS)
  import MobileCoreServices
  import UniformTypeIdentifiers

#endif

struct MultiplatformFileDownloader: View {
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var filesList: StoreModel
  @State var fileId = ""
  @State var filename = ""
  @State var downloading = false
  @State var showingExporter = false

  func showDownloading() {
    self.downloading = true
  }

  func hideDownloading() {
    self.downloading = false
  }

  #if os(iOS)
    @State var document: Document?
  #endif

  init(fileId: String, filename: String) {
    #if os(iOS)
      self.document = nil
    #endif
    self._fileId = State(wrappedValue: fileId)
    self._filename = State(wrappedValue: filename)
  }

  var body: some View {
    HStack {
      #if os(iOS)
        HorizontalSpacer(size: 10)
          .fileExporter(
            isPresented: $showingExporter, document: document,
            contentType: Document.readableContentTypes.first
              ?? UTType.text
          ) { result in

          }
      #endif
      #if os(macOS)
        HorizontalSpacer(size: 10)
      #endif

      if downloading {
        HStack {
          LoadingIndicator()
        }.padding([.leading, .top, .bottom], 5)
      } else {
        HStack {
          Icon(
            size: 25, icon: "download",
            color: Color.buttonBackgrouund(colorScheme))
        }.padding([.leading, .top, .bottom], 5)
          .onTapGesture {
            showDownloading()
            self.filesList.getFile(fileId: fileId) { data in
              Task {
                await hideDownloading()

                #if os(macOS)
                  let savePanel = await NSSavePanel()
                  await savePanel.setNameFieldStringValue(value: await String(self.filename))
                  await savePanel.setCanCreateDirectories(value: true)
                  await savePanel.setTitle(value: "Saving your file")
                  await savePanel.setMessage(value: "Choose a folder and a name to store your file")
                  await savePanel.setNameFieldLabel(value: "File name:")

                  let response = await savePanel.runModal()
                  if let url = await (response == .OK)
                    ? savePanel.url : nil
                  {
                    try? data.write(to: url)

                  }

                #endif
                #if os(iOS)
                  self.document = Document(
                    initialData: data,
                    filename: filename,
                    type: String(filename)
                      .mimeType)
                  self.showingExporter = true
                #endif
              }
            }
          }
      }

    }
  }
}

#if os(iOS)
  public struct Document: FileDocument {
    public static var readableContentTypes = [UTType.plainText]

    var data = Data()
    var filename = ""

    init(initialData: Data, filename: String, type: UTType) {
      data = initialData
      self.filename = filename
      Document.readableContentTypes = [type]
    }

    public init(configuration: ReadConfiguration) throws {
      if let data = configuration.file.regularFileContents {
        self.data = data
      }
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
      var x = FileWrapper(regularFileWithContents: data)
      x.filename = filename
      return x
    }
  }
#endif

extension NSSavePanel {
  func setNameFieldStringValue(value: String) {
    self.nameFieldStringValue = value
  }
  func setCanCreateDirectories(value: Bool) {
    self.canCreateDirectories = value
  }
  func setTitle(value: String) {
    self.title = value
  }
  func setMessage(value: String) {
    self.message = value
  }
  func setNameFieldLabel(value: String) {
    self.nameFieldLabel = value
  }
}
