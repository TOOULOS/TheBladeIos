//
//  DashboardModek.swift
//  Blade
//
//  Created by cqlsys on 07/11/22.
//

import Foundation


struct DashboardBodyModel: Codable {
    var chartData: [DashboardModel]?
    var stylistsTotalEarning: Double?
    var salonTotalEarning: Double?
    
    
    
    enum CodingKeys: String, CodingKey {
        case chartData
        case stylistsTotalEarning
        case salonTotalEarning
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let val = try? container.decode(Double?.self, forKey: .stylistsTotalEarning) {
                stylistsTotalEarning = val
            }
            if let val = try? container.decode(Double?.self, forKey: .salonTotalEarning) {
                salonTotalEarning = val
            }
            chartData = try container.decode([DashboardModel]?.self, forKey: .chartData)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct DashboardModel: Codable {
    var date: String?
    var earning: Double?
    var day: String?
    
    
    enum CodingKeys: String, CodingKey {
        case date
        case earning
        case day
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let val = try? container.decode(String?.self, forKey: .date) {
                date = val
            } else if let val = try? container.decode(String?.self, forKey: .day) {
                date = val
            }
            earning = try container.decode(Double?.self, forKey: .earning)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
