//
//  BottomMenuAnimation.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 19/05/2022.
//

import SwiftUI

struct BottomMenuAnimation: View {
    
    @GestureState
    var menuOffest = CGSize.zero
    @State
    var menuY = CGFloat.zero
    
    var body: some View {
        Spacer()
        VStack {
            Circle()
                .fill(.accent)
                .frame(width: 100, height: 100)
                .overlay(Image(systemName: "line.horizontal.3")
                    .foregroundColor(.white)
                    .offset(x: 0, y: -20))
                .offset(x: 0, y: -50)
            HStack {
                Spacer()
            }
            Spacer()
        }
        .frame(height: 200)
        .background(Rectangle().fill(.accent))
        .offset(x: 0, y: menuY + menuOffest.height)
        .gesture(DragGesture()
            .updating($menuOffest, body: { (value, offset, transaction) in
                offset = value.translation
            })
                .onEnded({ value in
                    if value.translation.height > 100 {
                        menuY = 200
                    } else {
                        menuY = 0
                    }
                })
        )
        .animation(.default, value: menuY)
    }
}

struct BottomMenuAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenuAnimation()
    }
}
