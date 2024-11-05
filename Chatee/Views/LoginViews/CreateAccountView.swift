//
//  CreateAccountView.swift
//  Chatee
//
//  Created by Blazej Zyglarski on 27/09/2024.
//

import Foundation
import SwiftUI

struct CreateAccountView: View {
 @State var username: String = ""
 @State var password: String = ""
 @State var invitationtoken: String = ""
 @State var password_rep: String = ""

 @EnvironmentObject var router: StartupRouter
 @EnvironmentObject var chateeDataController: ChateeDataController

 var body: some View {

   VStack(spacing: 10) {
     Spacer()
     ChateeIcon()
     HStack {
       Text("New Account").font(.title)
       Spacer()
     }
     VerticalSpacer(size: 10)

     HStack {
       Text("Invitation Key").font(.headline)
       Spacer()
     }
     TextInputWithPlaceholder(text: "xxxx-xxxx-xxxx", content: $invitationtoken)
     HStack {
       Text("Username").font(.headline)
       Spacer()
     }
     TextInput(content: $username)
     HStack {
       Text("Password").font(.headline)
       Spacer()
     }
     PasswordInput(content: $password)
     HStack {
       Text("RepeatPassword").font(.headline)
       Spacer()
     }
     PasswordInput(content: $password_rep)

     PasswordInfo(isOk: .constant(password.isLongEnough())) {
       Text("At least six signs")
     }

     PasswordInfo(isOk: .constant(password.containsDigits())) {
       Text("Digits")
     }
     PasswordInfo(isOk: .constant(password.containsLargeLetters())) {
       Text("Capital Letters")
     }
     PasswordInfo(isOk: .constant(password.containsSmallLetters())) {
       Text("Small Letters")
     }
     PasswordInfo(isOk: .constant(password.containsSpecialCharacters())) {
       Text("Special Characters")
     }

     PasswordInfo(isOk: .constant(password_rep == password)) {
       Text("Passwords are the same")
     }

     ButtonComponentChatee(
       title: {
         Text("Create Account")
       },
       style: .wide
     ) { onFinish in
         Task{
			 try? await chateeDataController.createAccount(username: username, password: password, invitationToken:invitationtoken)
         }
		 router.navigate(to: .login)
     }

     ButtonComponentChateeText(
       title: {
         Text("Cancel")
       },
       style: .wide
     ) { onFinish in
 
         router.navigate(to: .login)
       onFinish()
     }

     Spacer()
   }.padding(40).interactiveDismissDisabled(true)

 }
}
