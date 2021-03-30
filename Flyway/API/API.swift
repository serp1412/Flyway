import Foundation

protocol APIType {
    func getAirports(completion: @escaping (Result<[Airport], APIError>) -> ())
    func getFlights(completion: @escaping (Result<[Flight], APIError>) -> ())
}

class APIError: Error {}

class API: APIType {
    func getAirports(completion: @escaping (Result<[Airport], APIError>) -> ()) {
        perform(request: AirportsRequest(), completion: completion)
    }
    
    func getFlights(completion: @escaping (Result<[Flight], APIError>) -> ()) {
        perform(request: FlightsRequest(), completion: completion)
    }
    
    private func perform<R: RequestType>(request: R,
                                         completion: @escaping (Result<R.ResponseType, APIError>) -> ()) {
        URLSession.shared.dataTask(with: request.url) { (data, _, _) in
            guard let data = data else { return } // TODO: no data error
            
            do {
                let response = try JSONDecoder().decode(R.ResponseType.self, from: data)
                callOnMain(completion, with: .success(response))
            } catch {
                callOnMain(completion, with: .failure(APIError())) // TODO: parsing error
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
