import Fluent
import Vapor

struct BuyHistoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let hist = routes.grouped("buy_history")
        hist.get(use: index)
        hist.post(use: create)
        hist.put(use: update)
        hist.group(":buy_historyID") { BuyHistory in
            BuyHistory.delete(use: delete)
            BuyHistory.get(use: getID)    
        }
    }

    func getID(req: Request) throws -> EventLoopFuture<BuyHistory> {
        return BuyHistory.find(req.parameters.get("cartID"), on: req.db).unwrap(or: Abort(.notFound))
    }           
    
    func index(req: Request) throws -> EventLoopFuture<[BuyHistory]> {
        return BuyHistory.query(on: req.db).all()
    }
    
    
    func create(req: Request) throws -> EventLoopFuture<BuyHistory> {
        let BuyHistory = try req.content.decode(BuyHistory.self)
        return BuyHistory.save(on: req.db).map { BuyHistory }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BuyHistory.find(req.parameters.get("buy_historyID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
        
    }

    func update(req: Request) throws -> EventLoopFuture<BuyHistory>{
        let input = try req.content.decode(BuyHistory.self)
        return try BuyHistory.find(input.id, on: req.db).unwrap(or: Abort(.notFound)).flatMap{
        BuyHistory in
            BuyHistory.quantity = input.quantity
            return BuyHistory.update(on: req.db).map{BuyHistory}
            
        }
    }
}
