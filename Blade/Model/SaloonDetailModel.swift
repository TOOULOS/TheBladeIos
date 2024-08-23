//
//  SaloonDetailModel.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import Foundation

struct SaloonDetailModel: Codable {
    var id: Int?
    var username: String?
    var bio: String?
    var email: String?
    var countryCode: String?
    var phone: String?
    var countryCodePhone: String?
    var rating: String?
    var isFav: Int?
    var name: String?
    var image: String?
    var salonName: String?
    var salonDescription: String?
    var salonCountryCode: String?
    var salonPhone: String?
    var latitude: String?
    var longitude: String?
    var location: String?
    var salonImages: [SaloonImageModel]?
    var stylistImages: [SaloonImageModel]?
    var salonTimings: [SaloonServiceTimigModel]?
    var salonServices: [SaloonStylistServiceModel]?
    var salonStylists: [SaloonStylistDetailModel]?
    var reviews: [SaloonReviewModel]?
    var salonLocation: String?
    var salon: SaloonSubSaloonModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case countryCode
        case phone
        case countryCodePhone
        case rating
        case isFav
        case name
        case image
        case salonName
        case salonDescription
        case salonCountryCode
        case salonPhone
        case latitude
        case longitude
        case location
        case salonImages
        case salonTimings
        case salonServices
        case salonStylists
        case reviews
        case stylistImages
        case salonLocation
        case salon
        case bio
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            username = try container.decode(String?.self, forKey: .username)
            email = try container.decode(String.self, forKey: .email)
            countryCode = try container.decode(String.self, forKey: .countryCode)
            phone = try container.decode(String.self, forKey: .phone)
            countryCodePhone = try container.decode(String.self, forKey: .countryCodePhone)
            rating = try container.decode(String.self, forKey: .rating)
            isFav = try container.decode(Int?.self, forKey: .isFav)
            name = try container.decode(String?.self, forKey: .name)
            image = try container.decode(String.self, forKey: .image)
            salonName = try container.decode(String.self, forKey: .salonName)
            if let val = try? container.decode(String.self, forKey: .salonDescription) {
                salonDescription = val
            }
            
            if let val = try? container.decode(String.self, forKey: .bio) {
                bio = val
            }
            if let val = try? container.decode(SaloonSubSaloonModel.self, forKey: .salon) {
                salon = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonCountryCode) {
                salonCountryCode = val
            }
            if let val = try? container.decode(String.self, forKey: .salonPhone) {
                salonPhone = val
            }
            
            if let val = try? container.decode(String.self, forKey: .latitude) {
                latitude = val
            }
            
            if let val = try? container.decode(String.self, forKey: .longitude) {
                longitude = val
            }
            
            if let val = try? container.decode(String.self, forKey: .location) {
                location = val
            } else if let val = try? container.decode(String.self, forKey: .salonLocation) {
                location = val
            }

            
            
            if let val = try? container.decode([SaloonImageModel].self, forKey: .salonImages) {
                salonImages = val
            } else if let val = try? container.decode([SaloonImageModel].self, forKey: .stylistImages) {
                salonImages = val
            }
            
            salonServices = try container.decode([SaloonStylistServiceModel].self, forKey: .salonServices)
            
            
            if let val = try? container.decode([SaloonServiceTimigModel].self, forKey: .salonTimings) {
                salonTimings = val
            }
            
            if let val = try? container.decode([SaloonStylistServiceModel].self, forKey: .salonServices) {
                salonServices = val
            }
            
            if let val = try? container.decode([SaloonStylistDetailModel].self, forKey: .salonStylists) {
                salonStylists = val
            }
            
            if let val = try? container.decode([SaloonReviewModel].self, forKey: .reviews) {
                reviews = val
            }
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct SaloonStylistDetailModel: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var rating: String?
    var salonName: String?
    var salonServices: [SaloonStylistServiceModel]?
    var email: String?
    var phone: String?
    var countryCode: String?
    var bio: String?
    var countryCodePhone: String?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case salonServices
        case rating
        case salonName
        case email
        case countryCode
        case phone
        case bio
        case countryCodePhone
        case status
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int?.self, forKey: .id)
            name = try container.decode(String?.self, forKey: .name)
            image = try container.decode(String.self, forKey: .image)
            if let val = try? container.decode(String.self, forKey: .rating) {
                rating = val
            }
            
            if let val = try? container.decode(String.self, forKey: .email) {
                email = val
            }

            
            if let val = try? container.decode(Int.self, forKey: .status) {
                status = val
            }

            
            if let val = try? container.decode(String.self, forKey: .bio) {
                bio = val
            }
            
            if let val = try? container.decode(String.self, forKey: .countryCodePhone) {
                countryCodePhone = val
            }
            
            if let val = try? container.decode(String.self, forKey: .countryCode) {
                countryCode = val
            }
            
            if let val = try? container.decode(String.self, forKey: .phone) {
                phone = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonName) {
                salonName = val
            }
            
            if let val = try? container.decode([SaloonStylistServiceModel].self, forKey: .salonServices) {
                salonServices = val
            }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SaloonStylistServiceModel: Codable {
    var id: Int?
    var userId: Int?
    var serviceName: String?
    var serviceType: Int?
    var price: String?
    var time: String?
    var timeValue: String?
    var serviceDescription: String?
    var status: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case serviceName
        case price
        case time
        case serviceType
        case serviceDescription
        case status
        case timeValue
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            userId = try container.decode(Int?.self, forKey: .userId)
            serviceName = try container.decode(String.self, forKey: .serviceName)
            price = try container.decode(String?.self, forKey: .price)
            time = try container.decode(String.self, forKey: .time)
            serviceDescription = try container.decode(String?.self, forKey: .serviceDescription)
            if let val = try? container.decode(Int?.self, forKey: .status) {
                status = val
            }
            
            if let val = try? container.decode(Int?.self, forKey: .timeValue) {
                timeValue = "\(val)"
            } else if let val = try? container.decode(String?.self, forKey: .timeValue) {
                timeValue = "\(val)"
            }
            
            if let val = try? container.decode(Int?.self, forKey: .serviceType) {
                serviceType = val
            }
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SaloonServiceTimigModel: Codable {
    var id: Int?
    var dayId: Int?
    var day: String?
    var startTime: String?
    var endTime: String?
    var isClosed: Int?
    var breakStartTime1: String?
    var breakEndTime1: String?
    var breakStartTime2: String?
    var breakEndTime2: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dayId
        case day
        case startTime
        case endTime
        case isClosed
        case breakStartTime1
        case breakEndTime1
        case breakStartTime2
        case breakEndTime2
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            dayId = try container.decode(Int?.self, forKey: .dayId)
            day = try container.decode(String.self, forKey: .day)
            startTime = try container.decode(String?.self, forKey: .startTime)
            endTime = try container.decode(String.self, forKey: .endTime)
            isClosed = try container.decode(Int.self, forKey: .isClosed)
            
            if let val = try? container.decode(String?.self, forKey: .breakStartTime1) {
                breakStartTime1 = val
            }
            
            if let val = try? container.decode(String?.self, forKey: .breakEndTime1) {
                breakEndTime1 = val
            }
            
            if let val = try? container.decode(String?.self, forKey: .breakStartTime2) {
                breakStartTime2 = val
            }
            
            if let val = try? container.decode(String?.self, forKey: .breakEndTime2) {
                breakEndTime2 = val
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SaloonReviewModel: Codable {
    var id: Int?
    var review: String?
    var user: SaloonReviewUserModel?
    var rating: Double?
    var created: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case review
        case user
        case rating
        case created
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            review = try container.decode(String?.self, forKey: .review)
            if let val = try? container.decode(Double?.self, forKey: .rating) {
                rating = val
            }
            created = try container.decode(Double?.self, forKey: .created)
            user = try container.decode(SaloonReviewUserModel?.self, forKey: .user)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SaloonReviewUserModel: Codable {
    var id: Int?
    var name: String?
    var image: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            name = try container.decode(String?.self, forKey: .name)
            image = try container.decode(String?.self, forKey: .image)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct SaloonSubSaloonModel: Codable {
    var id: Int?
    var salonDescription: String?
    var salonTimings: [SaloonServiceTimigModel]?
    
    
    enum CodingKeys: String, CodingKey {
        case salonDescription
        case salonTimings
        case id
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int?.self, forKey: .id)
            salonDescription = try container.decode(String?.self, forKey: .salonDescription)
            salonTimings = try container.decode([SaloonServiceTimigModel]?.self, forKey: .salonTimings)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
