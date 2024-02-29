//
//  ForecastRouterView.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI
import Factory

struct ForecastRouterView: View {
    
    @Environment(ForecastRouter.self) var router
    @Injected(\.forecastViewModel) var forecastViewModel
    
    var body: some View {
        switch router.route {
        case .forecast:
            ForecastView(viewModel: forecastViewModel)
        case .forecastDetails(let viewModel):
            ForecastDetailsView(viewModel: viewModel)
        }
    }
    
}
