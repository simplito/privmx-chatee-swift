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
	@State var file: privmx.endpoint.store.File
	 
	init(file: privmx.endpoint.store.File) {
		self._file = State(initialValue: file)
	}

	var body: some View {
		HStack {

			VStack {
				HStack {

					VStack {
						HStack {
							HStack {
								Icon(
									size: 25, icon: "file",
									color:
										Color
										.buttonBackground(
											colorScheme)
								)
							}.frame(width: 30)
							VStack {
								HStack(spacing: 0) {
									Text(file.titleDecoded)
										.lineLimit(1)
										.fontWeight(.bold)
										.onAppear {

										}
									Spacer()
								}
								HStack(spacing: 0) {
									AvatarSmall(
										author: .constant(
											file
												.authorName
										))
									Text(file.authorName).font(
										.subheadline
									).padding(.trailing, 10)
									Text(
										String(
											file
												.dateCreated
										)
									).font(.subheadline)
										.padding(
											.trailing,
											10)
									Text(file.sizeInKB).font(
										.footnote)
									Spacer()
								}
							}
							Spacer()

							HStack {
								MultiplatformFileDownloader(
									fileId: file.info.fileId
										.toString(),
									filename: file.titleDecoded)

							}

						}

					}
					Spacer()

				}.padding(10)

			}
			.overlay {
				VStack {
					RoundedRectangle(cornerRadius: 5).stroke(
						Color.frame(colorScheme), lineWidth: 1)
				}
			}

		}
	}
}
