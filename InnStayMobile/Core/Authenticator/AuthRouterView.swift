//
//  AuthRouter.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

struct AuthRouterView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            LoginScreen(path: $path)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signup:
                        SignupScreen(path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginScreen(path: $path)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

enum AuthRoute: Hashable {
    case signup
    case login
}
#Preview {
    AuthRouterView()
}
