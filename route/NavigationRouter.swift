// NavigationRouter.swift
// Android-style Navigation for SwiftUI
// Supports: push, pop, popTo, popToRoot, replaceAll, popTo(inclusive)

import SwiftUI

// MARK: - Route Protocol

/// All routes must conform to this protocol.
/// Use an enum to define your app's routes.
protocol AppRoute: Hashable {}

// MARK: - NavigationRouter

@MainActor
final class NavigationRouter<Route: AppRoute>: ObservableObject {

    @Published var path: [Route] = []

    // MARK: - Basic Operations

    /// Push a new route onto the stack.
    func push(_ route: Route) {
        path.append(route)
    }

    /// Pop the top route.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Pop to root (clear entire stack).
    func popToRoot() {
        path.removeAll()
    }

    // MARK: - Android-style popUpTo

    /// Pop back to the specified route.
    /// - Parameters:
    ///   - route: The target route to pop back to.
    ///   - inclusive: If true, also removes the target route itself (like Android's inclusive=true).
    /// - Note: If the route is not in the stack, this is a no-op.
    func popTo(_ route: Route, inclusive: Bool = false) {
        guard let index = path.lastIndex(of: route) else { return }
        if inclusive {
            // Remove the target and everything above it
            path.removeSubrange(index...)
        } else {
            // Keep the target, remove everything above it
            let keepCount = index + 1
            path = Array(path.prefix(keepCount))
        }
    }

    /// Pop to the route at a specific stack index (0-based, 0 = first pushed route).
    func popToIndex(_ index: Int, inclusive: Bool = false) {
        guard index >= 0 && index < path.count else { return }
        if inclusive {
            path.removeSubrange(index...)
        } else {
            path = Array(path.prefix(index + 1))
        }
    }

    // MARK: - Replace Operations

    /// Replace the entire stack with a single route.
    /// Equivalent to Android's `popUpTo(root) { inclusive = true }` + navigate.
    func replaceAll(with route: Route) {
        path = [route]
    }

    /// Replace the entire stack with multiple routes.
    func replaceAll(with routes: [Route]) {
        path = routes
    }

    /// Replace the current top route with a new one (no back entry created).
    func replace(with route: Route) {
        guard !path.isEmpty else {
            push(route)
            return
        }
        path[path.count - 1] = route
    }

    // MARK: - Helpers

    /// The current top route.
    var current: Route? { path.last }

    /// Check if a route exists in the stack.
    func contains(_ route: Route) -> Bool {
        path.contains(route)
    }

    /// Stack depth (0 = at root).
    var depth: Int { path.count }
}
