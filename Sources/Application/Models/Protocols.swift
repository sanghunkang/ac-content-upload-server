import Kitura
import KituraOpenAPI
import KituraContracts

struct ResponseMessage: Codable {
    let message: String

    init(message: String) {
        self.message = message
    }
}
