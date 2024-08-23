//
//  SlotModel.swift
//  Blade
//
//  Created by cqlsys on 13/11/22.
//

import Foundation

struct SlotModel: Codable {
    var timeIntervals: [SlotTimeIntervalModel]?
    
    
    enum CodingKeys: String, CodingKey {
        case timeIntervals
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            timeIntervals = try container.decode([SlotTimeIntervalModel]?.self, forKey: .timeIntervals)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SlotTimeIntervalModel: Codable {
    var slotTime: String?
    var isAvailable: Int?
    var isManual: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case slotTime
        case isAvailable
        case isManual
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            slotTime = try container.decode(String?.self, forKey: .slotTime)
            isAvailable = try container.decode(Int?.self, forKey: .isAvailable)
            isManual = try container.decode(Int?.self, forKey: .isManual)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct SearchModel: Codable {
    var id: Int?
    var name: String?
    var role: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case role
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int?.self, forKey: .id)
            name = try container.decode(String?.self, forKey: .name)
            role = try container.decode(Int?.self, forKey: .role)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
