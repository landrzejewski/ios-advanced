//
//  OrderView.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 01/06/2023.
//

import SwiftUI
import Factory

struct OrderView: View {
    
    @State var viewModel: OrderViewModel
    
    var body: some View {
        ZStack{
            VStack {
                List {
                    ForEach(viewModel.orderEntries) { entry in
                        HStack {
                            Text(entry.name)
                            Spacer()
                            Text(entry.price)
                        }
                    }
                    .onDelete { viewModel.orderEntries.remove(atOffsets: $0) }
                }
                Button(action: {}) {
                    Text("Place order")
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                }
                .cornerRadius(8)
            }
            if viewModel.orderEntries.isEmpty {
                PlaceholderView(imageName: "cart", message: "Yours order is empty. Add some products")
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(viewModel: Container.shared.orderViewModel())
    }
}
