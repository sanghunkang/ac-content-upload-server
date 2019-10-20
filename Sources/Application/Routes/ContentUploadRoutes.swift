import KituraContracts
import KituraSession
import MongoKitten
import LoggerAPI
import Foundation

func getCurrentDateString() -> String {
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = formatter.string(from: now)
    return dateString
}

func initializeContentUploadRoutes(app: App) {
    app.router.post("/insertContent", handler: app.insertContentHandler)
    app.router.post("/insertContents", handler: app.insertContentsHandler)
    // app.router.post("/updateContent", handler: app.updateContentHandler)
}


extension App {
    static let database = try! Database.synchronousConnect("mongodb://mongo:27017/adaptive_cram")
    // static let database = try! Database.synchronousConnect("mongodb://localhost/adaptive_cram")

    // Insert content defined by user into database
    func insertContentHandler(session: CheckoutSession, content: Content, completion: @escaping (ResponseMessage?, RequestError?) -> Void) {
        // Check if collections exist
        let collection = App.database["contents"]
        
        // Insert Document
        do {

            // Check if content_id already exists
            let exixtingContents = try collection
                .find([
                    "content_id": content.content_id
                ])
                .decode(Content.self)
                .getAllResults()
                .wait()
            
            if (0 < exixtingContents.count) {
                completion(nil, .notAcceptable) 
            }


            var content = content
            content.created_at = getCurrentDateString()
            content.count_succeeded = content.count_succeeded ?? 0
            content.count_failed = content.count_failed ?? 0
            content.count_gaveup = content.count_gaveup ?? 0
            
            let document: Document = try BSONEncoder().encode(content)
            
            collection.insert(document)
            session.contents.append(content)
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
    func insertContentsHandler(session: CheckoutSession, contents: [Content], completion: @escaping (ResponseMessage?, RequestError?) -> Void) {
        // Check if collections exist
        let collection = App.database["contents"]
        
        // Insert Document
        do {
            let contents = contents.map { content -> Content in
                var content = content
                content.created_at = getCurrentDateString()
                content.count_succeeded = content.count_succeeded ?? 0
                content.count_failed = content.count_failed ?? 0
                content.count_gaveup = content.count_gaveup ?? 0
                return content
                // return try BSONEncoder().encode(content)
                // session.contents.append(contentsOf: contents)
            }
            // session.save()

            
            let documents: [Document] = try contents.map { content in 
                return try BSONEncoder().encode(content)
            }
            collection.insert(documents: documents)
            
            session.contents.append(contentsOf: contents)
            session.save()
            
            // Prepare response
            let respoeseMessage = ResponseMessage(message: "succesfully updated content")
            completion(respoeseMessage, nil)
        } catch let error {
            Log.error(error.localizedDescription)
            return completion(nil, .internalServerError)
        }
    }
}