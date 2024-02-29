//
//  BasicAnimations.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 02/06/2023.
//

import SwiftUI

struct BasicAnimations: View {
    
    @State var start = false
    
    var body: some View {
        Group {
            if start {
                RoundedRectangle(cornerRadius: start ? 50 : 10)
                    .frame(width: 100, height: 100)
                    .foregroundColor(start ? .accentColor : .indigo)
                    .offset(y: start ? 10 : 100)
                    .scaleEffect(start ? 1.5 : 0.5)
                //.animation(.easeInOut(duration: 1)
                //    .delay(1.5)
                //    .repeatCount(3, autoreverses: true), value: start)
                //.animation(.easeOut.delay(0.5), value: start)
                //.animation(.spring(response: 0.9, dampingFraction: 0.4, blendDuration: 1), value: start)
                    //.transition(.opacity.animation(.default))
                //    .transition(.slide)
                //    .transition(.move(edge: .leading)
                //        .combined(with: .scale(scale: 0.1, anchor: .trailing)))
                    .transition(.asymmetric(insertion: .scale(scale: 0.1, anchor: .topTrailing), removal: .scale(scale: 0.2).combined(with: .opacity)))
            }
        }
        //.animation(.default, value: start)
        Spacer()
        Button(action: {
            withAnimation(.easeInOut) {
                start.toggle()
            }
        }) {
            Text("Start")
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(.accent)
        }
        .cornerRadius(8)
    }
    
}

struct BasicAnimations_Previews: PreviewProvider {
    static var previews: some View {
        BasicAnimations()
    }
}
