import KituraContracts
import KituraSession
import MongoKitten
import LoggerAPI



func initializeProblemInsertRoutes(app: App) {
    app.router.post("/insertProblem", handler: app.insertProblemHandler)
    app.router.post("/insertProblems", handler: app.insertProblemsHandler)
    // app.router.post("/updateProblem", handler: app.updateProblemHandler)
}

extension App {
    static let database = try! Database.synchronousConnect("mongodb://mongo:27017/adaptive_cram")
    // static let database = try! Database.synchronousConnect("mongodb://localhost/adaptive_cram")

    // Insert Problem defined by user into database
    func insertProblemHandler(session: CheckoutSession, problem: Problem, completion: @escaping (ResponseMessage?, RequestError?) -> Void) {
        // Check if collections exist
        let collection = App.database["problems"]
        
        // Insert Document
        do {
            // Check if content_id already exists
            let exixtingProblems = try collection
                .find([
                    "problem_id": problem.problem_id
                ])
                // .decode(Problem.self)
                .getAllResults()
                .wait()
            
            guard exixtingProblems.count == 0 else {
                return completion(nil, .notAcceptable) 
            }


            // var content = problem
            // problem.created_at = getCurrentDateString()
            // problem.count_succeeded = problem.count_succeeded ?? 0
            // problem.count_failed = problem.count_failed ?? 0
            // problem.count_gaveup = problem.count_gaveup ?? 0
            
            let document: Document = try BSONEncoder().encode(problem)
            
            collection.insert(document)
            
            session.problems.append(problem)
            session.save()
            
            // Prepare response
            let respoeseMessage = ResponseMessage(message: "succesfully updated content")
            completion(respoeseMessage, nil)
        } catch let error {
            Log.error(error.localizedDescription)
            return completion(nil, .internalServerError)
        }
    }

    // Insert contents defined by user into database
    func insertProblemsHandler(session: CheckoutSession, problems: [Problem], completion: @escaping (ResponseMessage?, RequestError?) -> Void) {
        // Check if collections exist
        let collection = App.database["problems"]
        
        // Insert Document
        do {
            let documents = try problems.map { problem -> Document in
                var problem = problem
                problem.created_at = getCurrentDateString()
                // problem.count_succeeded = problem.count_succeeded ?? 0
                // problem.count_failed = problem.count_failed ?? 0
                // problem.count_gaveup = problem.count_gaveup ?? 0
                // return problem
                // return try BSONEncoder().encode(content)
                // session.contents.append(contentsOf: contents)
                return try BSONEncoder().encode(problem)
            }
            // session.save()

            
            // let documents: [Document] = try problems.map { problem in 
            //     return try BSONEncoder().encode(problem)
            // }
            collection.insert(documents: documents)
            
            session.problems.append(contentsOf: problems)
            session.save()
            
            // Prepare response
            let respoeseMessage = ResponseMessage(message: "succesfully updated problem")
            completion(respoeseMessage, nil)
        } catch let error {
            Log.error(error.localizedDescription)
            return completion(nil, .internalServerError)
        }
    }
}