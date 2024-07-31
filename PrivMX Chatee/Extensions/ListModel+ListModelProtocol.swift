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
import PrivMXEndpointSwiftNative

@MainActor
public class StoreInfoListModel: ListModel<privmx.endpoint.store.StoreInfo> {

}
@MainActor
public class StoreFileInfoListModel: ListModel<privmx.endpoint.core.FileInfo> {

}

@MainActor
public class ThreadInfoListModel: ListModel<privmx.endpoint.thread.ThreadInfo> {

}
@MainActor
public class ThreadMessageListModel: ListModel<privmx.endpoint.core.Message> {

}
