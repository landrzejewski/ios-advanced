//
//  ScrollAnimation.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 19/05/2022.
//

import SwiftUI

struct ScrollAnimation: View {
    var body: some View {
        ScrollView {
            ZStack {
                GeometryReader { reader in
                    Image("Background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -reader.frame(in: .global).origin.y / 2)
                }
                VStack(spacing: 40) {
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white).frame(height: 200).opacity(0.6)
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white).frame(height: 200).opacity(0.6)
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white).frame(height: 200).opacity(0.6)
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white).frame(height: 200).opacity(0.6)
                }
                .padding()
            }
            .ignoresSafeArea()
        }
    }
}

struct ScrollAnimation_Previews: PreviewProvider {
    static var previews: some View {
        ScrollAnimation()
    }
}
