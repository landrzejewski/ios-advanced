//
//  ForecastSettingsView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import SwiftUI

struct ForecastSettingsView: View {
    
    @Environment(\.presentationMode) private var mode
    @State private var city = ""
    @AppStorage("city") private var storedCity = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { mode.wrappedValue.dismiss() }) { closeButton }
                    .accessibility(identifier: "close")
            }
            .padding(.top, 6)
            Form {
                Section(header: Text("Location")) {
                    TextField("Enter city name:", text: $city)
                        .onAppear { city = storedCity }
                        .onDisappear { storedCity = city }
                }
            }
        }
    }
    
    private var closeButton: some View {
        Image(systemName: "xmark.circle")
            .symbol(width: 20, height: 20)
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 6))
    }
}

struct ForecastSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastSettingsView()
    }
}
