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

final class OptionalAsyncCall<T: Sendable>: @unchecked Sendable {

  var onFinish: ((T?) -> Void)?
  let task: () -> T?

  public init(_ callable: @escaping () -> T?) {
    self.task = callable
  }

  @MainActor
  func onFinishTask() {
    self.onFinish?(self.task())
  }

  public func run() {
    Task {
      await onFinishTask()
    }
  }

  public func then(_ of: @escaping (@Sendable (T?) -> Void)) -> OptionalAsyncCall<T> {
    self.onFinish = { e in
      of(e)
    }
    return self
  }
}
