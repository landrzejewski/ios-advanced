//
//  View+ext.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import SwiftUI

extension View {
    
    func iOS<UI: View>(_ modifier: (Self) -> UI) -> some View {
        #if os(iOS)
            return modifier(self)
        #else
            return self
        #endif
    }
    
}
