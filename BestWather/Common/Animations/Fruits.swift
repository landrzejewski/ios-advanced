//
//  Fruits.swift
//  Best Weather
//
//  Created by Łukasz Andrzejewski on 17/11/2023.
//

import SwiftUI

struct Fruits: View {
    
    @Namespace var namespace
    @State private var selectedItem: Item?
    private var items = FruitsData.getFruits()
    
    var body: some View {
        VStack {
            List(items) { item in
                HStack {
                    if item.id != selectedItem?.id {
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 36)
                            .matchedGeometryEffect(id: item.id, in: namespace)
                    } else {
                        Color.clear.frame(width: 50, height: 36)
                    }
                    Text(item.name)
                        .font(.title)
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        selectedItem = item
                    }
                }
            }
            .listStyle(.plain)
            .disabled(selectedItem != nil)
            .blur(radius: selectedItem != nil ? 3 : 0)
        }
        .overlay {
            if let selectedItem {
                VStack(spacing: 40) {
                    Image(selectedItem.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 36)
                        .scaleEffect(2)
                        .matchedGeometryEffect(id: selectedItem.id, in: namespace)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            self.selectedItem = nil
                        }
                    }) {
                        Text("Close")
                            .foregroundColor(.black)
                            .padding()
                            .background(Capsule().fill(.white))
                    }
                }
                .padding(32)
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color.green)
                    .shadow(radius: 10)
                )
               
   
                
            }
        }
    }
    
}

#Preview {
    Fruits()
}


class FruitsData {
    static func getFruits() -> [Item] {
        return [
            Item(name: "Avocado", imageName: "Avocado"),
            Item(name: "Banana", imageName: "Banana"),
            Item(name: "Blackberries", imageName: "Blackberries"),
            Item(name: "Cherry", imageName: "Cherry"),
            Item(name: "Coconut", imageName: "Coconut"),
            Item(name: "Kiwi", imageName: "Kiwi"),
            Item(name: "Lemon", imageName: "Lemon"),
            Item(name: "Lime", imageName: "Lime"),
            Item(name: "Mango", imageName: "Mango"),
            Item(name: "Mangosteen", imageName: "Mangosteen"),
            Item(name: "Orange", imageName: "Orange"),
            Item(name: "Peach", imageName: "Peach"),
            Item(name: "Pineapple", imageName: "Pineapple"),
            Item(name: "Prune", imageName: "Prune"),
            Item(name: "Raspberry", imageName: "Raspberry")
        ]
    }
}

struct Item: Identifiable {
    let id = UUID()
    var name = ""
    var imageName = ""
    var isFavorite = false
    var details = ""
    var location = ""
}
