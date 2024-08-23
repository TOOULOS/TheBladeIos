//
//  BookingModel.swift
//  Blade
//
//  Created by cqlsys on 19/10/22.
//

import Foundation

struct BookingModel: Codable {
    var salonId: Int?
    var status: Int?
    var salonStylistImage: String?
    var isRatedSalonStylist: Int?
    var salonName: String?
    var salonUserName: String?
    var amountToBePaid: String?
    var discount: String?
    var salonStylistName: String?
    var cancelledBy: Int?
    var isRescheduleRequest: Int?
    var id: Int?
    var isRatedSalon: Int?
    var paymentMethod: Int?
    var salonImage: String?
    var totalAmount: String?
    var salonStylistId: Int?
    var bookingTime: String?
    var bookingEndTime: String?
    var userId: Int?
    var bookingDate: String?
    var bookingJson: BookingJsonModel?
    var user: SaloonStylistDetailModel?
    var isRatedUser: Int?
   
    
    
    enum CodingKeys: String, CodingKey {
        case salonId
        case status
        case salonStylistImage
        case isRatedSalonStylist
        case salonName
        case amountToBePaid
        case discount
        case salonStylistName
        case cancelledBy
        case isRescheduleRequest
        case id
        case isRatedSalon
        case paymentMethod
        case salonImage
        case totalAmount
        case salonStylistId
        case bookingTime
        case bookingEndTime
        case userId
        case bookingDate
        case bookingJson
        case user
        case isRatedUser
        case salonUserName
       
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            bookingJson = try container.decode(BookingJsonModel?.self, forKey: .bookingJson)
            salonId = try container.decode(Int?.self, forKey: .salonId)
            status = try container.decode(Int?.self, forKey: .status)
            bookingDate = try container.decode(String.self, forKey: .bookingDate)
            salonStylistImage = try container.decode(String.self, forKey: .salonStylistImage)
            if let val = try? container.decode(String.self, forKey: .salonUserName) {
                salonUserName = val
            }
            
            if let val = try? container.decode(Int.self, forKey: .isRatedSalonStylist) {
                isRatedSalonStylist = val
            }
            

            if let val = try? container.decode(Int.self, forKey: .isRatedUser) {
                isRatedUser = val
            }
            
            salonName = try container.decode(String.self, forKey: .salonName)
            amountToBePaid = try container.decode(String.self, forKey: .amountToBePaid)
            discount = try container.decode(String.self, forKey: .discount)
            salonStylistName = try container.decode(String?.self, forKey: .salonStylistName)
            cancelledBy = try container.decode(Int?.self, forKey: .cancelledBy)
            isRescheduleRequest = try container.decode(Int.self, forKey: .isRescheduleRequest)
            id = try container.decode(Int.self, forKey: .id)
            if let val = try? container.decode(Int.self, forKey: .isRatedSalon) {
                isRatedSalon = val
            }
            
            if let val = try? container.decode(SaloonStylistDetailModel.self, forKey: .user) {
                user = val
            }
            
            paymentMethod = try container.decode(Int.self, forKey: .paymentMethod)
            salonImage = try container.decode(String.self, forKey: .salonImage)
            
            totalAmount = try container.decode(String?.self, forKey: .totalAmount)
            salonStylistId = try container.decode(Int?.self, forKey: .salonStylistId)
            bookingTime = try container.decode(String.self, forKey: .bookingTime)
            bookingEndTime = try container.decode(String.self, forKey: .bookingEndTime)
            userId = try container.decode(Int.self, forKey: .userId)
            cancelledBy = try container.decode(Int.self, forKey: .cancelledBy)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct BookingJsonModel: Codable {
    var salonServices: [BookingServiceModel]?
    
    enum CodingKeys: String, CodingKey {
        case salonServices
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            salonServices = try container.decode([BookingServiceModel]?.self, forKey: .salonServices)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct BookingServiceModel: Codable {
    var serviceName: String?
    var id: Int?
    var timeValue: Int?
    enum CodingKeys: String, CodingKey {
        case serviceName
        case id
        case timeValue
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            serviceName = try container.decode(String?.self, forKey: .serviceName)
            id = try container.decode(Int?.self, forKey: .id)
            timeValue = try container.decode(Int?.self, forKey: .timeValue)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
