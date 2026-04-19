// ExampleViews.swift
// Demonstrates all navigation patterns with real use cases.

import SwiftUI

// MARK: - Home

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        List {
            Section("基础导航") {
                Button("去商品列表") {
                    router.push(.productList)
                }
                Button("去设置") {
                    router.push(.settings)
                }
            }
        }
        .navigationTitle("首页")
    }
}

// MARK: - Product List

struct ProductListView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        List(1...5, id: \.self) { id in
            Button("商品 \(id)") {
                router.push(.productDetail(id: id))
            }
        }
        .navigationTitle("商品列表")
    }
}

// MARK: - Product Detail

struct ProductDetailView: View {
    @EnvironmentObject var router: NavigationRouter<Route>
    let id: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("商品 \(id) 详情")
                .font(.title)

            Button("加入购物车 → 去结账") {
                // Push cart AND checkout, skip cart back-stack
                // Stack: home → productList → productDetail → cart → checkout
                router.push(.cart)
                router.push(.checkout)
            }

            Button("直接去购物车") {
                router.push(.cart)
            }
        }
        .navigationTitle("商品详情")
    }
}

// MARK: - Cart

struct CartView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        VStack(spacing: 20) {
            Text("购物车")
                .font(.title)

            Button("去结账") {
                router.push(.checkout)
            }

            // Android popUpTo(.productList, inclusive: false)
            // 返回商品列表，清除 cart 及其之上
            Button("继续购物（返回商品列表）") {
                router.popTo(.productList)
            }
        }
        .navigationTitle("购物车")
    }
}

// MARK: - Checkout

struct CheckoutView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        VStack(spacing: 20) {
            Text("确认订单")
                .font(.title)

            Button("提交订单") {
                // 清除 productDetail/cart/checkout，跳到成功页
                // Android: popUpTo(.productList) + navigate(.orderSuccess)
                router.popTo(.productList, inclusive: false)
                router.push(.orderSuccess)
                // 最终栈：home → productList → orderSuccess
            }

            // Android: popUpTo(root, inclusive=true) + navigate(.home)
            Button("放弃订单，回首页") {
                router.popToRoot()
            }
        }
        .navigationTitle("结账")
    }
}

// MARK: - Order Success

struct OrderSuccessView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.green)

            Text("下单成功！")
                .font(.title)

            // replaceAll: 清空整个栈，回到首页（没有返回按钮）
            Button("返回首页") {
                router.popToRoot()
                // 或者完全重置：router.replaceAll(with: .home) 如果首页不在root
            }

            Button("再逛逛商品") {
                // popUpTo(.productList, inclusive: true) + navigate(.productList)
                // 等效：用新的 productList 替换到 productList 这层
                router.popTo(.productList, inclusive: true)
                router.push(.productList)
            }
        }
        .navigationTitle("下单成功")
        .navigationBarBackButtonHidden(true) // 禁止返回
    }
}

// MARK: - Login

struct LoginView: View {
    @EnvironmentObject var router: NavigationRouter<Route>

    var body: some View {
        VStack(spacing: 20) {
            Text("登录")
                .font(.title)

            Button("登录成功") {
                // 登录后清除登录页，直接进首页
                // Android: popUpTo(login, inclusive=true) + navigate(home)
                router.replaceAll(with: .home) // 或 router.popToRoot()
            }
        }
        .navigationTitle("登录")
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Settings / Profile (简单示例)

struct SettingsView: View {
    @EnvironmentObject var router: NavigationRouter<Route>
    var body: some View {
        List {
            Button("个人资料") { router.push(.profile) }
            Button("返回首页（清除设置栈）") { router.popToRoot() }
        }
        .navigationTitle("设置")
    }
}

struct ProfileView: View {
    @EnvironmentObject var router: NavigationRouter<Route>
    var body: some View {
        VStack {
            Text("个人资料")
            Button("直接回设置（跳过profile）") {
                // popTo settings, inclusive=false → 保留settings，移除profile
                router.popTo(.settings)
            }
        }
        .navigationTitle("个人资料")
    }
}
