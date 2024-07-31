## Basics
Chatee is a chat application that provides you with full end-to-end encryption using the [PrivMX Platform](https://privmx.cloud).

Chatee provides essential chat features, including group chats and file attachments. All data exchanged within Chatee is end-to-end encrypted, meaning that only the end users can read (decrypt) their messages. It means that even platform hosting provider cannot access user data.

Chatee differentiates three types of users:
- **Owner**, who manages domains;
- **Staff**, who manages users within a domain;
- **Regular users**, who interacts with the app.

When you create your initial account within a domain, it automatically becomes a Staff account. As a Staff user, you have the authority to invite other users and assign different permissions for app access.

All Staff users can invite others by sending them an invitation token generated inside the app. Before generating a token you can decide whether the account will have Staff permissions or be a Regular user. Regular users can create new chats only with Staff members. Staff can add chats with all the users in the server, regardless of their status.

Chat is in real-time. You can send text messages and files up to 50 MB.

## What do you need?

### Chatee backend server and PrivMX Bridge instance 
Chatee backend server requires an instance of PrivMX Bridge, which should be properly configured. 
You can use privmx.cloud service for that purpose.
Chatee backend server is available on [Github](https://github.com/simplito/privmx-chatee). 
Please read the corresponding README.md file, which describes prerequisites and step by step installations.
All the information about running Chatee backend server and configuring [privmx.cloud](https://privmx.cloud) is available in the GitHub README file.

## Project Dependencies

This app uses one main dependency:

### PrivMX Endpoint Swift Extra
This is Swift wrapper for Basic PrivMX Endpoint Wrapper, which provides API for events management. This package includes all references for binary compilations of PrivMX Endpoint Libraries, suitable for your architecture. 

## More Info
More info about the platform and example projects can be found on [privmx.cloud](https://privmx.cloud).


## Using with non trusted domains
If you are using this software with Chatee server running on domain without proper SSL certificate, you should disable Trust Evaluator, by creating custom Session() object in ApiConnect.swift file:

```
let customTrustManager = ServerTrustManager(evaluators: ["\(fulldomain)": DisabledTrustEvaluator()])
let sessionManager = Session(serverTrustManager: customTrustManager)
```

