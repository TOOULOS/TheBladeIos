//
//  NetworkAdapter.swift
//  MaidFinder
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 Mac_Mini17. All rights reserved.
//


import Foundation
import Moya
import NVActivityIndicatorView

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

extension TargetType {
    
    func provider<T: TargetType>() -> MoyaProvider<T> {
        return MoyaProvider<T>(plugins: [(NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter))])
    }
    
    func request(showSpinner: Bool? = true, success successCallBack: @escaping (Any?) -> Void, error errorCallBack: ((String?) -> Void)? = nil) {
        
        if showSpinner ?? true {
            let activityData = ActivityData()
           NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
        
        provider().request(self) { (result) in
            //Hide Loader after getting response
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
           
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200, 201:
                    let model = self.parseModel(data: response.data)
                    successCallBack(model)
                case 404:
                    debugPrint("Session expire")
                    
                  do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String : Any]
                  //      Toast.shared.showAlert(type: .apiFailure, message: /(json?["message"] as? String))
                     Toast.shared.showAlert(type: .apiFailure, message: "Session Expired, Please login again")
                        errorCallBack?(/(json?["message"] as? String))
                    } catch {
                        Toast.shared.showAlert(type: .apiFailure, message: error.localizedDescription)
                    }
                    self.logOut()
                case 403:
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String : Any]
                        if (/(json?["message"] as? String)?.contains("Invalid Token.")) || (/(json?["message"] as? String)?.contains("Authorization is required.")) {
                            self.logOut()
                        } else {
                            Toast.shared.showAlert(type: .apiFailure, message: /(json?["message"] as? String))
                            successCallBack(nil)
                        }
                        
                        //errorCallBack?(/(json?["message"] as? String))
                    } catch {
                        Toast.shared.showAlert(type: .apiFailure, message: error.localizedDescription)
                    }
                case 400, 409, 500, 401:
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String : Any]
                        if let success =  json?["code"] as? Int{
                            if success == 404{
                                self.logOut()
                            } else if success == 401{
                                self.logOut()
                            }
                        }
                        Toast.shared.showAlert(type: .validationFailure, message: /(json?["message"] as? String))
                        errorCallBack?(/(json?["message"] as? String))
                    } catch {
                        Toast.shared.showAlert(type: .apiFailure, message: error.localizedDescription)
                    }
                default:
                    Toast.shared.showAlert(type: .apiFailure, message: "Error Default")
                }
            case .failure(let error):
                Toast.shared.showAlert(type: .apiFailure, message: error.localizedDescription)
                errorCallBack?(error.localizedDescription)
            }
        }
    }
  
    //MARK: - Logout
    fileprivate func logOut() {
        UserPreference.shared.data = nil
        
       
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "InitVC")
        UIApplication.shared.keyWindow?.rootViewController = vw
    }
    
}
