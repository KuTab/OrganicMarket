import Foundation
import Combine

struct NetworkService {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    static func doRequest<Result: Codable>(
        with url: String,
        method: HttpMethod = .get,
        headers: [String : String],
        body: [String : Any] = [:]
    ) -> AnyPublisher<Result, Error> {
        var request = URLRequest(url: (.init(string: url)!))
        
        //Set method
        request.httpMethod = method.rawValue
        
        //Add headers
        if !headers.isEmpty {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        //Add body
        if method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return Future<Result, Error>.init { promise in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(error as Any)
                    promise(.failure(error!))
                    return
                }
                do {
                    let value = try JSONDecoder().decode(Result.self, from: data)
                    promise(.success(value))
                } catch {
                    promise(.failure(error))
                }
            }.resume()
        }
        .eraseToAnyPublisher()
    }
}
