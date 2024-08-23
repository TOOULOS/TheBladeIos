//
//  CardModel.swift
//  Blade
//
//  Created by cqlsys on 04/12/22.
//

import Foundation

struct CardModel: Codable {
    var exp_month: Int?
    var country: String?
    var id: String?
    var isDefault: Int?
    var brand: String?
    var last4: String?
    var customer: String?
    var exp_year: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case exp_month
        case country
        case id
        case isDefault
        case brand
        case last4
        case customer
        case exp_year
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let value = try? container.decode(Int?.self, forKey: .exp_month) {
                exp_month = value
            }
            
            if let value = try? container.decode(Int?.self, forKey: .exp_year) {
                exp_year = value
            }
            
            country = try container.decode(String?.self, forKey: .country)
            id = try container.decode(String?.self, forKey: .id)
            isDefault = try container.decode(Int?.self, forKey: .isDefault)
            brand = try container.decode(String?.self, forKey: .brand)
            last4 = try container.decode(String?.self, forKey: .last4)
            customer = try container.decode(String?.self, forKey: .customer)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
