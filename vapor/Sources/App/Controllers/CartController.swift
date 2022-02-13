import Fluent
import Vapor

struct CartController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let Carts = routes.grouped("cary")
        Carts.get(use: index)
        Carts.post(use: create)
        Carts.put(use: update)
        Carts.group(":cartID") { Cart in
            Cart.delete(use: delete)
            Cart.get(use: getID)
                   
        }
        
    }
    func index(req: Request) throws -> EventLoopFuture<[Cart]> {
        return Cart.query(on: req.db).all()
    }
    func getID(req: Request) throws -> EventLoopFuture<Cart> {
        return Cart.find(req.parameters.get("cartID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    func create(req: Request) throws -> EventLoopFuture<Cart> {
        let Cart = try req.content.decode(Cart.self)
        return Cart.save(on: req.db).map { Cart }
    }
    func update(req: Request) throws -> EventLoopFuture<Cart>{
        let input = try req.content.decode(Cart.self)
        return try Cart.find(input.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap{
        Cart in
        
            Cart.quantity = input.quantity
            return Cart.update(on: req.db).map{Cart}
            
        }
    }
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Cart.find(req.parameters.get("cartID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
        
    }
}
