import Fluent
import Vapor

final class Cart: Model, Content {
    static let schema = "cart"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user_id: User
    
    @Field(key: "quantity")
    var quantity:  Int
    
    @Parent(key: "produkt_id")
    var kategoria_id: Kategoria
    
    init() { }

    init(id: UUID? = nil, quantity: Int) {
        self.id = id
        self.quantity = quantity
    }
}
