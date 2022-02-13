import Fluent
import Vapor

struct ProduktController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let produkty = routes.grouped("produkt")
        produkty.get(use: index)
        produkty.post(use: create)
        produkty.put(use: update)
        produkty.group(":produktID") { produkt in
            produkt.delete(use: delete)
            produkt.get(use: getID)     
        }
    }
    func index(req: Request) throws -> EventLoopFuture<[Produkt]> {
        return Produkt.query(on: req.db).all()
    }
    func getID(req: Request) throws -> EventLoopFuture<Produkt> {
        return Produkt.find(req.parameters.get("produktID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<Produkt> {
        let produkt = try req.content.decode(Produkt.self)
        return produkt.save(on: req.db).map { produkt }
    }

    func update(req: Request) throws -> EventLoopFuture<Produkt>{
        let input = try req.content.decode(Produkt.self)
        return try Produkt.find(input.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap{
        produkt in
            produkt.title = input.title
            produkt.description = input.description
            produkt.image = input.image
            produkt.quantity = input.quantity
            return produkt.update(on: req.db).map{produkt}
            
        }
    }
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Produkt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
