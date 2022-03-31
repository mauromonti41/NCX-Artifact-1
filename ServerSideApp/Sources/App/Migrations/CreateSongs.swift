//
//  CreateSongs.swift
//  
//
//  Created by Mauro Monti on 24/03/22.
//

import Fluent

struct CreateSongs: Migration{
    
//    This function is needed for the changes that we want to apply to our DataBase
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs")
//        songs is pratically our database. It is represented by different
//        in the following we define the different properties for each row of the table (database)
            .id()
//        the field is pratically a column of the database
            .field("title", .string, .required)
            .create()
//        the whole block of code inside the prepare func simply means that we create a table called "songs" in which the row elements have an id ad a property called title, which is a type string and it is required as information. Than we create it by means of the create() method.
    }
    
//    Undo the change made in `prepare`, if possible.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
    
    
}
