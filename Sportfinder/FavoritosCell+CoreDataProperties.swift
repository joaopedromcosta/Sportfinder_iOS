//
//  FavoritosCell+CoreDataProperties.swift
//  
//
//  Created by João Costa on 11/06/2019.
//
//

import Foundation
import CoreData


extension FavoritosCell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritosCell> {
        return NSFetchRequest<FavoritosCell>(entityName: "FavoritosCell")
    }

    @NSManaged public var avaliacao: String?
    @NSManaged public var fotoData: NSData?
    @NSManaged public var id: String?
    @NSManaged public var nome: String?

}
