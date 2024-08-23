//
//  CustomerHomeModel.swift
//  Blade
//
//  Created by keshav on 09/10/22.
//

import Foundation

struct CustomerHomeModel: Codable {
    var topRatedBarbers: [CustomerHomeTopRatedModel]?
    var nearBySalons: [CustomerHomeNearByModel]?
    
    enum CodingKeys: String, CodingKey {
        case topRatedBarbers
        case nearBySalons
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            topRatedBarbers = try container.decode([CustomerHomeTopRatedModel].self, forKey: .topRatedBarbers)
            nearBySalons = try container.decode([CustomerHomeNearByModel].self, forKey: .nearBySalons)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct CustomerHomeTopRatedModel: Codable {
    var salonName: String?
    var salonDistance: Double?
    var id: Int?
    var salonLongitude: String?
    var salonLocation: String?
    var email: String?
    var image: String?
    var name: String?
    var countryCode: String?
    var salonLatitude: String?
    var salonId: Int?
    var phone: String?
    var rating: String?
    var isFav: Int?
    
    enum CodingKeys: String, CodingKey {
        case salonName
        case salonDistance
        case id
        case salonLongitude
        case salonLocation
        case email
        case image
        case name
        case countryCode
        case salonLatitude
        case salonId
        case phone
        case rating
        case isFav
        
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            salonName = try container.decode(String?.self, forKey: .salonName)
            if let val = try? container.decode(Double.self, forKey: .salonDistance) {
                salonDistance = val
            } else if let val = try? container.decode(String.self, forKey: .salonDistance) {
                salonDistance = Double(val)
            }
            
            id = try container.decode(Int.self, forKey: .id)
            salonLongitude = try container.decode(String.self, forKey: .salonLongitude)
            salonLocation = try container.decode(String.self, forKey: .salonLocation)
            email = try container.decode(String.self, forKey: .email)
            image = try container.decode(String.self, forKey: .image)
            name = try container.decode(String.self, forKey: .name)
            countryCode = try container.decode(String.self, forKey: .countryCode)
            salonLatitude = try container.decode(String.self, forKey: .salonLatitude)
            salonId = try container.decode(Int.self, forKey: .salonId)
            phone = try container.decode(String.self, forKey: .phone)
            rating = try container.decode(String.self, forKey: .rating)
            isFav = try container.decode(Int.self, forKey: .isFav)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct CustomerHomeNearByModel: Codable {
    var salonName: String?
    var latitude: String?
    var salonImages: [SaloonImageModel]?
    var id: Int?
    var location: String?
    var salonDescription: String?
    var name: String?
    var isFav: Int?
    var phone: String?
    var countryCodePhone: String?
    var rating: String?
    var image: String?
    
    
    enum CodingKeys: String, CodingKey {
        case salonName
        case latitude
        case salonImages
        case id
        case location
        case salonDescription
        case name
        case isFav
        case phone
        case countryCodePhone
        case rating
        case image
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            salonName = try container.decode(String?.self, forKey: .salonName)
            image = try container.decode(String?.self, forKey: .image)
            if let val = try? container.decode(String.self, forKey: .latitude) {
                latitude = val
            }
            
            if let val = try? container.decode([SaloonImageModel].self, forKey: .salonImages) {
                salonImages = val
            }
            id = try container.decode(Int.self, forKey: .id)
            if let val = try? container.decode(String.self, forKey: .location) {
                location = val
            }
            
            if let val = try? container.decode(String.self, forKey: .salonDescription) {
                salonDescription = val
            }
           
            name = try container.decode(String.self, forKey: .name)
            isFav = try container.decode(Int.self, forKey: .isFav)
            phone = try container.decode(String.self, forKey: .phone)
            countryCodePhone = try container.decode(String.self, forKey: .countryCodePhone)
            rating = try container.decode(String.self, forKey: .rating)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct SaloonImageModel: Codable {
    var image: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case image
        case id
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            image = try container.decode(String?.self, forKey: .image)
            if let val = try? container.decode(Int?.self, forKey: .id) {
                id = val
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
