//
//  UserPreference.swift
//  MaidFinder
//
//  Created by Gurleen on 20/08/19.
//  Copyright © 2019 MAC_MINI_6. All rights reserved.
//

import Foundation

class UserPreference {
  
  let DEFAULTS_KEY = "MAIDFINDER_KEYS"
  let APPDATA_KEY = "MAIDFINDER_DATA"
  static let shared = UserPreference()
    
  
  var data : SignupModel? {
    get{
      return fetchData()
    }
    set{
      if let value = newValue {
        saveData(value)
      } else {
        removeData()
      }
    }
  }
    
//    var appData:SplashInfoDetails?{
//        get{
//            return fetchAppData()
//        }set{
//            if let value = newValue{
//                saveAppData(value)
//            }else{
//                removeAppData()
//            }
//        }
//    }
    
    var credits:Int?{
        get{
            UserDefaults.standard.value(forKey: "CREDITS") as? Int
        }set{
            if let value = newValue{
                UserDefaults.standard.set(value, forKey: "CREDITS")
            }
        }
    }
  
  func saveData(_ value: SignupModel) {
    guard let data = JSONHelper<SignupModel>().getData(model: value) else {
      removeData()
      return
    }
    UserDefaults.standard.set(data, forKey: DEFAULTS_KEY)
  }
  
  func fetchData() -> SignupModel? {
    guard let data = UserDefaults.standard.data(forKey: DEFAULTS_KEY) else {
      return nil
    }
    return JSONHelper<SignupModel>().getCodableModel(data: data)
  }
  
  func removeData() {
    UserDefaults.standard.removeObject(forKey: DEFAULTS_KEY)
  }
    
//    func saveAppData(_ value: SplashInfoDetails) {
//      guard let data = JSONHelper<SplashInfoDetails>().getData(model: value) else {
//        removeData()
//        return
//      }
//      UserDefaults.standard.set(data, forKey: APPDATA_KEY)
//    }
//    
//    func fetchAppData() -> SplashInfoDetails? {
//      guard let data = UserDefaults.standard.data(forKey: APPDATA_KEY) else {
//        return nil
//      }
//      return JSONHelper<SplashInfoDetails>().getCodableModel(data: data)
//    }
    
    func removeAppData() {
      UserDefaults.standard.removeObject(forKey: APPDATA_KEY)
    }
    
}


