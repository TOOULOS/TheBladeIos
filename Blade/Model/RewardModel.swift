//
//  RewardModel.swift
//  Blade
//
//  Created by cqlsys on 22/12/22.
//

import Foundation

struct RewardModel: Codable {
    var rewardsDescription: String?
    var rewardsPerBooking: String?
    var rewardsToEuroConversionRate: String?
    var rewardPoints: Int?
    var wallet: String?
    
    
    
    enum CodingKeys: String, CodingKey {
        case rewardsDescription
        case rewardsPerBooking
        case rewardsToEuroConversionRate
        case rewardPoints
        case wallet
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            rewardsDescription = try container.decode(String?.self, forKey: .rewardsDescription)
            wallet = try container.decode(String?.self, forKey: .wallet)
            rewardsPerBooking = try container.decode(String?.self, forKey: .rewardsPerBooking)
            rewardsToEuroConversionRate = try container.decode(String?.self, forKey: .rewardsToEuroConversionRate)
            rewardPoints = try container.decode(Int?.self, forKey: .rewardPoints)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
