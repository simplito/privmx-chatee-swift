//
// PrivMX Endpoint Swift Extra
// Copyright © 2024 Simplito sp. z o.o.
//
// This file is part of the PrivMX Platform (https://privmx.cloud).
// This software is Licensed under the MIT License.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import PrivMXEndpointSwiftNative

extension privmx.endpoint.core.Message
:Identifiable,Hashable{
    public var id: String{
        String(info.messageId)
    }
    
    public static func == (
        lhs:privmx.endpoint.core.Message,
        rhs:privmx.endpoint.core.Message
    )->Bool{
        rhs.id == rhs.id
        && lhs.info.author == rhs.info.author
        && lhs.info.createDate == rhs.info.createDate
        && lhs.info.messageId == rhs.info.messageId
        && lhs.info.threadId == rhs.info.threadId
    }
    
    public func hash(
        into hasher: inout Hasher
    ) -> Void {
        hasher.combine(info.messageId)
        hasher.combine(info.threadId)
    }
}
