struct Problem: Codable {
    // Identifiers for database
    let _id: String?
    var _rev: String?

    // Identifiers for set
    var set_name: String
    var problem_id: String
    var problem_type: String
    
    // Unique content
    var question: String
    var answer: String             
    var solution: String?           // only required for TF question (possibly for MRP?)

    // Automatically computed by service. Ordinary users wouldn't have access to manipulate these
    var created_at: String?
}

struct SetName: Codable {
    var set_name: String

    init(set_name: String) {
        self.set_name = set_name
    }
}