//
//  FoodView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI

struct FoodView: View {

    var viewModel: FoodViewModel

    var body: some View {
        HStack {
            AsyncImage(url: viewModel.imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 80)
                    .cornerRadius(10)
            } placeholder: {
                Image("Placeholder").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 80)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(viewModel.description)
                    .font(.body)
                    .lineLimit(1)
                Text(viewModel.price)
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(viewModel: FoodViewModel(id: 1, name: "Asparagus steak", description: "Nice and healthy steak", price: "20 zł", imageUrl: URL(string: "https://github.com/landrzejewski/goodweather/blob/combine/extras/images/asparagus-steak.png?raw=true")!))
    }
}
