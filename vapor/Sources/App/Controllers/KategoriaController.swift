import Fluent
import Vapor

struct KategoriaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("kategoria")
        todos.get(use: index)
        todos.post(use: create)
        todos.put(use: update)
        todos.group(":kategoriaID") { todo in
            todo.get(use: getID)
            todo.delete(use: delete)
        }
    }
    func index(req: Request) throws -> EventLoopFuture<[Kategoria]> {
        return Kategoria.query(on: req.db).all()
    }
    func getID(req: Request) throws -> EventLoopFuture<Kategoria> {
        return Kategoria.find(req.parameters.get("kategoriaID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    func update(req: Request) throws -> EventLoopFuture<Kategoria>{
        let input = try req.content.decode(Kategoria.self)
        return try Kategoria.find(input.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap{
        kategoria in
        kategoria.title = input.title
            return kategoria.save(on: req.db).map{kategoria}
        }
    }
    func create(req: Request) throws -> EventLoopFuture<Kategoria> {
        let todo = try req.content.decode(Kategoria.self)
        return todo.save(on: req.db).map{todo}
    }
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Kategoria.find(req.parameters.get("kategoriaID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
