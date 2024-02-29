//
//  FoodDetailsView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI
import Factory

struct FoodDetailsView: View {
    
    @Binding var isVisible: Bool
    var viewModel: FoodViewModel
    @Injected(\.orderViewModel) var orderViewModel: OrderViewModel
    
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.1)
                .onTapGesture { isVisible = false }
            VStack {
                AsyncImage(url: viewModel.imageUrl) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                } placeholder: {
                    Image("Placeholder").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                }
                Text(viewModel.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(viewModel.description)
                    .font(.body)
                    .lineLimit(1)
                Text(viewModel.price)
                    .font(.body)
                    .foregroundColor(.accentColor)
                Button {
                    orderViewModel.orderEntries.append(OrderEntryViewModel(id: viewModel.id, name: viewModel.name, price: viewModel.price))
                    isVisible = false
                } label: {
                    Text("Add to cart")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(.gray)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .border(Color.white, width: 1)
            .clipped()
            .shadow(radius: 10)
            .overlay(Button(action: { isVisible = false }) {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .opacity(0.5)
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                }
                .padding(.all, 16)
            }, alignment: .topTrailing)
        }
    }
}

struct FoodDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(isVisible: .constant(true), viewModel: FoodViewModel(id: 1, name: "Asparagus steak", description: "Nice and healthy steak", price: "20 zł", imageUrl: URL(string: "https://github.com/landrzejewski/goodweather/blob/combine/extras/images/asparagus-steak.png?raw=true")!))
    }
}
