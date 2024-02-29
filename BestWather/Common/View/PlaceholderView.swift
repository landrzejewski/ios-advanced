//
//  PlaceholderView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI

struct PlaceholderView: View {
    
    let imageName: String
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack {
                Image(systemName: imageName)
                    .template(width: 120, height: 120, color: .accentColor, opacity: 0.3)
                Text(message)
                    .font(.title2)
                    .frame(maxWidth: 200)
                    .foregroundColor(.accentColor)
                    .opacity(0.3)
            }
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(imageName: "cart", message: "Yours order is empty. Add some products")
    }
}
