import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "password")
    var password: String
    
    init() { }

    init(id: UUID? = nil, name: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
    }
}
