//
//  AuthRouter.swift
//  InnStay
//
//  Created by Rares Carbunaru on 5/3/25.
//

import SwiftUI

enum AuthScreen {
    case login
    case signup
    case explore
}

struct AuthRouterView: View {
    @State private var screen: AuthScreen = .login

    var body: some View {
        switch screen {
        case .login:
            LoginScreen(onLoginSuccess: {
                screen = .explore
            }, onGoToSignup: {
                screen = .signup
            })
        case .signup:
            SignupScreen(onSignupSuccess: {
                screen = .login
            }, onGoToLogin: {
                screen = .login
            })
        case .explore:
            ExploreView()
        }
    }
}


#Preview {
    AuthRouterView()
}
