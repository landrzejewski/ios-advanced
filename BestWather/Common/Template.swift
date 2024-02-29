//
//  Template.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 02/06/2023.
//

import Foundation

final class Template {
    
    private let text: String
    private let expressionStart = "${"
    private let expressionEnd = "}"
    private let expressionPattern = try! NSRegularExpression(pattern: "\\$\\{\\w+\\}")
    
    init(text: String) {
        self.text =  text
    }
    
    func evaluate(_ parameters: [String: String]) throws -> String {
        let result = substitute(parameters)
        try validate(result)
        return result
    }
    
    private func substitute(_ parameters: [String: String]) -> String {
        var result = text
        for (key, value) in parameters {
            let expression = createExpression(forKey: key)
            result = result.replacingOccurrences(of: expression, with: value)
        }
        return result
    }
    
    private func validate(_ result: String) throws {
        if expressionPattern.firstMatch(in: result, range: range(for: result)) != nil {
            throw TemplateError.missingParameters
        }
    }
    
    private func createExpression(forKey key: String) -> String {
        expressionStart + key + expressionEnd
    }
    
    private func range(for text: String) -> NSRange {
        NSRange(location: 0, length: text.utf16.count)
    }
    
}

enum TemplateError: Error {
    
    case missingParameters
    
}
