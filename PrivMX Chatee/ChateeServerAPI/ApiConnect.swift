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

import Alamofire
import Foundation
 
import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra

class ApiConnect {
  var apc: APIClient?
  var fulldomain: String
  var signInResponse: SignInResponse?

  var domain: String { "\(fulldomain.split(separator: ".").first ?? "")" }
  var contextId: String? { self.signInResponse?.cloudData.contextId }
  var platformURL: String? { self.signInResponse?.cloudData.platformUrl }
  var solutionID: String? { self.signInResponse?.cloudData.solutionId }
  var isStaff: Bool { self.signInResponse?.isStaff ?? false }

  var token: String? {
    didSet {
      let sessionManager = Session()
      self.apc = APIClient(
        baseURL: "https://\(fulldomain)", sessionManager: sessionManager,
        defaultHeaders: ["Authorization": "Bearer \(token!)"])
    }
  }

  init(domain fulldomain: String) {
    self.fulldomain = fulldomain
    let sessionManager = Session()
    self.apc = APIClient(
      baseURL: "https://\(fulldomain)", sessionManager: sessionManager,
      defaultHeaders: [:])
  }

  func getAllUsers(cb: @escaping ([ContactResponse]) -> Void) {
    let getallUsers = API.Contacts.GetContacts.Request()

    self.apc?.makeRequest(getallUsers) { res in

      switch res.result {
      case .success(let apiResponseValue):
        cb(apiResponseValue.success?.contacts ?? [ContactResponse]())
      case .failure(_):
        cb([ContactResponse]())
      }
    }

  }

  func login(username: String, key: String, cb: @escaping (Bool) -> Void) {
    self.signInResponse = nil
    Task {
      let signInBody = SignInBody(
        sign: key, domainName: self.domain, username: username)
      let getUserRequest = API.SignIn.PostSignIn.Request(body: signInBody)
      self.apc?.makeRequest(getUserRequest) { res in

        switch res.result {
        case .success(let apiResponseValue):
          if let token = apiResponseValue.success?.token {
            self.token = token
            if let signInResponse = apiResponseValue.success {
              self.signInResponse = signInResponse

              cb(true)
            }
          } else {
            cb(false)
          }
        case .failure(_):
          cb(false)
        }
      }

    }
  }

  func invite(isStaff: Bool, cb: @escaping (String?) -> Void) {

    Task {
      let getUserRequest = API.InviteToken.PostInviteToken.Request(
        body: InviteTokenBody(isStaff: isStaff, domainName: self.domain))
      self.apc?.makeRequest(getUserRequest) { res in
        switch res.result {
        case .success(let apiResponseValue):
          if let token = apiResponseValue.success?.value {
            cb(token)
          } else {
            cb(nil)
          }
        case .failure(_):
          cb(nil)
        }
      }
    }
  }

  func register(
    inviteToken: String, username: String, publicKey: String,
    cb: @escaping (String?) -> Void
  ) {
    Task {
      let getUserRequest = API.SignUp.PostSignUp.Request(
        body: SignUpBody(
          inviteToken: inviteToken, publicKey: publicKey,
          username: username))

      self.apc?.makeRequest(getUserRequest) { res in

        switch res.result {
        case .success(let apiResponseValue):
          if let message = apiResponseValue.success?.message {
            cb(message)
          }

        case .failure(let apiResponseValue):
          cb(apiResponseValue.description)

        }
      }

    }
  }

}
