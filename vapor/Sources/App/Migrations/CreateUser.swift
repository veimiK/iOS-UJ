import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user")
            .id()
            .field("name", .string, .required).unique(on: "name")
            .field("password", .string, .required)
            .create()
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user").delete()
    }
}
