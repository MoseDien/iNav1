// AppRoute.swift
// Define all your app's routes here.

import SwiftUI

// MARK: - Define Your Routes

enum Route: AppRoute {
    case home
    case login
    case productList
    case productDetail(id: Int)
    case cart
    case checkout
    case orderSuccess
    case settings
    case profile
}

// MARK: - Root View (NavigationStack host)

struct RootView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        NavigationStack(path: $router.path) {
            // Root destination (not in the path stack)
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .home:
            HomeView()
        case .login:
            LoginView()
        case .productList:
            ProductListView()
        case .productDetail(let id):
            ProductDetailView(id: id)
        case .cart:
            CartView()
        case .checkout:
            CheckoutView()
        case .orderSuccess:
            OrderSuccessView()
        case .settings:
            SettingsView()
        case .profile:
            ProfileView()
        }
    }
}
