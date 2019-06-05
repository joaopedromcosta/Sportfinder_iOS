//
//  Utilizador+CoreDataClass.swift
//  Sportfinder
//
//  Created by pedro on 05/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Utilizador)
public class Utilizador: NSManagedObject {

    //save data
    static func saveUser(nome: String, id: String, email: String, morada: String, total_pontos:String, appDel: AppDelegate){
        let context = appDel.persistentContainer.viewContext
        let utilizador = NSEntityDescription.entity(forEntityName: "Utilizador", in: context)
        let transc = NSManagedObject(entity: utilizador!, insertInto: context)
        
        transc.setValue(nome, forKey: "nome")
        transc.setValue(id, forKey: "id")
        transc.setValue(email, forKey: "email")
        transc.setValue(morada, forKey: "morada")
        transc.setValue(total_pontos, forKey: "total_pontos")
        
        do{
            try context.save()
            print("\(nome) Guardado!")
        } catch let error as NSError {
            print("Nao foi possivel gravar \(error)")
        }  catch{
            
        }
    }
    
    // get data
    static func getUser(appDel: AppDelegate) -> [Utilizador]? {
        let dataFetchRequest = NSFetchRequest<Utilizador>(entityName: "Utilizador")
        var results : [Utilizador]
        
        do{
            results = try appDel.persistentContainer.viewContext.fetch(dataFetchRequest)
            print(results)
            return results
        } catch{
            
        }
        return nil
    }
}
