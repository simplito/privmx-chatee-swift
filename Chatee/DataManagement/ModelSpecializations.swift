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

import PrivMXEndpointSwift
import PrivMXEndpointSwiftExtra
import PrivMXEndpointSwiftNative

@MainActor
public class StoreInfoListModel: ListModel<privmx.endpoint.store.Store> {

}
@MainActor
public class StoreFileInfoListModel: ListModel<privmx.endpoint.store.File> {

}

@MainActor
public class ThreadListModel: ListModel<privmx.endpoint.thread.Thread> {

}

@MainActor
public class ThreadMessageListModel: ListModel<privmx.endpoint.thread.Message> {
}
