//
//  ForecastView.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 18/11/2023.
//

import SwiftUI
import Factory

struct ForecastView: View {
    
    @State var viewModel: ForecastViewModel
    @Environment(ForecastRouter.self) private var router
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSettings = false
    @AppStorage("city") private var storedCity = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.top, .bottom]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: "location")
                        .template(width: 20, height: 20)
                        .onTapGesture { viewModel.refreshForecastForCurrentLocation() }
                        .accessibility(identifier: "location")
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                        .template(width: 20, height: 20)
                        .onTapGesture { showSettings = true }
                        .accessibility(identifier: "settings")
                }
                .padding()
                Spacer()
                if let currentForecast = viewModel.currentForecast {
                    Text(viewModel.city)
                        .defaultStyle(size: 34)
                    Spacer()
                    Image(systemName: currentForecast.icon)
                        .symbol(width: 200, height: 200)
                        .padding(.bottom, 24)
                        .padding()
                        .onTapGesture {
                            router.route = .forecastDetails(currentForecast)
                        }
                    Text(currentForecast.description)
                        .defaultStyle(size: 32)
                    HStack(spacing: 24){
                        Text(currentForecast.temperature)
                            .defaultStyle(size: 24)
                            .padding()
                        Text(currentForecast.pressure)
                            .defaultStyle(size: 24)
                            .padding()
                    }
                    .padding()
                    Spacer()
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.nextDaysForecast, content: DayForecastView.init)
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) { ForecastSettingsView() }
        .onAppear {
            viewModel.getLastForecast(for: storedCity)
        }
        .onChange(of: storedCity) { _, newValue in
            viewModel.refreshForecast(for: storedCity)
        }
//        .onChange(of: scenePhase) { oldValue, newValue in
//            if newValue == .active {
//                viewModel.onActive()
//            }
//        }
    }
    
}

#Preview {
    let viewModel = Container.shared.fakeForecastViewModel()
    return ForecastView(viewModel: viewModel)
}
