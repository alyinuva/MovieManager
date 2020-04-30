//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "3d8dc3b5a054b350485b8589214db5b5"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        // Se crean constantes dentro del enum con el único proposito de mantener separado la base y el apiKey del URL almacenados en un lugar distinto que el getWatchlist.
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        static let requestTokenEndPoint = "/authentication/token/new"
        static let authenticationLogin = "/authentication/token/validate_with_login"
        static let newSessionEndpoint = "/authentication/session/new"
        
        case getWatchlist
        case getRequestTokenURL
        case login
        case createSessionID
        
        var stringValue: String {
            switch self {
            case .getWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                // Subsequent query parameters son separados con un & (&session_id...)
            case .getRequestTokenURL:
                return Endpoints.base + Endpoints.requestTokenEndPoint + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + Endpoints.authenticationLogin + Endpoints.apiKeyParam
            case .createSessionID:
                return Endpoints.base + Endpoints.newSessionEndpoint + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        // Esta es una clásica función de llamado de URL. El único parámetro es un scaping function que toma como referencias dos opcionales: una lista de objetos Movie y un error. Se hace un llamado al url de getWatchlist y si en caso se devuelve data, se hace decode creando un objeto llamado responseObject de tipo MovieResults. MovieResults tiene un parametro results que ess una lista de Movie, que es lo que finalmente se pasará al completionHandler.
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completionOfgetAuthToken: @escaping (Bool, Error?) -> Void) {
        
        let tokenRequestURL = Endpoints.getRequestTokenURL.url
        let task = URLSession.shared.dataTask(with: tokenRequestURL) {
            (data, response, error) in
            guard let data = data else {
                completionOfgetAuthToken(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let authToken = try decoder.decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = authToken.requestToken
                completionOfgetAuthToken(true, nil)
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completionFuncHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(LoginRequest(username: username, password: password, requestToken: Auth.requestToken))
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let dataLogin = data else {
                completionFuncHandler(false, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(RequestTokenResponse.self, from: dataLogin)
                Auth.requestToken = responseObject.requestToken
                completionFuncHandler(true, nil)
            } catch {
                completionFuncHandler(false, error)
            }
        }
        task.resume()
    }
    
    class func session(completionSessionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.createSessionID.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(PostSession(requestToken: Auth.requestToken))
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data  else {
                completionSessionHandler(false, error!)
                return
            }
                        
            do {
                let responseObject = try JSONDecoder().decode(SessionResponse.self, from: data)
                Auth.sessionId = responseObject.sessionID
                completionSessionHandler(true, nil)
            } catch let taskError {
                print(taskError)
            }
        }
        task.resume()
    }
}
