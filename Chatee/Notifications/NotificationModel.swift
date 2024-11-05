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

import SwiftUI
@preconcurrency import Combine

@MainActor
public class NotificationModel: ObservableObject {
	
	@Published public var content: String?
	
	private var cancellables = Set<AnyCancellable>()
	
	init() {
		NotificationCenter.default.publisher(for: NSNotification.DefaultToast)
			.sink { [weak self] notification in
				self?.showToast(notification: notification)
			}
			.store(in: &cancellables)
		
		NotificationCenter.default.publisher(for: NSNotification.CriticalError)
			.sink { [weak self] notification in
				self?.handleError(notification: notification)
			}
			.store(in: &cancellables)
	}
	
	func handleError(notification: Notification) {
		// Implement error handling logic here
	}
	
	func showToast(notification: Notification) {
		withAnimation {
			content = notification.userInfo?["content"] as? String
		}
		
		Task {
			try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)  // 5 sekund
			withAnimation {
				content = nil
			}
		}
	}
	
	deinit {
		cancellables.forEach { $0.cancel() }
	}
}
