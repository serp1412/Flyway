struct FlightsRequest: RequestType {
    typealias ResponseType = [Flight]
    let endpoint: String = "/test/flights.json"
}
