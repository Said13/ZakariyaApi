import Vapor
import FluentProvider
import HTTP

final class Post: Model {
    let storage = Storage()
    static let idKey = "id"
    
    var title: String?
    var body: String?
    var link: String?
    
    
    init(title: String?, body: String?, link: String?) {
        self.title = title
        self.body = body
        self.link = link
    }
    
    // initiate post with database data
    init(row: Row) throws {
        title = try row.get("title")
        body = try row.get("body")
        link = try row.get("link")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("body", body)
        try row.set("link", link)
        return row
    }
}

/// MARK: Fluent Preparation
extension Post: Preparation {
    
    // prepares a table in the database
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("title")
            builder.string("body", length: 4096)
            builder.string("link")

        }
    }
    
    // deletes the table from the database
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

/// MARK: JSON
extension Post: JSONConvertible {
    
    // let you initiate post with json
    convenience init(json: JSON) throws {
        self.init(
            title: try json.get("title"),
            body: try json.get("body"),
            link: try json.get("link")
        )
    }
    
    // create json out of post instance
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Post.idKey, id)
        try json.set("title", title)
        try json.set("body", body)
        try json.set("link", link)
        return json
    }
}

extension Post: ResponseRepresentable { }

