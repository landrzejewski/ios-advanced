//
//  TemplateTests.swift
//  BestWatherTests
//
//  Created by Łukasz Andrzejewski on 02/06/2023.
//

import XCTest
@testable import BestWather

final class TemplateTests: XCTestCase {
    
    private let textWithoutExpressions = "My name is Jan Kowalski"
    private let textWithExpressions = "My name is ${firstName} ${lastName}"

    func test_given_a_text_without_expression_when_evaluate_then_returns_the_text() {
        let template = Template(text: textWithoutExpressions)
        let parameters: [String: String] = [:]
        XCTAssertEqual(textWithoutExpressions, try template.evaluate(parameters))
    }
    
    func test_give_a_text_with_expressions_when_evaluate_then_returns_the_text_with_substituted_paramaters() {
        let template = Template(text: textWithExpressions)
        let parameters = ["firstName": "Jan", "lastName": "Kowalski"]
        XCTAssertEqual(textWithoutExpressions, try template.evaluate(parameters))
    }
    
    func test_give_a_text_with_expressions_when_evaluate_without_providing_all_parameters_then_thows_exception() {
        let template = Template(text: textWithExpressions)
        let parameters: [String: String] = [:]
        XCTAssertThrowsError(try template.evaluate(parameters))
    }

}
