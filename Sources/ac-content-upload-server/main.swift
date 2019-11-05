import LoggerAPI
import HeliumLogger

import Application
import DotEnv

let env = DotEnv(withFile: ".env")
let version = env.get("VERSION") ?? "unknown"

HeliumLogger.use(.debug)
do {
    let app = try App(version: version)
    try app.run()
} catch let error {
    Log.error(error.localizedDescription)
    print(error.localizedDescription)
}