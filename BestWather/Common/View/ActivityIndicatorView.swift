//
//  ActivityIndicatorView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .purple
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
}
