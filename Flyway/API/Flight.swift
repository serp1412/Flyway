struct Flight: Codable, Equatable {
    let airlineId: String
    let flightNumber: Int
    let departureAirportId: String
    let arrivalAirportId: String
}

//{
//    "airlineId": "CX",
//    "flightNumber": 270,
//    "departureAirportId": "AMS",
//    "arrivalAirportId": "HKG"
//  },
