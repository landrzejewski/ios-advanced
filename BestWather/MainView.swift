//
//  MainView.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI
import Factory

struct MainView: View {
    
    @Injected(\.profileViewModel) var profileViewModel
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
    }
    
    var body: some View {
        TabView {
            ForecastRouterView()
                .environment(ForecastRouter())
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Forecast")
                }
            FoodListView(viewModel: Container.shared.foodListViewModel())
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Food")
                }
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
    
}
