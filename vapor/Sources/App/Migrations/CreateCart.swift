import Fluent

struct CreateCart: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cart")
            .id()        
            .field("user_id", .uuid, .required)
            .foreignKey("user_id", references: Kategoria.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .field("quantity", .int, .required)
            .field("produkt_id", .uuid, .required)
            .foreignKey("produkt_id", references: Kategoria.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .create()
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cart").delete()
    }
}
