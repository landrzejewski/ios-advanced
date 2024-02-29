//
//  SegmentedViewAnimation.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 19/05/2022.
//

import SwiftUI

struct SegmentedViewAnimation: View {
    
    @State
    var food = 0
    
    var body: some View {
        Picker("Select food", selection: $food) {
            Text("Burger").tag(0)
            Text("Pizza").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        Spacer()
        GeometryReader { reader in
            VStack {
            }
            .frame(width: reader.size.width - 20, height: 200)
            .background(Image("Burger"))
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .offset(x: food == 0 ? 0 : -reader.size.width - 20, y: 0)
                .animation(.default, value: food)
            VStack {
            }
            .frame(width: reader.size.width - 20, height: 200)
            .background(Image("Pizza"))
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .offset(x: food == 1 ? 0 : reader.size.width - 20, y: 0)
                .animation(.default, value: food)
        }
    }
}

struct SegmentedViewAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedViewAnimation()
    }
}
