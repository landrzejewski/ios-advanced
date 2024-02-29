//
//  URLSession.swift
//  GoodWeather
//
//  Created by Łukasz Andrzejewski on 17/05/2022.
//

import Foundation
import Combine

enum RequestError: Error {
    
    case invalidUrl
    case requestFailed(Int, String)
    case encodingFailed
    case decodingFailed
    
}

enum HttpMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
}

struct EmptyResponse: Decodable {
}

extension URLSession {
    
    func request<Payload: Encodable, Response: Decodable>(for urlString: String, method: HttpMethod = .post, payload: Payload, token: String = "", encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response, RequestError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        var request = getRequest(for: url, method: method, token: token)
        do {
            request.httpBody = try encoder.encode(payload)
        } catch {
            return Fail(error: RequestError.encodingFailed)
                .eraseToAnyPublisher()
        }
        return send(request)
            .decode(type: Response.self, decoder: decoder)
            .mapError { _ in .decodingFailed }
            .eraseToAnyPublisher()
    }
    
    func request<Payload: Encodable>(for urlString: String, method: HttpMethod = .post, payload: Payload, token: String = "", encoder: JSONEncoder = JSONEncoder()) -> AnyPublisher<Void, RequestError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        var request = getRequest(for: url, method: method, token: token)
        do {
            request.httpBody = try encoder.encode(payload)
        } catch {
            return Fail(error: .encodingFailed).eraseToAnyPublisher()
        }
        return send(request)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func request<Response: Decodable>(for urlString: String, method: HttpMethod = .get, token: String = "", decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response, RequestError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        let request = getRequest(for: url, method: method, token: token)
        return send(request)
            .decode(type: Response.self, decoder: decoder)
            .mapError { _ in .decodingFailed }
            .eraseToAnyPublisher()
    }
    
    private func send(_ request: URLRequest) -> AnyPublisher<Data, RequestError> {
        return dataTaskPublisher(for: request)
            .mapError { .requestFailed($0.errorCode, $0.localizedDescription) }
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    private func getRequest(for url: URL, method: HttpMethod, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if (!token.isEmpty) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
}
