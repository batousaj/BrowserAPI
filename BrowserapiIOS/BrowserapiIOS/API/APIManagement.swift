//
//  APIManagement.swift
//  BrowserapiIOS
//
//  Created by Mac Mini 2021_1 on 26/09/2022.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    init() {}
    
    func request(url : URL?, style: RequestStyle) -> URLRequest? {
        if let url = url {
            var request = URLRequest(url: url)
            request.addValue("v1", forHTTPHeaderField: "Accept-Version")
            request.addValue("1000", forHTTPHeaderField: "X-Ratelimit-Limit")
            request.addValue("999", forHTTPHeaderField: "X-Ratelimit-Remaining")
            
            if style == .kTypeUser {
                let new_token = UserDefaults.standard.value(forKey: "access_token") as! String
                let token_type = UserDefaults.standard.value(forKey: "token_type") as! String 
                request.addValue("\(token_type) \(new_token)", forHTTPHeaderField: "Authorization")
            } else if style == .kTypeGuess {
                request.addValue("Client-ID \(DeviceUtilities.getAccessToken())", forHTTPHeaderField: "Authorization")
            } else {
                //
            }
            return request
        }
        return nil
    }
    
    func requestAPI(method:String?, host:String, path:String?, query: [String:String]?, style: RequestStyle, completion: @escaping ([String:Any]?, Result<Bool, Error>) -> Void) {
        let component = Package.componentAPI(host: host ,path: path ?? nil, query: query ?? nil)
        if var request = request(url: component.url, style: style ) {
            if method != nil {
                request.httpMethod = method
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil,.failure(error!))
                    return
                }
                
                guard let response_ = response as? HTTPURLResponse, (200...299).contains(response_.statusCode) else {
                    let response1 = response as? HTTPURLResponse
                    print("status code : \(response1!.statusCode)")
                    completion(nil,.success(false))
                    return
                }
                
                guard let data = data else {
                    completion(nil,.success(false))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    completion(json as? [String : Any],.success(true))
                } catch {
                    completion(nil,.success(false))
                }
            }
            
            task.resume()
        }
    }
}
