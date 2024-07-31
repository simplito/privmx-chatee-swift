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

extension privmx.endpoint.core.FileInfo
:Identifiable,Hashable{
    public var id: String{
        String(self.fileId)
    }
    
    public static func == (
        lhs:privmx.endpoint.core.FileInfo,
        rhs:privmx.endpoint.core.FileInfo
    )->Bool{
        rhs.fileId == rhs.fileId
        && lhs.author == rhs.author
        && lhs.createDate == rhs.createDate
    }
    
    public func hash(
        into hasher: inout Hasher
    ) -> Void {
        hasher.combine(author)
        hasher.combine(fileId)
        hasher.combine(createDate)
        
    }
}
