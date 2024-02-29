//
//  ForecastDetailsView.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI

struct ForecastDetailsView: View {
    
    @State var viewModel: DayForecastViewModel
    @Environment(ForecastRouter.self) private var router
    
    var body: some View {
        Text("Forecast details")
            .onTapGesture {
                router.route = .forecast
            }
    }
    
}

#Preview {
    let viewModel = DayForecastViewModel(id: UUID(), date: "Pn.", description: "Sunny", temperature: "-12°", pressure: "1000 hPa", icon: "sun.max.fill")
    return ForecastDetailsView(viewModel: viewModel)
}
