import Fluent
import Vapor

final class BuyHistory: Model, Content {
    static let schema = "buy_history"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_id")
    var user_id: User
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "quantity")
    var quantity:  Int
    
    @Parent(key: "produkt_id")
    var kategoria_id: Kategoria
    
    init() { }

    init(id: UUID? = nil, quantity: Int, description: String) {
        self.id = id
        self.description = description
        self.quantity = quantity
    }
}
