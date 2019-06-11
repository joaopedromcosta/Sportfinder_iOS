//
//  FavoritosCell+CoreDataClass.swift
//  
//
//  Created by João Costa on 11/06/2019.
//
//

import Foundation
import CoreData
import UIKit

@objc(FavoritosCell)
public class FavoritosCell: NSManagedObject {
    static func guardarLocal(local: EntityLocal, appDel: AppDelegate){
        //print("Estou a armazenar locais no core data")
        let context = appDel.persistentContainer.viewContext
        let localNovo = NSEntityDescription.entity(forEntityName: "FavoritosCell", in: context)
        let transc = NSManagedObject(entity: localNovo!, insertInto: context)
        
        transc.setValue(local.id_local, forKey: "id")
        transc.setValue(local.nome, forKey: "nome")
        transc.setValue(local.mediaLocal, forKey: "avaliacao")
        //
        let image = local.foto
        let imageData:NSData = image!.pngData()! as NSData
        transc.setValue(imageData, forKey: "fotoData")
        do{
            try context.save()
            //print("Guardado!")
        } catch let error as NSError {
            //print("Nao foi possivel gravar \(error)")
        }  catch{
            
        }
    }
    
    static func getLocais(appDel: AppDelegate) -> [EntityLocal]?{
        var locaisArray = [EntityLocal]()
        let dataFetchRequest = NSFetchRequest<FavoritosCell>(entityName: "FavoritosCell")
        var results : [FavoritosCell]
        do{
            //print("Estou a carregar locais do core data")
            results = try appDel.persistentContainer.viewContext.fetch(dataFetchRequest)
            var local1:EntityLocal
            for item in results {
                local1 = EntityLocal()
                local1.id_local = item.id!
                local1.nome = item.nome!
                local1.mediaLocal = item.avaliacao!
                //get image
                local1.foto = UIImage(data: (item.fotoData as! NSData) as Data)
                locaisArray.append(local1)
            }
        } catch{
            
        }
        return locaisArray
    }
    static func removerLocais(appDel: AppDelegate){
        let context = appDel.persistentContainer.viewContext
        let dataFetchRequest = NSFetchRequest<FavoritosCell>(entityName: "FavoritosCell")
        
        if let result = try? appDel.persistentContainer.viewContext.fetch(dataFetchRequest){
            for object in result{
                context.delete(object)
            }
        }
    }
    //
    static func delete(id: String, appDel: AppDelegate){
        let context = appDel.persistentContainer.viewContext
        let dataFetchRequest = NSFetchRequest<FavoritosCell>(entityName: "FavoritosCell")
        let predicate = NSPredicate(format: "id == %@", id)
        dataFetchRequest.predicate = predicate
        
        if let result = try? appDel.persistentContainer.viewContext.fetch(dataFetchRequest){
            for object in result{
                context.delete(object)
            }
        }
    }
}
