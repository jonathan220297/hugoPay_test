//
//  ApiClient.swift
//  Transportation
//
//  Created by Juan Jose Maceda on 7/7/19.
//  Copyright © 2019 Hugo Technologies. All rights reserved.
//
import Foundation

typealias ResultCallback<Value> = (Result<Value, ParseServerError>) -> Void

enum ParseServerError: LocalizedError {
    case decoding
    case server(code: Int, message: String)
}

extension ParseServerError {
    public var errorDescription: String? {
        switch self {
        case .decoding:
            return ""
        case .server(code: let errorCode, message: let errorMessage):
            return errorMessage.isEmpty ? "error de servidor desconocido, código \(errorCode)" : errorMessage
        }
    }
}

protocol APIRequest: Encodable {
    associatedtype Response: Decodable
    
    var resourceName: String { get }
}

public class APIClient {
    
    public let session = URLSession(configuration: .default)
    
    //MARK: POST PARSE
    func send<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpoint(for: request) else {
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
        request.addValue(APDLGT.PRS1D, forHTTPHeaderField: "X-Parse-Application-Id")
        request.httpBody = body 
        request.timeoutInterval = 90.0
        
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                print("parse response", data)
                print("parse response", response)
                print("parse response", error)
                
                
                do {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("data json %@", json)
                    let parseResponse = try JSONDecoder().decode(ParseResponse<T.Response>.self, from: data)
                    if let dataContainer = parseResponse.result {
                        completion(.success(dataContainer))
                        return
                    }
                    
                    if
                        let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                        let jsonData = try? JSONSerialization.data(withJSONObject: errorResponse, options: [.prettyPrinted]),
                        let decoded = String(data: jsonData, encoding: .utf8) {
                        print("api client error: \(decoded)")
                        completion(.failure(.server(code: 0, message: decoded)))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(.server(code: response.statusCode, message: "")))
                    } else {
                        completion(.failure(ParseServerError.decoding))
                    }
                } catch {
                    completion(.failure(.server(code: 0, message: error.localizedDescription)))
                }
            } else if let error = error {
                completion(.failure(.server(code: 0, message: error.localizedDescription)))
            }
        }
        task.resume()
    }
    
    //MARK: GET VGS
    func getVGS<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointVGS(for: request) else {
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
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APDLGT.VGSTKN, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 90.0
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
    //MARK: GET VGS
    
    //MARK: GET VGS
      func deleteVGS<T: APIRequest>(
          _ request: T,
          completion: @escaping ResultCallback<T.Response>
      ) {
          
          guard let endpoint = self.endpointVGS(for: request) else {
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
          request.httpMethod = "DELETE"
          //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          request.addValue(APDLGT.VGSTKN, forHTTPHeaderField: "Authorization")
          request.timeoutInterval = 90.0
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
      //MARK: GET VGS
    
    func updateVGS<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointVGS(for: request) else {
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
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue(APDLGT.VGSTKN, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        request.timeoutInterval = 90.0
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
    
    //MARK: POST VGS
    func newSendParse<T: APIRequest>(
        _ request: T,
        completion: @escaping ResultCallback<T.Response>
    ) {
        
        guard let endpoint = self.endpointVGSTerritory(for: request) else {
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
        request.addValue(APDLGT.PRS1D, forHTTPHeaderField: "X-Parse-Application-Id")
        request.httpBody = body
        request.timeoutInterval = 90.0
        let task = session.dataTask(with: request) { data, response, error in
            if var data = data {
                do {
                    var strData = String(decoding: data, as: UTF8.self)
                    strData = strData.replacingOccurrences(of: "\\", with: "")
                    strData = strData.replacingOccurrences(of: "\"[", with: "[")
                    strData = strData.replacingOccurrences(of: "]\"", with: "]")
                    data = Data(strData.utf8)
                    
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
    private func endpoint<T: APIRequest>(for request: T) -> URL? {
        //print("h \(PARSE_URL)/functions/\(request.resourceName)")
        return URL(string: "\(PARSE_URL)/functions/\(request.resourceName)")
    }
    
    private func endpointVGS<T: APIRequest>(for request: T) -> URL? {
        print("h \(VGS_URL)/\(request.resourceName)")
        return URL(string: "\(VGS_URL)/\(request.resourceName)")
    }
    private func endpointVGSTerritory<T: APIRequest>(for request: T) -> URL? {
        //print("\(PARSE_URL)/functions/\(request.resourceName)")
        return URL(string: "\(PARSE_URL)/functions/\(request.resourceName)")
    }
    
    private func endpointGoogleMockup<T: APIRequest>(for request: T) -> URL? {
        return URL(string:
            "https://payment-collector-core-6bwi47d7ca-uc.a.run.app/api/v1/mockups/\(request.resourceName)")
    }
    
}
