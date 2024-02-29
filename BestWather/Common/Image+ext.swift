//
//  Image+ext.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI

extension Image {
    
    func symbol(width: CGFloat, height: CGFloat) -> some View {
        self.renderingMode(.original)
            .size(width: width, height: width)
    }
    
    func template(width: CGFloat, height: CGFloat, color: Color = .white, opacity: Double = 1.0) -> some View {
        self.renderingMode(.template)
            .size(width: width, height: width)
            .foregroundColor(color)
            .opacity(opacity)
    }
    
    private func size(width: CGFloat, height: CGFloat) -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
    
}
