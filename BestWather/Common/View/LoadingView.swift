//
//  LoadingView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
            ActivityIndicatorView()
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
