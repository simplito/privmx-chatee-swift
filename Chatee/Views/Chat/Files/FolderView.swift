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

struct FolderView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chateeDataController: ChateeDataController

	@EnvironmentObject var storeModel: StoreModel

	var body: some View {
		VStack(spacing: 0) {
			//
			ListComponent<privmx.endpoint.store.File, String, EmptyView, VStack>(
				.normal,

				withArrow: .none,
				groupingBy: { $0.id },
				sortedBy: { $0.info.createDate > $1.info.createDate },
				filteredBy: { _ in true },
				header: { t, firstEntry in
					EmptyView()
				}
			) { file in
				VStack {
					FileRow(file: file).environmentObject(self.storeModel)
						.padding(.bottom, 5)
						.contextMenu {
							if chateeDataController.currentUser?
								.authorOrStaff(
									autorName: file.info.author
										.toString())
								?? false
							{
								Button {
									Task {
										try? await self
											.storeModel
											.remove(
												fileId:
													file
													.info
													.fileId
													.toString()
											)
									}
								} label: {
									HStack {
										Icon(
											size: 15,
											icon:
												"trash",
											color:
												Color
												.buttonFront(
													colorScheme
												))
										Text("Delete")
									}
								}
							} else {
								Text(
									"No actions available for this message."
								)
							}

						}
				}
			}.environmentObject(
				self.storeModel.model as ListModel<privmx.endpoint.store.File>)

		}
	}
}
