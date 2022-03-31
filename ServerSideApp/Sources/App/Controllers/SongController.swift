//
//  SongController.swift
//  
//
//  Created by Mauro Monti on 24/03/22.
//

import Vapor
import Fluent

struct SongController : RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID"){song in
            song.delete(use: delete)
        }
    }
//    GET request /songs route
    func index(req: Request) throws -> EventLoopFuture<[Song]>{
//        What we are doing is a requested of all the songs that are present inside the database. The function return an array of elements that conform to the
//        Song model that we have defined in the Models folder
        return Song.query(on: req.db).all()
    }
//    POST Request /songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let song =  try req.content.decode(Song.self)
        return song.save(on:req.db).transform(to: .ok)
    }
//    PUT Request /songs routes
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        let song =  try req.content.decode(Song.self)
        
        return Song.find(song.id, on: req.db)
//        find function retrieves an optional value. With the unwrap function we try to see if a song with that id exists
//        if the song doesn't exist than we retrieve an error 404 (notFound)
//        if the song exists, than we procede with the code and we update its value
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
//    DELETE Request /songs/id routes
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db)}
                .transform(to: .ok)
    }
}

