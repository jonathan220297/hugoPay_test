//
//  APIClient+HPFull.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 27/01/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

extension APIClient {
    
    //MARK: - HugoPayFull
    //MARK: GET
    func sendGetHPFull<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {

        guard let endpoint = self.endpointHugoPayFull(for: request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        if
            let params = try? JSONSerialization.jsonObject(with: body, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
            let decoded = String(data: jsonData, encoding: .utf8) {
            print("Endpoint: \(request.resourceName) \(decoded)")
        }

        let deviceLang: String = Locale.current.languageCode ?? "es"
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.addValue(APDLGT.HPFK3Y, forHTTPHeaderField: "Authorization")
        request.addValue(deviceLang, forHTTPHeaderField: "Accept-Language")
        request.timeoutInterval = 90.0

        print("URL TARGET: \(endpoint)")

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    
                    print(String(decoding: data, as: UTF8.self))
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                           data, options: [])
                    print(jsonResponse)
                    print(T.Response.self)
                    
                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        completion(.failure(.server(code: response.statusCode, message: "")))
                        return
                    }
                    
                    let parseResponse = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(.success(parseResponse))
                    return
                    
                    
                } catch {
                    completion(.failure(.server(code: 0, message: error.localizedDescription)))
                }
            } else if let error = error {
                completion(.failure(.server(code: 0, message: error.localizedDescription)))
            }
        }
        task.resume()
    }

    //MARK: POST
    func sendPostHPFull<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {

        guard let endpoint = self.endpointHugoPayFull(for: request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        if
            let params = try? JSONSerialization.jsonObject(with: body, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
            let decoded = String(data: jsonData, encoding: .utf8) {
            print("Endpoint: \(request.resourceName) \(decoded)")
        }

        let deviceLang: String = Locale.current.languageCode ?? "es"

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(deviceLang, forHTTPHeaderField: "Accept-Language")

        request.addValue(APDLGT.HPFK3Y, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 90.0

        print("URL TARGET: \(endpoint)")
        print("HEADERS: \(String(describing: request.allHTTPHeaderFields))")

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    print(jsonResponse) //Response resul
                    print(T.Response.self)
                    
                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        completion(.failure(.server(code: response.statusCode, message: "")))
                        return
                    }
                    
                    let parseResponse = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(.success(parseResponse))
                    return
                    
                } catch {
                    completion(.failure(.server(code: 0, message: error.localizedDescription)))
                }
            } else if let error = error {
                completion(.failure(.server(code: 0, message: error.localizedDescription)))
            }
        }
        task.resume()
    }

    //MARK: POST
    func sendPostCacaoHPFull<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {

        guard let endpoint = self.endpointCacaoHugoPayFull(for: request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        if
            let params = try? JSONSerialization.jsonObject(with: body, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
            let decoded = String(data: jsonData, encoding: .utf8) {
            print("Endpoint: \(request.resourceName) \(decoded)")
        }

        let deviceLang: String = Locale.current.languageCode ?? "es"

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(deviceLang, forHTTPHeaderField: "Accept-Language")

        request.addValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2MTAxMzk2NTgsImV4cCI6MTY0MTY3NTY1OCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSIsIkdpdmVuTmFtZSI6IkpvaG5ueSIsIlN1cm5hbWUiOiJSb2NrZXQiLCJFbWFpbCI6Impyb2NrZXRAZXhhbXBsZS5jb20iLCJSb2xlIjpbIk1hbmFnZXIiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.4YSykxMPnHWnwHnf3DJoe7eXgHj2E6Bvt_QrLTzg19c", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 90.0

        print("URL TARGET: \(endpoint)")
        print("HEADERS: \(String(describing: request.allHTTPHeaderFields))")

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    print(jsonResponse) //Response resul
                    print(T.Response.self)

                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        completion(.failure(.server(code: response.statusCode, message: "")))
                        return
                    }

                    let parseResponse = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(.success(parseResponse))
                    return

                } catch {
                    completion(.failure(.server(code: 0, message: error.localizedDescription)))
                }
            } else if let error = error {
                completion(.failure(.server(code: 0, message: error.localizedDescription)))
            }
        }
        task.resume()
    }

    //MARK: PUT
    func sendPutHPFull<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {

        guard let endpoint = self.endpointHugoPayFull(for: request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(ParseServerError.decoding))
            return
        }

        if
            let params = try? JSONSerialization.jsonObject(with: body, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
            let decoded = String(data: jsonData, encoding: .utf8) {
            print("Endpoint: \(request.resourceName) \(decoded)")
        }

        let deviceLang: String = Locale.current.languageCode ?? "es"

        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(deviceLang, forHTTPHeaderField: "Accept-Language")

        request.addValue(APDLGT.HPFK3Y, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 90.0

        print("URL TARGET: \(endpoint)")
        print("HEADERS: \(String(describing: request.allHTTPHeaderFields))")

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    print(String(decoding: data, as: UTF8.self))
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    print(jsonResponse) //Response resul
                    print(T.Response.self)

                    if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                        completion(.failure(.server(code: response.statusCode, message: "")))
                        return
                    }

                    let parseResponse = try JSONDecoder().decode(T.Response.self, from: data)
                    completion(.success(parseResponse))
                    return

                } catch {
                    completion(.failure(.server(code: 0, message: error.localizedDescription)))
                }
            } else if let error = error {
                completion(.failure(.server(code: 0, message: error.localizedDescription)))
            }
        }
        task.resume()
    }
    
    //MARK: - GET URL API
    private func endpointHugoPayFull<T: APIRequest>(for request: T) -> URL? {
        return URL(string: "\(APDLGT.HPFUR1)/\(request.resourceName)")
    }

    private func endpointCacaoHugoPayFull<T: APIRequest>(for request: T) -> URL? {
        return URL(string: "https://cacao-payments-hugopay-full-dev.devapps.hugoapp.com/\(request.resourceName)")
    }
}
