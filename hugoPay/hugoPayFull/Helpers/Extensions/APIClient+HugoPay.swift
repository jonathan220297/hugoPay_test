//
//  APIClient+HugoPay.swift
//  Hugo
//
//  Created by Rodrigo Bazan on 7/2/20.
//  Copyright © 2020 Clever Mobile Apps. All rights reserved.
//

import Foundation

extension APIClient{
    
    //MARK: - HugoPay
    //MARK: GET
    func sendGetHP<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointHugoPay(for: request) else {
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
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APDLGT.HPK3Y, forHTTPHeaderField: "Authorization")
        //        request.httpBody = body
        request.timeoutInterval = 90.0
        
        print("URL TARGET: \(endpoint)")
        
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

    func sendGetHPTerritory<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {

        guard let endpoint = self.endpointHugoPayTerritory(for: request) else {
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

        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        print(APDLGT.USERUR1KEY)
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APDLGT.USERUR1KEY, forHTTPHeaderField: "Authorization")
        //        request.httpBody = body
        request.timeoutInterval = 90.0

        print("URL TARGET: \(endpoint)")

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
    func sendPostHP<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointHugoPay(for: request) else {
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

        request.addValue(APDLGT.HPK3Y, forHTTPHeaderField: "Authorization")
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
    
    
    func sendPostTimerHP<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointHugoPay(for: request) else {
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
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue(APDLGT.HPK3Y, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 8.0
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
    private func endpointHugoPay<T: APIRequest>(for request: T) -> URL? {
        return URL(string: "\(APDLGT.HPUR1)/\(request.resourceName)")
    }
    
    //MARK: - ALTERNATIVE CC
    
    func sendGetHPCC<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointHugoPayCC(for: request) else {
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
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBUEkgUkVTVCBwYXJhIHRva2VuaXphY2lvbiBkZSB0YXJqZXRhcyIsInZlcnQiOiJIVUdPQVBQIiwidmVycyI6InYxIiwicHVycCI6InRva2VuaXphdGlvbi1zZXJ2aWNlIn0.4ExEPyZjb0IWtN9fVIGrGcH2zGtuaKDIeongQiagE7M", forHTTPHeaderField: "Authorization")
        //        request.httpBody = body
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
    
    private func endpointHugoPayCC<T: APIRequest>(for request: T) -> URL? {
        return URL(string: "\(APDLGT.VGSURL)/\(request.resourceName)")
    }

    private func endpointHugoPayTerritory<T: APIRequest>(for request: T) -> URL? {
        return URL(string: "\(APDLGT.USERUR1)/\(request.resourceName)")
    }
}
