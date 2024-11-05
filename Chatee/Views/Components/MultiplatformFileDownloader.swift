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

import Foundation
import SwiftUI

#if os(iOS)
	import MobileCoreServices
	import UniformTypeIdentifiers

#endif

struct MultiplatformFileDownloader: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var storeModel: StoreModel
	@State var fileId = ""
	@State var filename = ""
	@State var downloading = false
	@State var showingExporter = false
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
						color: Color.buttonBackground(colorScheme))
				}.padding([.leading, .top, .bottom], 5)
					.onTapGesture {
						self.downloading = true

						Task {

							#if os(macOS)

								await MainActor.run {
									self.downloading = false
									let savePanel =
										NSSavePanel()

									savePanel
										.nameFieldStringValue =
										String(filename)
									savePanel
										.canCreateDirectories =
										true

									savePanel.title =
										"Save your file"
									savePanel.message =
										"Choose a folder and a name to store file."
									savePanel.nameFieldLabel =
										"File name:"

									let response =
										savePanel.runModal()
									if let url =
										(response == .OK)
										? savePanel.url
										: nil
									{
										Task{
											 
										    try? Data().write(to: url)
										    let fileHandle =  try! FileHandle(forWritingTo: url)
											_ = try? await storeModel.downloadFile(fileId: fileId, to: fileHandle, onChunkDownloaded: { chunk in
											})
											self.downloading = false
										}
									}
								}

							#endif
							#if os(iOS)

								await MainActor.run {
									self.downloading = false
//									self.document = Document(
//										initialData: Data(),
//										filename: filename,
//										type: filename.utType)
									self.showingExporter = true
								}

							#endif
						}
					}

			}

		}
	}
}

#if os(iOS)
	public struct Document: @preconcurrency FileDocument {
		@MainActor public static var readableContentTypes = [UTType.plainText]

		var data = Data()
		var filename = ""

		init(initialData: Data, filename: String, type: UTType) {
			data = initialData
			self.filename = filename
			Task {
				await MainActor.run {
					Document.readableContentTypes = [type]
				}
			}
		}

		public init(configuration: ReadConfiguration) throws {
			if let data = configuration.file.regularFileContents {
				self.data = data
			}
		}

		public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
			let x = FileWrapper(regularFileWithContents: data)
			x.filename = filename
			return x
		}
	}
#endif
