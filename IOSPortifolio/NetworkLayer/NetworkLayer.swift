//
//  NetworkLayer.swift
//  Katchi
//
//  Created by Jefferson Barbosa Puchalski on 27/06/19.
//  Copyright © 2019 Jefferson Barbosa Puchalski. All rights reserved.
//

import Foundation

//MARK: - Protocols
/// Protocol to Network layer class.
protocol ServiceLayer {
    /**
     Creates a http request and returns his results.
     
     Calling this method gives you a Data result and must be parsed, this can be easly done
     using `Endpoint` extensions.
     
     - Parameter endpoint: The `Endpoint` struct who will be held in request job.
     - Parameter httpMode: The `httpMode` enumerations to change request httpMode.
     - Parameter handler: The clousere who will delivery the results or error of request job.
     - Parameter job: Clousure where network layer will do the job
     */
    func request<T: Codable>(_ endpoint: Endpoint,httpMode: httpMode, model: T, onCompletion handler: @escaping (_ job: Result<T?, TechnicalError>) -> Void)
}

//MARK: - Class
/**
 Network manager for all network operations in application.
 */
class NetworkLayer :  ServiceLayer {
    //MARK: - Network Properties
    /// Network singleton implementation variable.
    private static let sharedNetworkLayer = NetworkLayer()
    
    /// Singleton instance for network layer.
    class var shared: NetworkLayer { return sharedNetworkLayer }
    
    // MARK: - Service Request
    func request<T: Codable>(_ endpoint: Endpoint,httpMode: httpMode, model: T,onCompletion handler: @escaping (_ job: Result<T?, TechnicalError>) -> Void) {
        
        // 1
        // Prepare url for service
        let endPointUrl = self.prepareUrl(for: endpoint)
        
        // 2
        // Add header to URL
        var requestUrl = self.addHeaders(for: endPointUrl!, httpMode: httpMode, headers: endpoint.headers)
        if requestUrl.url == nil {
            return handler(.failure(.init(netError: .badEndpoint)))
        }
        
        // 3
        // Encode the model.
        self.encodeModel(for: &requestUrl, model: model)
        
        // 4
        // Make request call
        let task = URLSession.shared.dataTask(with: requestUrl) { data, res, error in
            
            // Internal iOS net erro codes.
            if(error != nil) {
                // Parse error
                let errMap = error as! URLError
                switch errMap.code {
                case URLError.cannotFindHost:
                    return handler(.failure(TechnicalError.init(userMessage: "Estamos passando por problemas técnicos, Tente novamente mais tarde!",netError: NetworkError.cannotFindHost)))
                case URLError.cannotConnectToHost:
                    return handler(.failure(TechnicalError.init(userMessage: "Estamos passando por problemas técnicos, Tente novamente mais tarde!",netError: NetworkError.genericError)))
                default:
                    return handler(.failure(TechnicalError.init(userMessage: "Estamos passando por problemas técnicos, Tente novamente mais tarde!",netError: NetworkError.genericError)))
                }
            }
            
            // Parse response
            if res != nil {
                let httpResponse = res as! HTTPURLResponse
                // Debug response
                print("Raw endpoint: \(String(describing: res?.url))\nData result: \(String(data: data!, encoding: String.Encoding.utf8) ?? "nil")")
                // parse code.
                switch httpResponse.statusCode {
                    
                case 404:
                    do {
                        let response = try JSONDecoder().decode(ServerError.self, from: data!)
                        return handler(.failure(TechnicalError.init(userMessage: response.message ?? "", netError: .unauthorized)))
                    }
                    catch {
                        return handler(.failure(TechnicalError.init(netError: .genericError)))
                    }
                    
                case 400:
                    return handler(.failure(TechnicalError.init(netError: .badEndpoint)))
                    
                case 401:
                    do {
                        let response = try JSONDecoder().decode(ServerError.self, from: data!)
                        return handler(.failure(TechnicalError.init(userMessage: response.message ?? "", message: response.message ?? "", netError: .unauthorized)))
                    }
                    catch {
                        print(error)
                        return handler(.failure(TechnicalError.init(netError: .genericError)))
                    }
                    
                case 405:
                    return handler(.failure(TechnicalError.init(netError: .badEndpoint)))
                    
                case 500...999:
                    return handler(.failure(TechnicalError.init(netError: .serverError)))
                    
                case 200...399:
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data!)
                        return handler(.success(response))
                    }
                    catch {
                        print(error)
                        return handler(.success(nil))
                    }
                default:
                    return handler(.failure(TechnicalError.init(netError: .serverError)))
                }
            } else {
                return handler(.failure(TechnicalError.init(netError: .badEndpoint)))
            }
        }
        task.resume()
        
    }
    //MARK: - Methods Helpers
    /**
     Prepare url with given endpoint struct.
     - Parameter endpoint: Endpoint struct to get url info.
     - Returns: Optitional URL configured.
     */
    func prepareUrl(for endpoint: Endpoint) -> URL? {
        // 1
        // Validate url and add any path param to it
        if(endpoint.url == nil ) {
            print(TechnicalError.init(userMessage: "Erro generico", message: "", netError: .badEndpoint))
            return nil
        }
        
        // get URL as variables
        var url: URL = endpoint.url!
        
        // Append path params
        for item in endpoint.pathParams {
            url = url.appendingPathComponent(item)
        }
        return url
    }
    
    /**
     Add headers to a url request using standard rules.
     
     All kinds of headers who are compliant with *RFC 7231* rules are accepted here, other will be discarted with not comply.
     
     - Attention:
     - All headers are packed in a dictonary type, follwing the **KV** annotation.
     - Content type and other header will be added in same order who they are in dictonary.
     All header must be complilant with *RFC 7231* rules, if they dont, will be discard and not inclued.
     - All authentication header needs be indentified by key with **"token"** id, or will not be recognized and added, see below:
     ```
     let val: [String:Any?] = ["token" : "..."]
     ```
     If value is **empty**, authentication headers will be discarted.
     - Parameters:
     - url: The url to be transformed into URLRequest
     - httpMode: httpMode enum for set request's method.
     - headers: Dictonary with all header to be applied in URLRequest.
     - Returns:
     URLRequest configured with given http mode and headers.
     */
    func addHeaders(for url: URL, httpMode: httpMode, headers: [String:Any?]) -> URLRequest{
        
        // 1
        // Add http mode type.
        var finalUrl = URLRequest(url: url)
        finalUrl.httpMethod = httpMode.rawValue
        
        // 2
        // Add additional headers
        do {
            
            let token = headers.first?.value as! String
            // Debug token
            #if DEBUG
            print(token)
            #endif
            
            if token != ""{
                finalUrl.addValue(token, forHTTPHeaderField: "X-Auth-Token")
            } else {
                print("Skiping X-Auth-Token header injection!")
            }
        }
        
        return finalUrl
    }
    
    /**
     Get a generic model and encode to given url request.
     
     - Attention:
     The model to be encoded must be a **Encodable** type.
     
     - Parameters:
     - finalUrl: URLRequest for adding encoded model to his body.
     - model: Generic model for enconding.
     - Returns:
     A boolean result from operation.
     */
    func encodeModel<T: Codable>(for finalUrl: inout URLRequest, model: T) {
        // Parse method and add body.
        switch finalUrl.httpMethod {
        case "GET":
            break
        case "POST":
            let request = try! JSONEncoder().encode(model)
            finalUrl.httpBody = request
            finalUrl.addValue("application/json", forHTTPHeaderField:"Content-Type")
            finalUrl.addValue("*/*", forHTTPHeaderField: "Accept")
        default:
            break
        }
    }
}

//MARK: - Network Enums
/// Enum for all Network Errors
enum NetworkError: Error {
    case invalidURL
    case badRequest
    case badEndpoint
    case cannotFindHost
    case genericError
    case notFound
    case serverError
    case unauthorized
}

/// Http modes to make the request.
enum httpMode : String{
    case post
    case get
    case put
    case delete
    case update
    case patch
    
    var value : String {
        switch self {
        case .post: return "POST"
        case .get: return "GET"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .update: return "UPDATE"
        case .patch: return "PATCH"
        }
    }
}

/// Sorting enum for query filter
enum Sorting : String {
    /// Decresent parameter for filter
    case decresent
    /// Cresent parameter for filter
    case cresent
}

//MARK: - Error helper
/// Codable class to parse all error occured in network process.
class ServerError: Decodable {
    var dateTime: String?
    var httpStatus: String?
    var message: String?
    var errors: Array<InternalServerError>?
}

/// Internal codable for all internal server error.
class InternalServerError : Codable{
    var userMessage: String?
    var technicalMessage: String?
}

/// Endpoint base structure for app API
struct Endpoint {
    /// The path of endpoint in absolute format
    let path: String
    
    /// The query items for given request
    let queryItems: [URLQueryItem]
    
    /// Path params to be appended.
    let pathParams: [String]
    
    /// Base url to be injected
    let baseURL: String
    
    let headers: [String:Any?]
    
}

//MARK: - Extensions
/// Endpoint extension.
extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "interlopersonar.ddns.net"
        components.port = 8081
        
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
