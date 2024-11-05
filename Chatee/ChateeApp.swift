//
//  ChateeApp.swift
//  Chatee
//
//  Created by Blazej Zyglarski on 25/09/2024.
//

import SwiftUI

@main
struct ChateeApp: App { 
	@Environment(\.scenePhase) var scenePhase
	@ObservedObject var startupRouter = StartupRouter()
    @ObservedObject var chateeDataController = ChateeDataController()
    @ObservedObject var notificationModel = NotificationModel()
    
    var body: some Scene {
		Window("Chatee", id: "main") {
			ZStack{
				if chateeDataController.connectionState == .notConnected  {
                    NavigationStack(path: $startupRouter.navPath) {
                        DomainSelectorView()
							.navigationDestination(for: StartupRouter.Destination.self) { destination in
								switch destination {
								case .createAccount:
									CreateAccountView()
								case .login:
									LoginView()
								case .networkUnreachable:
									NetworkUnreachableView()
								}
                            }
                            .onAppear{
                                chateeDataController.setRouters(startupRouter:startupRouter )
                            }
                    }
                    
                    
                }else
                {
                       MainAppView()
                    
                    
                }
                NotificationInfo()
                     
			}
			.onChange(of: scenePhase, initial: true){
				
					switch(scenePhase){
					case .active:
						//App entered active state
						Task{
							do{
								try await chateeDataController.reviveConnection()
							}catch (let e){
								// some error with connection
							}
						}
					case .inactive:
						//App entered inactive state
						Task{
							do{
							try await chateeDataController.pauseConnection()
							}catch (let e){
								// some error with connection
							}
						}
					case .background:
						//App entered background state
						Task{
							do{
							try await chateeDataController.pauseConnection()
							}catch (let e){
								// some error with connection
							}
						}
					default:
						print("Unknown state")

						
					}
					
				
			}
			.environmentObject(notificationModel)
			.environmentObject(startupRouter)
			.environmentObject(chateeDataController)
				
        }
    }
}
