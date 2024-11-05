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



enum ChateeError: Error {
	case invalidDomain
	case invalidLogin
	case errorGeneratingPrivKey
	case invalidSignature
	case errorGeneratingPubKey
	case signingError
	case unknownError
	case alreadyConnected
	case notConnected
	case noConnectionData
}
