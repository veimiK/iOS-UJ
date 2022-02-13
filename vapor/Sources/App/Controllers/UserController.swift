import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        users.get(use: index)
        users.post(use: create)
        users.put(use: update)
        users.group(":userID") { users in
            users.delete(use: delete)
            users.get(use: getID)
                   
        }
        let user2 = routes.grouped("login")
        user2.post(use: login)
    }
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    func login(req: Request) throws -> EventLoopFuture<User>{
        let input = try req.content.decode(User.self)
        print(input.password, input.name)
        return User.query(on: req.db).filter(\.$name == input.name).first().unwrap(or: Abort(.notFound)).flatMap{
        user in
            print("Login")
            if(user.password == input.password){

                return req.eventLoop.future(user)
            }else{
                
            }

            return req.eventLoop.future(input)
        }
    }
    func getID(req: Request) throws -> EventLoopFuture<User> {
        return User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    func update(req: Request) throws -> EventLoopFuture<User>{
        let input = try req.content.decode(User.self)
        return try User.find(input.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap{
        user in
            user.name = input.name
            user.password = input.password
            return user.update(on: req.db).map{user}
        }
    }
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
        
    }
}
