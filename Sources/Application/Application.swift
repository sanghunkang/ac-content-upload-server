import Kitura
import KituraOpenAPI
import LoggerAPI
import Dispatch

public class App {
    let version: String
    let router = Router()
    let workerQueue = DispatchQueue(label: "worker")

    public init(version: String) throws {
        self.version = version
        Log.info("Hello World")
    }

    func postInit() throws {
        initializeProblemInsertRoutes(app: self)
        KituraOpenAPI.addEndpoints(to: router)

        router.get("/") { request, response, next in
            response.send("index of ac-content-upload-server. version = " + self.version)
            next()
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 7002, with: router)
        Kitura.run()
    }

    func execute(_ block: (() -> Void)) {
        workerQueue.sync {
            block()
        }
    }
}