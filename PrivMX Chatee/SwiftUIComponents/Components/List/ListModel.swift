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
import SwiftUI

@MainActor
open class ListModel<T>: ObservableObject where T: Identifiable & Hashable & Sendable {

  @Published public var data: [T] = [T]()
  @Published public var available: Int64 = -1
  @Published public var loaded: Int64 = 0
  @Published public var pagesize: Int64 = 100
  @Published public var sortOrder = "asc"
  @Published public var seenAll = false
  @Published public var seenAllOthers = false

  public var loader: ((Int64, Int64, String, @escaping (@Sendable (Int64, [T]) -> Void)) -> Void)?
  public var thesame: ((T, T) -> Bool)?
  public var compare: ((T, T) -> Bool)?
  public var isOther: ((T) -> Bool)?

  public init() {

  }

  func setAvailable(_ available: Int64) {
    self.available = available
  }

  func setLoaded(_ loaded: Int64) {
    self.loaded = loaded
  }

  func setSeenAllOthers(value: Bool) {
    self.seenAllOthers = value
  }

  func setSeenAll(value: Bool) {
    self.seenAll = value
  }

  public func seen(_ t: T) {
    if let lastData = data.last, compare?(t, lastData) ?? false {
      withAnimation {
        self.setSeenAllOthers(value: true)
        self.setSeenAll(value: true)
      }
    }
  }
  public func seenLast() {
    withAnimation {
      self.setSeenAllOthers(value: true)
      self.setSeenAll(value: true)
    }
  }

  @MainActor
  public func add(element: T) {

    self.objectWillChange.send()
    self.data.appendElementsNotExistent(
      from: [element], distinguishedBy: self.thesame ?? { a, b in return a.id == b.id },
      sortedBy: self.compare!)

    self.loaded = Int64(self.data.count)

  }

  @MainActor
  public func add(elements: [T]) {

    self.data.appendElementsNotExistent(
      from: elements, distinguishedBy: self.thesame ?? { a, b in return a.id == b.id },
      sortedBy: self.compare!)
    self.loaded = Int64(self.data.count)

  }

  public func loadNext() {
    self.load(skip: loaded)
  }

  public func loadNew() {
    self.load(skip: 0)
  }
  public func reload() {
    self.data.removeAll()
    self.load(skip: 0)
  }

  public func getFirstFileFromRepository(e: @escaping @Sendable (T) -> Void) {
      loader?(0, 1, "asc") { available, elements in
      Task {
        if let firstFile = elements.first {
          e(firstFile)
        }
      }

    }
  }
  public func getFilesFromRepository(first: Int64, e: @escaping @Sendable ([T]) -> Void) {
      loader?(0, first, "asc") { available, elements in
      Task {
        e(elements)
      }
    }
  }

  public func load(skip: Int64? = nil) {

    if available < loaded { return }
    self.setAvailable(0)

    var skipped: Int64 = 0
    if let skip = skip {
      skipped = Int64(skip)
    }
    loader?(skipped, pagesize, sortOrder) { available, elements in
      Task {
        await self.setAvailable(available)
        await self.add(elements: elements)
      }
    }
  }
  open func update(_ item: T) {

    if let ind = data.firstIndex(where: { item.id == $0.id }) {
      self.objectWillChange.send()
      self.data[ind] = item
    }
  }

  public func addNew(_ item: T) {
    withAnimation {
      if let isOtherValue = self.isOther?(item) {
        if isOtherValue {
          self.setSeenAllOthers(value: false)
        }
      }
      self.setSeenAll(value: false)
    }
    self.setAvailable(available + 1)

    self.add(element: item)
    self.setLoaded(self.loaded + 1)
  }

  public func hasMore() -> Bool {
    data.count < available
  }

  public func clear() {
    self.data = [T]()
    self.setAvailable(0)
    self.setLoaded(0)
  }
  public func remove(_ t: T) {
    self.data.removeAll { $0.id == t.id }
  }

}
