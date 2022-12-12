//
//  Networkservice.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//

import Foundation
import SwiftUI

var imageCache = NSCache<AnyObject, AnyObject>()

class NetworkService {
    
    
    static func getData(_ endpoint: URL, completion: @escaping(Data?) -> Void){
        
        URLSession.shared.dataTask(with: URLRequest(url: endpoint), completionHandler: { data, res, err in
            
            if let error = err {
                print(error)
                completion(nil)
                return
            }
            
            guard let res = res as? HTTPURLResponse, res.statusCode == 200
                    
            else {
                completion(nil)
                return
                
            }
            
            
            if let data = data {
                completion(data)
                return
            }
            
        }).resume()
        
        
    }
    
    
    static func decodeData<T: Decodable> (_ model: T.Type, _ data: Data, completion: @escaping(T?) -> Void){
        let x = try? JSONDecoder().decode(model.self, from: data)
        
        if let x = x {
            completion(x)
            return
        }
        
        completion(nil)
        return
    }
    
    
    static func loadImage(_ url: URL, completion: @escaping(UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                print("PULLING \(url) FROM CACHE.")
                completion(imageFromCache)
                return
            }
            
            getData(url) { data in
                
                if let data = data {
                    let image = UIImage(data: data)
                    print("CACHING ->\(url).")
                    imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
                    completion(image)
                    return
                }
                
                else{
                    completion(nil)
                    return
                }
                
            }
        }
       
         
        
    }
    
    
    
    
}


