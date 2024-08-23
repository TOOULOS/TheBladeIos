//
//  UserDetail.swift
//  InsureTika
//
//  Created by keshav kumar on 02/02/20.
//  Copyright © 2020 keshav kumar. All rights reserved.
//

import UIKit
import Foundation

//class UserDetail: Codable {
//    var meta: Meta?
//    var data: UserDetail?
//}
//
//class Meta: Codable {
//    var type: String?
//    var statusCode: Int?
//    var message: String?
//
//}


class UserData: Codable {
    var id : Int?
    var authentication_token : String?
    var status               : Int?
    var phone_number         : String?
    var phone_is_verified    : Int?
    var profile_image        : String?
    var email                : String?
    var name                 : String?
    var country_code         : Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case authentication_token
        case status
        case phone_number
        case phone_is_verified
        case profile_image
        case email
        case name
        case country_code
    }
    
    //MARK: - Decode
    required init(from decoder: Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            if let value = try? container.decode(String.self, forKey: .authentication_token){
                authentication_token = value
            }else if let value = UserPreference.shared.data?.token{
                if value != ""{
                    authentication_token = value
                }
            }
            status = try container.decode(Int.self, forKey: .status)
            phone_number = try container.decode(String.self, forKey: .phone_number)
            phone_is_verified = try container.decode(Int.self, forKey: .phone_is_verified)
            profile_image = try container.decode(String.self, forKey: .profile_image)
            email = try container.decode(String.self, forKey: .email)
            name = try container.decode(String.self, forKey: .name)
            country_code = try container.decode(Int.self, forKey: .country_code)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: - Encode
    func encode(to encoder: Encoder) {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(authentication_token, forKey: .authentication_token)
            try container.encode(status, forKey: .status)
            try container.encode(phone_number, forKey: .phone_number)
            try container.encode(phone_is_verified, forKey: .phone_is_verified)
            try container.encode(profile_image, forKey: .profile_image)
            try container.encode(email, forKey: .email)
            try container.encode(name, forKey: .name)
            try container.encode(country_code, forKey: .country_code)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

class ObjectData<T: Codable>: Codable {
    var data: T?
    var msg: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "body"
        case msg = "message"
        case code
    }
}

struct DefaultModel: Codable {
    var msg: String?
    var code: Int?
    
    enum CodingKeys: String, CodingKey {
        case msg = "message"
        case code
    }
}



