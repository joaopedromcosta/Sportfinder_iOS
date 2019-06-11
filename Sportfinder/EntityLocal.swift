//
//  EntityLocal.swift
//  Sportfinder
//
//  Created by Benjamim on 11/06/2019.
//  Copyright © 2019 ipvc.estg. All rights reserved.
//

import UIKit

struct EntityLocal: Codable {
    let id: String
    let coordenadas: String
    let raio: String
    let nome: String
    let descricao: String
    let utilizador_id: String
    let url_foto_local: String
    
    
    
    init(json: [String: Any]) {
        id = json["id"] as? String ?? ""
        coordenadas = json["coordenadas"] as? String ?? ""
        raio = json["raio"] as? String ?? ""
        nome = json["nome"] as? String ?? ""
        descricao = json["descricao"] as? String ?? ""
        utilizador_id = json["utilizador_id"] as? String ?? ""
        url_foto_local = json["url_foto_local"] as? String ?? ""
    }
    
    init(string: String) {
        id = ""
        coordenadas = ""
        raio =  ""
        nome =  ""
        descricao = ""
        utilizador_id = ""
        url_foto_local = ""
        
    }
}
