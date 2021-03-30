struct AirportsRequest: RequestType {
    typealias ResponseType = [Airport]
    let endpoint: String = "/test/airports.json"
}
