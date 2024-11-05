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

extension Array {

	public func filtered(by filter: (Element) -> Bool) -> [Element] {
		var result = [Element]()
		for element in self {

			if filter(element) {
				result.append(element)
			}
		}

		return result
	}

	public mutating func appendElementsNotExistent(
		from other: [Element],
		distinguishedBy comparator: (Element, Element) -> Bool,
		sortedBy sorter: (Element, Element) -> Bool
	) {
		for element in other {
			if !self.contains(where: { comparator($0, element) }) {
				self.append(element)
			} else {
				guard
					let index = self.firstIndex(where: {
						comparator($0, element)
					})
				else { return }
				self.remove(at: index)
				self.append(element)
			}
		}
		self.sort(by: sorter)

	}

	func with(_ element: Element?) -> Array {
		var newArray = self
		if let element = element {
			newArray.append(element)
		}
		return newArray
	}
}
