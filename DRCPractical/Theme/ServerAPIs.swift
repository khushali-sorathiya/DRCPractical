//
//  ServerAPIs.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import UIKit
import Alamofire
import SwiftyJSON


class ServerAPIs: NSObject {
     
    //Gereral get request
    class func getRequest(completion: @escaping (_ response: JSON, _ error: NSError?, _ statusCode: Int)-> ()){
        
        let APIURL = "https://fakestoreapi.com/products"
        
        AF.request(APIURL, method: .get).responseJSON { (response) -> Void in
            if (response.error == nil) {
                
                print(response.result);
                if response.data?.count == 0 {
                    completion(JSON.null,nil,(response.response?.statusCode)!)
                }else{
                    let dataLog = try! JSON(data: response.data!)
                    //print(dataLog);
                    completion(dataLog,nil,(response.response?.statusCode)!)
                }
            }else{
                if (response.response != nil){
                    completion(JSON.null,nil,(response.response?.statusCode)!)
                }else{
                    completion(JSON.null,nil,0)
                }
            }
        }
    }
    
}

