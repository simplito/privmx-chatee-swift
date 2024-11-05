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

public struct ListComponent<T, Key, Header, Row>: View
where
	Row: View, Header: View, T: Identifiable & Hashable & Sendable, Key: Comparable,
	Key: StringProtocol
{

	var groupingBy: (T) -> String
	var filter: (T) -> Bool
	var sortedBy: (T, T) throws -> Bool
	@ViewBuilder var header: (String, T?) -> Header
	@ViewBuilder var row: (T) -> Row
	var arrowType: ListComponentArrow

	public init(
		_ type: ListComponentType, withArrow arrowType: ListComponentArrow,
		groupingBy: @escaping (T) -> String, sortedBy: @escaping (T, T) throws -> Bool,
		filteredBy filter: @escaping (T) -> Bool,
		@ViewBuilder header: @escaping (String, T?) -> Header,
		@ViewBuilder row: @escaping (T) -> Row
	) {
		self.type = type
		self.row = row
		self.groupingBy = groupingBy
		self.sortedBy = sortedBy
		self.filter = filter
		self.header = header
		self.arrowType = arrowType
	}

	@State var type = ListComponentType.normal
	@EnvironmentObject var dataprovider: ListModel<T>

	var dataFiltered: [T] {
		let toReturn =
			try? dataprovider
			.data
			.filtered(by: self.filter)
			.sorted(by: self.sortedBy)
		return toReturn ?? [T]()
	}

	var dataGrouped: [[String: [T]]] {
		return
			dataFiltered
			.map { structItem -> (String, T) in
				return (groupingBy(structItem), structItem)
			}
			.reduce(into: [[String: [T]]]()) { result, pair in
				let (currentKey, currentItem) = pair
				if result.count > 0,
					let lastkey = result[result.count - 1].keys.first,
					lastkey == currentKey
				{
					result[result.count - 1][lastkey]?.append(currentItem)
				} else {
					result.append([currentKey: [currentItem]])
				}
			}
	}
	public var body: some View {
		ZStack {
			VStack {
				ScrollView {
					LazyVStack {
						LastRow<T>()

						ForEach(self.dataGrouped, id: \.self) { group in
							if let key = group.keys.first,
								let value = group[key]?.first
							{

								ForEach(group[key]!) { entry in
									row(entry)
										.scaleEffect(
											x: 1.0,
											y: type
												== .normal
												? 1.0
												: -1.0,
											anchor:
												.center
										)
								}
								header(key, value)
									.scaleEffect(
										x: 1.0,
										y: type == .normal
											? 1.0
											: -1.0,
										anchor: .center
									)
							}

						}

						if dataprovider.hasMore() {
							LoadingRow<T>()
						}

					}.padding()
				}
			}
			.scaleEffect(x: 1.0, y: type == .normal ? 1.0 : -1.0, anchor: .center)

			VStack {
				Spacer()
				if !dataprovider.seenAll && self.arrowType == .onAll {
					HStack {
						Image(systemName: "arrow.down")
							.foregroundStyle(.white)

					}.padding(5)
						.background(Color.black).cornerRadius(10)
				}
				if !dataprovider.seenAllOthers && self.arrowType == .onOther {
					HStack {
						Image(systemName: "arrow.down")
							.foregroundStyle(.white)
					}.padding(5)
						.background(Color.black).cornerRadius(10)
				}
			}

		}
	}
}
