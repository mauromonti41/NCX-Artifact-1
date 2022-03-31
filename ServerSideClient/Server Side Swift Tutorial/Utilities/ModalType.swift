//
//  ModalType.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 25/03/22.
//

import Foundation

enum Modaltype : Identifiable{
    var id: String{
        switch self{
        case .add: return "add"
        case .update: return "update"
        }
    }
    
    case add
    case update(Song)
}
