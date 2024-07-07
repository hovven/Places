import Foundation

extension Data {
    func decoded<T: Decodable>(
        as type: T.Type, using decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        do {
            return try decoder.decode(T.self, from: self)
        } catch {
            throw PlaceError.Network.decodingError
        }
    }
}
