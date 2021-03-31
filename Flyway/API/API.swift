import Foundation

protocol APIType {
    func getAirports(completion: @escaping (Result<[Airport], APIError>) -> ())
    func getFlights(completion: @escaping (Result<[Flight], APIError>) -> ())
}

class APIError: Error {
    let message: String
    let statusCode: Int?
    init(message: String, statusCode: Int? = nil) {
        self.message = message
        self.statusCode = statusCode
    }
}

class API: APIType {
    func getAirports(completion: @escaping (Result<[Airport], APIError>) -> ()) {
        perform(request: AirportsRequest(), completion: completion)
    }
    
    func getFlights(completion: @escaping (Result<[Flight], APIError>) -> ()) {
        perform(request: FlightsRequest(), completion: completion)
    }
    
    private func perform<R: RequestType>(request: R,
                                         completion: @escaping (Result<R.ResponseType, APIError>) -> ()) {
        
        URLSession.shared.dataTask(with: request.url) { (data, response, _) in
            var result: Result<R.ResponseType, APIError>?
            defer {
                if let result = result {
                    callOnMain(completion, with: result)
                }
            }
            guard let data = data else {
                return result = .failure(.init(message: "Something went terribly wrong"))
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                return result = .failure(.init(message: "Request failed with \(response.statusCode)",
                                               statusCode: response.statusCode))
            }
            
            do {
                let response = try JSONDecoder().decode(R.ResponseType.self, from: data)
                result = .success(response)
            } catch {
                result = .failure(.init(message: "Failed to parse data"))
            }
        }.resume()
    }
}

private func callOnMain<T>(_ completion: @escaping (Result<T, APIError>) -> (),
                           with result: Result<T, APIError>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
