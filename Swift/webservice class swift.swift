//
//  webservice class swift.swift
//
//  Created by Femina Rajesh Brahmbhatt on 07/08/17.
//  Copyright © 2017 Femina Rajesh Brahmbhatt. All rights reserved.
//
//<key>NSAppTransportSecurity</key>
//<dict>
//<key>NSExceptionDomains</key>
//<dict>
//<key>aeinfraproject.com</key>
//<dict>
//<key>NSAllowsArbitraryLoads</key>
//<true/>
//<key>NSExceptionAllowsInsecureHTTPLoads</key>
//<true/>
//<key>NSIncludesSubdomains</key>
//<true/>
//<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
//<true/>
//</dict>
//</dict>
//</dict>
import Foundation

class webserviceclassswift{
    
    static let sharedinstance = webserviceclassswift()
    var _HUD = MBProgressHUD()
    typealias CompletionHandler = (_ dictionary:NSDictionary?,_ error:Error?) -> Void

// MARK:- GET method


    func JsonCallGET(view:UIView,urlString:String,completionHandler: @escaping CompletionHandler)-> Void{
        
        if Reachability.isConnectedToNetwork() == true
        {
            var config                              :URLSessionConfiguration!
            var urlSession                          :URLSession!
            
            config = URLSessionConfiguration.default
            urlSession = URLSession(configuration: config)
            
            let callURL = URL.init(string: "https://itunes.apple.com/in/rss/newapplications/limit=10/json")
            
            let request:NSMutableURLRequest = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60.0) as! NSMutableURLRequest
            
            request.httpMethod = "GET"
            
            showLoadingHUD(to_view: view)
            
            let dataTask = urlSession.dataTask(with: request as URLRequest) { (data,response,error) in
                if error != nil{
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    return
                }
                do {
                    self.hideLoadingHUD(for_view: view)
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    print("Result",resultJson!)
                    completionHandler(resultJson,nil)
                    
                    //return resultJson
                } catch {
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    print("Error -> \(error)")
                }
            }
            
            dataTask.resume()
            //print("Internet Connection Available!")
        }
        else
        {
            showAlertMessage(titleStr: "Connection Unavailable", messageStr: "Please check your connection and try again")
            // print("Internet Connection not Available!")
        }
        
        
    }
    
    // MARK:- POST method
    
    func JsonCallPOST(view:UIView,dicData:NSDictionary,completionHandler: @escaping CompletionHandler)-> Void{
        
        if Reachability.isConnectedToNetwork() == true
        {
            var config                              :URLSessionConfiguration!
            var urlSession                          :URLSession!
            
            config = URLSessionConfiguration.default
            urlSession = URLSession(configuration: config)
            
            let callURL = URL.init(string: "http://aeinfraproject.com/littr/api.php")
            
            let request:NSMutableURLRequest = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60.0) as! NSMutableURLRequest
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                let postdata = try JSONSerialization.data(withJSONObject:dicData)
                request.httpBody = postdata
            } catch {
                print("Dim background error")
            }
            
            showLoadingHUD(to_view: view)
            
            let dataTask = urlSession.dataTask(with: request as URLRequest) { (data,response,error) in
                if error != nil{
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    return
                }
                do {
                    self.hideLoadingHUD(for_view: view)
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    print("Result",resultJson!)
                    completionHandler(resultJson,nil)
                    
                    //return resultJson
                } catch {
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    print("Error -> \(error)")
                }
            }
            
            dataTask.resume()
            print("Internet Connection Available!")
        }
        else
        {
            showAlertMessage(titleStr: "Connection Unavailable", messageStr: "Please check your connection and try again")
            print("Internet Connection not Available!")
        }
        
        
        
    }

    // MARK:- FORM-DATA method

    func JsonCallWithImage(view:UIView,imageData:Data,strfieldName:String,param:NSDictionary,completionHandler: @escaping CompletionHandler)-> Void{
    
        if Reachability.isConnectedToNetwork() == true
        {
            var config:URLSessionConfiguration!
            var urlSession:URLSession!
        
            config = URLSessionConfiguration.default
        
            urlSession = URLSession(configuration: config)
        
            let url = URL.init(string: "https://itunes.apple.com/in/rss/newapplications/limit=10/json")
        
            let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        
            let FileParamConstant = strfieldName as NSString
        
            let request:NSMutableURLRequest = NSMutableURLRequest()
        
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
            request.httpShouldHandleCookies = false
        
            request.httpMethod = "POST"
        
            let contentType = String(format: "multipart/form-data; boundary=%@", BoundaryConstant)
        
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
            var body = Data()
        
            param.enumerateKeysAndObjects({ (parameterKey, parameterValue, stop) in
            //var bodystr = String(format: "--%@\r\n", BoundaryConstant)
                body.append(String(format: "--%@\r\n", BoundaryConstant).data(using: .utf8)!)
                body.append(String(format: "Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey as! CVarArg).data(using: .utf8)!)
                body.append(String(format: "%@\r\n", parameterValue as! CVarArg).data(using: .utf8)!)
            })
        
        //    if imageData {
            body.append(String(format: "--%@\r\n", BoundaryConstant).data(using: .utf8)!)
            body.append(String(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant).data(using: .utf8)!)
            body.append(String(format: "Content-Type: image/jpeg\r\n\r\n").data(using: .utf8)!)
        
            body.append(imageData)
            body.append(String(format: "%@\r\n").data(using: .utf8)!)
        
        //    }
        
            body.append(String(format: "--%@--\r\n", BoundaryConstant).data(using: .utf8)!)
        
            request.httpBody = body
        
            request.url = url
        
            showLoadingHUD(to_view: view)
        
            let dataTask = urlSession.dataTask(with: request as URLRequest) { (data,response,error) in
                if error != nil{
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    return
                }
                do {
                    self.hideLoadingHUD(for_view: view)
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    print("Result",resultJson!)
                    completionHandler(resultJson,nil)
                
                //return resultJson
                } catch {
                    self.hideLoadingHUD(for_view: view)
                    completionHandler(nil,error as NSError?)
                    print("Error -> \(error)")
                }
            }
        
            dataTask.resume()
            print("Internet Connection Available!")
        }
        else
        {
            showAlertMessage(titleStr: "Connection Unavailable", messageStr: "Please check your connection and try again")
            print("Internet Connection not Available!")
        }
    
    
    
    }

    func showLoadingHUD(to_view: UIView) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: to_view, animated: true)
            hud.label.text = "Loading..."
        }
    
    }

    func hideLoadingHUD(for_view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: for_view, animated: true)
        }
    }

    func showAlertMessage(titleStr: String, messageStr: String = "")
    {
        let alertView = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
    
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
    
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }

}
