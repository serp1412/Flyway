import Foundation

private let baseURL = "https://flightassets.datasavannah.com"

protocol RequestType {
    associatedtype ResponseType: Codable
    var endpoint: String { get }
}

extension RequestType {
    var url: URL {
        return URL(string: baseURL + endpoint)!
    }
}
