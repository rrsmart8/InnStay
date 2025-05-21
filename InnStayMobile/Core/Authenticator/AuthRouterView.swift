import SwiftUI

enum AuthScreen {
    case login
    case signup
    case explore
    case panel
}

struct AuthRouterView: View {
    @State private var screen: AuthScreen = .login

    var body: some View {
        switch screen {
        case .login:
            LoginScreen(onLoginSuccess: {
                if let token = UserDefaults.standard.string(forKey: "auth_token"),
                   let payload = decodeJWT(token: token),
                   let role = payload["role"] as? String {
                    screen = (role == "admin") ? .panel : .explore
                } else {
                    // guest fallback
                    screen = .explore
                }
            }, onGoToSignup: {
                screen = .signup
            })

        case .signup:
            SignupScreen(
                onSignupSuccess: {
                    screen = .explore
                },
                onGoToLogin: {
                    screen = .login
                }
            )

        case .explore:
            ExploreView(onLogout: {
                UserDefaults.standard.removeObject(forKey: "auth_token")
                screen = .login
            })

        case .panel:
            HostPanelView(onLogout: {
                UserDefaults.standard.removeObject(forKey: "auth_token")
                screen = .login
            })
        }
    }
}

#Preview {
    AuthRouterView()
}
