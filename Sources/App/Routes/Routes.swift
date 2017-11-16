import Vapor

extension Droplet {
    func setupRoutes() throws {
        
        try resource("post", PostController.self)
    }
}
