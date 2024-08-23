//
//  SignupModel.swift
//  Behave
//
//  Created by cqlsys on 19/04/22.
//

import Foundation


struct SignupModel: Codable {
    var id: Int?
    var latitude: String?
    var longitude: String?
    var stripeId: String?
    var stepsCompleted: Int?
    var wallet: String?
    var role: Int?
    var location: String?
    var email: String?
    var name: String?
    var countryCode: String?
    var phone: String?
    var image: String?
    var token: String?
    var salonName: String?
    var isAutoAcceptBooking: Int?
    var salonDescription: String?
    var salonTimings: [SaloonServiceTimigModel]?
    var salonStylists: [SaloonStylistDetailModel]?
    var salonServices: [SaloonStylistServiceModel]?
    var salonId: Int?
    var salonImages: [SaloonImageModel]?
    var stylistImages: [SaloonImageModel]?
    var rating: String?
    var reviews: [SaloonReviewModel]?
    var salonLocation: String?
    var bio: String?
    var salonPhone: String?
    var salonCountryCode: String?
    var timeRemainingForFirst30Days: PageTrial?
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case stripeId
        case wallet
        case role
        case location
        case email
        case name
        case countryCode
        case phone
        case image
        case token
        case salonTimings
        case salonStylists
        case isAutoAcceptBooking
        case salonName
        case salonDescription
        case salonServices
        case salonImages
        case rating
        case stepsCompleted
        case reviews
        case salonId
        case salonLocation
        case bio
        case stylistImages
        case salonPhone
        case timeRemainingForFirst30Days
        case salonCountryCode
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            
            if let val = try? container.decode(String.self, forKey: .latitude) {
                latitude = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonCountryCode) {
                salonCountryCode = val
            }
            
            if let val = try? container.decode(PageTrial.self, forKey: .timeRemainingForFirst30Days) {
                timeRemainingForFirst30Days = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonPhone) {
                salonPhone = val
            }
            
            if let val = try? container.decode(Int.self, forKey: .stepsCompleted) {
                stepsCompleted = val
            }
            
            if let val = try? container.decode(String.self, forKey: .bio) {
                bio = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonLocation) {
                salonLocation = val
            }
            
            if let val = try? container.decode(Int.self, forKey: .salonId) {
                salonId = val
            }
            
            if let val = try? container.decode(String.self, forKey: .rating) {
                rating = val
            }

            if let val = try? container.decode([SaloonReviewModel].self, forKey: .reviews) {
                reviews = val
            }

            
            if let val = try? container.decode([SaloonImageModel].self, forKey: .salonImages) {
                salonImages = val
            }
            
            if let val = try? container.decode([SaloonImageModel].self, forKey: .stylistImages) {
                stylistImages = val
            }

            if let val = try? container.decode([SaloonStylistServiceModel].self, forKey: .salonServices) {
                salonServices = val
            }

            
            if let val = try? container.decode(String.self, forKey: .salonDescription) {
                salonDescription = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonName) {
                salonName = val
            }
            
            
            
            if let val = try? container.decode(Int.self, forKey: .isAutoAcceptBooking) {
                isAutoAcceptBooking = val
            }
            
            if let val = try? container.decode([SaloonStylistDetailModel].self, forKey: .salonStylists) {
                salonStylists = val
            }
            
           
            
            if let val = try? container.decode([SaloonServiceTimigModel].self, forKey: .salonTimings) {
                salonTimings = val
            }
            
            if let val = try? container.decode(String.self, forKey: .longitude) {
                longitude = val
            }
            
            if let val = try? container.decode(String.self, forKey: .stripeId) {
                stripeId = val
            }
            
            if let val = try? container.decode(String.self, forKey: .wallet) {
                wallet = val
            }
            role = try container.decode(Int.self, forKey: .role)
            
            if let val = try? container.decode(String.self, forKey: .location) {
                location = val
            }
            
            email = try container.decode(String.self, forKey: .email)
            name = try container.decode(String.self, forKey: .name)
            countryCode = try container.decode(String.self, forKey: .countryCode)
            phone = try container.decode(String.self, forKey: .phone)
            image = try container.decode(String.self, forKey: .image)
            if let val = try? container.decode(String.self, forKey: .token) {
                token = val
            } else {
                token = UserPreference.shared.data?.token ?? ""
            }
            
            
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct PageModel: Codable {
    var id: Int?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            content = try container.decode(String.self, forKey: .content)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct PageTrial: Codable {
    var hours: Int?
    var minutes: Int?
    var days: Int?
    var seconds: Int?
    
    enum CodingKeys: String, CodingKey {
        case hours
        case minutes
        case days
        case seconds
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hours = try container.decodeIfPresent(Int.self, forKey: .hours)
        self.minutes = try container.decodeIfPresent(Int.self, forKey: .minutes)
        self.days = try container.decodeIfPresent(Int.self, forKey: .days)
        self.seconds = try container.decodeIfPresent(Int.self, forKey: .seconds)
    }
}




