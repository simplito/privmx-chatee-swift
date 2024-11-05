# Chatee iOS Client

Chatee is a chat application that offers end-to-end encryption using the [PrivMX Platform](https://privmx.com). This project serves as a demo, showcasing how to construct a chat application utilizing the PrivMX Platform.

Chatee encompasses essential chat features, such as group chats and file attachments. All data exchanged within Chatee is securely encrypted, ensuring that only the intended recipients can read (decrypt) their messages. This means that even the platform hosting provider cannot access user data.

To utilize this application, you must install Chatee Server and PrivMX Bridge on your local infrastructure. For detailed installation instructions, refer to the [Privmx Chatee Next.js project](https://github.com/simplito/privmx-chatee).
																										   
																										   
Chatee differentiates two types of users:
- **Staff**, who manages users within a installation;
- **Regular users**, who interacts with the app.

When you create your initial account, it automatically becomes a Staff account. As a Staff user, you gain the authority to invite other users and assign varying permissions for app access.

All Staff users can invite others by sending them an invitation token generated within the app. Before generating a token, you have the option to decide whether the account will have Staff permissions or be a Regular user. Regular users can only create new chats with Staff members. On the other hand, Staff users can add chats with all the users in the server, regardless of their status.

Chats are conducted in real-time. You can send text messages and files up to 50 MB.

## What do you need?

### Chatee backend server and PrivMX Bridge instance
Chatee backend server requires an instance of PrivMX Bridge, which should be properly configured.
Chatee backend server is available on [Github](https://github.com/simplito/privmx-chatee).
Please read the corresponding README.md file, which describes prerequisites and step by step installations.

This app relies on a [`PrivMX Endpoint Swift Extra`](https://github.com/simplito/privmx-endpoint-swift-extra). This is a wrapper for the PrivMX Endpoint Swift, which offers an API for event management and files streaming logic. This package includes all references to binary compilations of PrivMX Endpoint Libraries, tailored to your architecture.

## Using Chatee iOS Client with non trusted domains
If you are using this software with Chatee server running on domain without proper SSL certificate, you should disable Trust Evaluator, by creating custom Session() object in ApiConnect.swift file:

```
let customTrustManager = ServerTrustManager(evaluators: ["\(fulldomain)": DisabledTrustEvaluator()])
let sessionManager = Session(serverTrustManager: customTrustManager)
```

## About PrivMX

[PrivMX](http://privmx.com)  allows developers to build end-to-end encrypted apps used for communication. The Platform works according to privacy-by-design mindset, so all of our solutions are based on Zero-Knowledge architecture. This project extends PrivMX’s commitment to security by making its encryption features accessible to developers using Swift.


## License information

**PrivMX Chatee iOS Client**

Copyright © 2024 Simplito sp. z o.o.

This project is part of the PrivMX Platform (https://privmx.dev).

This project is Licensed under the MIT License.

PrivMX Endpoint and PrivMX Bridge are licensed under the PrivMX Free License.

See the License for the specific language governing permissions and limitations under the License.
