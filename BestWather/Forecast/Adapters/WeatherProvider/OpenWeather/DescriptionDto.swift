//
//  DescriptionDto.swift
//  BestWather
//
//  Created by Łukasz Andrzejewski on 15/01/2024.
//

struct DescriptionDto: Codable {
    
    let text: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        
        case text = "description"
        case icon
        
    }
    
}
