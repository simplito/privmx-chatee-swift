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

#if os(iOS)
  class FileDelegate: NSObject, UIDocumentPickerDelegate

  {
    var onFileSelect: ((String, Data, String) -> Void)?
    var onCancel: (() -> Void)?
    init(_ onFileSelect: ((String, Data, String) -> Void)?, _ onCancel: (() -> Void)?) {
      self.onFileSelect = onFileSelect
      self.onCancel = onCancel
    }

    func documentPicker(
      _ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL
    ) {

      guard let data = try? Data(contentsOf: url) else { return }
      let name = url.lastPathComponent
      onFileSelect?(name, data, url.mimeType)
    }
    func documentPicker(
      _ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
    ) {
      guard let url = urls.first else { return }

      guard let data = try? Data(contentsOf: url) else { return }
      let name = url.lastPathComponent
      onFileSelect?(name, data, url.mimeType)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      onCancel?()
    }

  }
#endif

#if os(iOS)
  import MobileCoreServices
  import UniformTypeIdentifiers
#endif
class MultiplatformFileSelector {

  var onFileSelect: ((String, Data, String) -> Void)?
  var onCancel: (() -> Void)?

  #if os(iOS)
    static var filedelegate: FileDelegate?
  #endif

  init(
    _ onFileSelect: @escaping ((String, Data, String) -> Void),
    onCancel: @escaping () -> Void
  ) {
    self.onFileSelect = onFileSelect
    self.onCancel = onCancel
  }

  func selectFile() {
    #if os(macOS)
      let panel = NSOpenPanel()
      panel.allowsMultipleSelection = false
      panel.canChooseDirectories = false
      if panel.runModal() == .OK {
        if let url = panel.url {
          guard let data = try? Data(contentsOf: url) else { return }
          let name = url.lastPathComponent

          onFileSelect?(name, data, url.mimeType)

        } else {
          onCancel?()
        }
      }
    #endif
    #if os(iOS)

      let documentPicker = UIDocumentPickerViewController(
        documentTypes: ["public.data"], in: .import)
      documentPicker.allowsMultipleSelection = false
      MultiplatformFileSelector.filedelegate = FileDelegate(
        onFileSelect, onCancel)
      documentPicker.delegate = MultiplatformFileSelector.filedelegate!
      UIApplication.shared.windows.first?.rootViewController?.present(
        documentPicker, animated: true, completion: nil)
    #endif
  }
}
