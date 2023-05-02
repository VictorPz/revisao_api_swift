//
//  Network.swift
//  revisao_api
//
//  Created by Victor Pizetta on 01/05/23.

// Revisão de consumo de api utilizando a Via Cep.

import UIKit

//Nosso enum de erros custom para passar no callback (na prática estaria em outro arquivo por organização)
enum ServiceError: Error {
    case invalidURL
    case decodeFail(Error?)
    case network(Error?)
}

final class Network {
    //Criamos a baseUrl para não repetir ela toda hora (Clean code DRY)
    private let baseUrl = "https://viacep.com.br/ws"
    
    //Criamos agora a nossa func get com o cep que queremos consulta e o callback (Que a API retornará preenchido)
    //@escaping mantém nossa closure viva no escopo mesmo que a nossa func já tenha sido executada
    //No escaping passamos o resultado que esperamos receber e o erro (no caso o enum de erro custom)
    
    func get(cep: String, callback: @escaping (Result<Address, ServiceError>) -> Void) {
        //Defino aqui qual endpoint quero consultar
        let cepPath = "/\(cep)/json"
        //Monto minha url com guard let pois ela pode ser nula
        guard let url = URL(string: baseUrl + cepPath) else {
            callback(.failure(.invalidURL))
            return
        }
        
        //Aqui iniciamos nossa consulta na api com uma nova sessão que retorna 3 args: data, response e error.
        //Data - nossos dados que buscamos, o Body da requisição
        //Response - Objeto de resposta (status code, request utlizada, body, header, cache etc)
        //Error -  caso haja algum erro de comunicação (url invalida etc)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //Validamos nosso data (Verificamos se está preenchido ou não etc, removemos do estado optional)
            guard let data = data else {
                callback(.failure(.network(error)))
                return
            }
            
            //Verificamos se funcionou com o json serialization, convertendo nossa data para um objeto json
            //let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            //callback(.success(json))
            
            //Caso tenha funcionado podemos fazer a decodificação do objeto tipo data pra um objeto codable
            //Atenção para a equivalencia de nomes entre a classe que recebe o codable e a api
            guard let json = try? JSONDecoder().decode(Address.self, from: data) else {
                callback(.failure(.decodeFail(error)))
                return
            }
            callback(.success(json))
        }
        //Como as tasks começam no estado suspenso, precisamos dar um .resume para inicia elas
        task.resume()
    }
}

//Extra dispatch queue
//A consulta feita desta forma com o data task funciona de forma assincrona.

/*
 Por isso usamos o DispatchQueue.main, pois o data task cria uma nova thread para fazer a requisição e quando retorna ainda está dentro desta nova thread. Se não jogarmos ela na main, não conseguiremos printar a informação (vai dar um erro)
 */

//do {
//    let network = Network()
//    network.get(cep: "29297000") {result in
//        DispatchQueue.main.async {
//            switch result {
//            case let .failure(error):
//                print(error)
//            case let .success(data):
//                print(data)
//            }
//        }
//    }
//}
