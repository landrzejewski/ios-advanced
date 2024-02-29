//
//  MatchedGeometryEffectAnimation.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 19/05/2022.
//

import SwiftUI

// https://swiftui-lab.com/matchedgeometryeffect-part1/
struct MatchedGeometryEffectAnimation: View {
    
    @State var change = false
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            if change {
                Rectangle()
                    .fill(.accent)
                    .overlay(Text("Rectangle"))
                    .matchedGeometryEffect(id: "change", in: namespace)
                    .frame(width: 150, height: 200)
                    .onTapGesture { change.toggle()}
            } else {
                Circle()
                    .fill(.accent)
                    .overlay(Text("Circle"))
                    .matchedGeometryEffect(id: "change", in: namespace)
                    .frame(width: 100, height: 100)
                    .onTapGesture { change.toggle()}
            }
        }
        .animation(.default, value: change)
    }
}

struct MatchedGeometryEffectAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectAnimation()
    }
}
