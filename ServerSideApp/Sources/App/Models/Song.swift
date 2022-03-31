//
//  Song.swift
//  
//
//  Created by Mauro Monti on 24/03/22.
//

import Fluent
import Vapor

final class Song: Model, Content {
//    This gives information about the table we are pointing
    static let schema = "songs"
//    The @ statement are parameters used in order to communicate with Fluent and describe how the successive data should be recognized inside the database
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
