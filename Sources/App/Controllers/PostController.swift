import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    
    /// When users call 'GET' on '/post'
    /// it should return an index of all available post
    func index(req: Request) throws -> ResponseRepresentable {
        return try Post.all().makeJSON()
    }
    
    /// When consumers call 'POST' on '/post' with valid JSON
    /// create and save the post
    func create(request: Request) throws -> ResponseRepresentable {
        let post = try request.post()
        try post.save()
        return post
    }
    
    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/post/13rd88' we should show that specific post
    func show(req: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'post/l2jd9' we should remove that resource from the database
    func delete(req: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return Response(status: .ok)
    }
    
    
    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new Post with the same ID.
    func replace(req: Request, post: Post) throws -> ResponseRepresentable {
        // First attempt to create a new Post from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.post()
        
        // Update the post with all of the properties from
        // the new post
        post.title = new.title
        try post.save()
        
        // Return the updated post
        return post
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            destroy: delete
        )
    }
}

extension Request {
    /// Create a post from the JSON body
    /// return BadRequest error if invalid
    /// or no JSON
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(json: json)
    }
}

extension PostController: EmptyInitializable {}

