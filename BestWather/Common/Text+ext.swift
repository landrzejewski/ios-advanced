//
//  Text+ext.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

import SwiftUI

extension Text {
    
    func defaultStyle(size: CGFloat = 18) -> some View {
        self.font(.system(size: size, weight: .medium))
            .foregroundColor(.white)
    }
    
}
