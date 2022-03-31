//
//  Song.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 24/03/22.
//

import Foundation

//With codable we can can code and decode everything
//With identifiable we provide and ID to the single element

struct Song: Identifiable, Codable{
    let id: UUID?
    var title: String
}
