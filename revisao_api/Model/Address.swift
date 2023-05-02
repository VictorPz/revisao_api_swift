//
//  Address.swift
//  revisao_api
//
//  Created by Victor Pizetta on 01/05/23.
//

import UIKit

struct Address: Codable {
    let zipcode: String
    let address: String
    let city: String
    let uf: String
    
    /*A Api não manda os dados do modo como está, ela manda em pt-br. Quando não há correspondência de nomenclara
     ou nomes com espaçamento na api, podemos usar o coding keys para definir os nomes.
     */
    //Este enum tem que seguir este padrão, se chamar CodingKeys(plural) e extender uma string e o CodingKey
    //Depois ele impelementa o case para cada valor e a respectiva nomenclatura que está na api
    enum CodingKeys: String, CodingKey {
        case zipcode = "cep"
        case address = "logradouro"
        case city = "localidade"
        case uf //Não preciso definir o uf pois é o mesmo nome que está na api
    }
}
