import KituraContracts
import KituraSession
import MongoKitten
import LoggerAPI

func initializeProblemUpdateRoutes(app: App) {
    app.router.get("/updateProblem", handler: app.updateProblemHandler)
    // app.router.post("/updateProblems", handler: app.updateProblemsHandler)
}

extension App {

    // Insert Problem defined by user into database
    func updateProblemHandler(session: CheckoutSession, completion: @escaping (ResponseMessage?, RequestError?) -> Void) {
        print(" --------------- ---------------")
        print(session.userId)
        print(session.sessionId)
        print(" --------------- ---------------")

        session.userId.append("some user")
        session.save()

        // Prepare response
        let respoeseMessage = ResponseMessage(message: "succesfully updated content")
        completion(respoeseMessage, nil)
    }
}
