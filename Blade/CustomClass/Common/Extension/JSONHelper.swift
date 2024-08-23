//
//  JSONHelper.swift
//  MaidFinder
//
//  Created by Gurleen on 20/08/19.
//  Copyright © 2019 MAC_MINI_6. All rights reserved.
//

import Foundation

class JSONHelper<T: Codable> {
  
  init() {
    
  }
  
  func getCodableModel(data: Data) -> T? {
    let model = try? JSONDecoder().decode(T.self, from: data)
    return model
  }
  
  func getData(model: T) -> Data? {
    guard let data: Data = try? JSONEncoder().encode(model) else {
      return nil
    }
    return data
  }
}
