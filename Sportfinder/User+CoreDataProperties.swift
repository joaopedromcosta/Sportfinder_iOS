//
//  User+CoreDataProperties.swift
//  Sportfinder
//
//  Created by pedro on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var nome: String?
    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var morada: String?
    @NSManaged public var total_pontos: String?

}
