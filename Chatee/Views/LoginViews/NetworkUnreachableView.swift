//
//  LoginView.swift
//  Chatee
//
//  Created by Blazej Zyglarski on 26/09/2024.
//


import SwiftUI

import AuthenticationServices
import Foundation
import SwiftUI

struct NetworkUnreachableView: View {
  @EnvironmentObject var router: StartupRouter
    
  var body: some View {

    VStack(spacing: 10) {
      Spacer()
      ChateeIcon()
      Text("Sorry, Network is unreachable... ").font(.title)
	  Spacer()
    }.padding(40)
      
  }
}

