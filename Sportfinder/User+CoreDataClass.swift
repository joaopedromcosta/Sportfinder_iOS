//
//  User+CoreDataClass.swift
//  Sportfinder
//
//  Created by pedro on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    
    //save data
    static func saveUser(nome: String, id: String, email: String, morada: String, total_pontos:String, appDel: AppDelegate){
        let context = appDel.persistentContainer.viewContext
        let user = NSEntityDescription.entity(forEntityName: "User", in: context)
        let transc = NSManagedObject(entity: user!, insertInto: context)
        
        transc.setValue(nome, forKey: "nome")
        transc.setValue(id, forKey: "id")
        transc.setValue(email, forKey: "email")
        transc.setValue(morada, forKey: "morada")
        transc.setValue(total_pontos, forKey: "total_pontos")
        
        do{
            try context.save()
            print("Guardado!")
        } catch let error as NSError {
            print("Nao foi possivel gravar \(error)")
        }  catch{
            
        }
    }
}
