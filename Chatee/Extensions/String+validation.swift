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

extension String {

	func isValidDomain() -> Bool {
		let domainRegex = "^https?://[a-z0-9](?:[a-z0-9-]*[a-z0-9]?)(?:\\.[a-z0-9][a-z0-9-]*)*(?::[1-9][0-9]{0,4})?$"
		return NSPredicate(format: "SELF MATCHES %@", domainRegex).evaluate(with: self)
	}

	func isValidAddress() -> Bool{
		self.contains(
			#/^https?://(?:[0-9]{1,3}(?:\.[0-9]{1,3}){3}|[a-z0-9](?:[a-z0-9-]*[a-z0-9]?)(?:\.[a-z0-9][a-z0-9-]*)*)(?::[1-9][0-9]{0,4})?$/#
		)
	}
	func containsLargeLetters() -> Bool? {
		if self.count == 0 { return nil }
		let largeLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		for letter in self {
			if largeLetters.contains(letter) {
				return true
			}
		}
		return false
	}

	func containsSpecialCharacters() -> Bool? {
		if self.count == 0 { return nil }
		let specialCharacters = "!@#$%^&*()_+{}[]|\"<>,./?;':"
		for letter in self {
			if specialCharacters.contains(letter) {
				return true
			}
		}
		return false
	}
	func containsDigits() -> Bool? {
		if self.count == 0 { return nil }
		let digits = "0123456789"
		for letter in self {
			if digits.contains(letter) {
				return true
			}
		}
		return false
	}

	func containsSmallLetters() -> Bool? {
		if self.count == 0 { return nil }
		let smallLetters = "abcdefghijklmnopqrstuvwxyz"
		for letter in self {
			if smallLetters.contains(letter) {
				return true
			}
		}
		return false
	}

	func isEmail() -> Bool? {
		if self.count == 0 { return nil }
		let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
	}

	func contains(string: String) -> Bool {
		let regex = "^.*\(string).*$"
		return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
	}

	func isLongEnough() -> Bool? {
		if self.count == 0 { return nil }
		return self.count > 5
	}
}
