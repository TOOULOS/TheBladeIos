//
//  NotificationModel.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import Foundation

struct NotificationModel: Codable {
    var text: String?
    var created: String?
    var sentBy: NotificationSendByModel?
    var type: Int?
    var notificationData: NotificationDataModel?
    enum CodingKeys: String, CodingKey {
        case text
        case created
        case sentBy
        case type
        case notificationData
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            text = try container.decode(String?.self, forKey: .text)
            created = try container.decode(String?.self, forKey: .created)
            sentBy = try container.decode(NotificationSendByModel?.self, forKey: .sentBy)
            notificationData = try container.decode(NotificationDataModel?.self, forKey: .notificationData)
            type = try container.decode(Int?.self, forKey: .type)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct NotificationSendByModel: Codable {
    var id: Int?
    var name: String?
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
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

struct NotificationDataModel: Codable {
    var booking: NotificationDataBookModel?
    
    
    enum CodingKeys: String, CodingKey {
        case booking
       
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            booking = try container.decode(NotificationDataBookModel?.self, forKey: .booking)
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct NotificationDataBookModel: Codable {
    var salonImage: String?
    
    
    enum CodingKeys: String, CodingKey {
        case salonImage
       
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            salonImage = try container.decode(String?.self, forKey: .salonImage)
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct ReviewModel: Codable {
    var id: Int?
    var review: String?
    var rating: Double?
    var toUser: NotificationSendByModel?
    var created: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case review
        case toUser
        case rating
        case created
    }
    
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            review = try container.decode(String?.self, forKey: .review)
            rating = try container.decode(Double?.self, forKey: .rating)
            toUser = try container.decode(NotificationSendByModel?.self, forKey: .toUser)
            if let val = try? container.decode(String?.self, forKey: .created) {
                created = Double(val) ?? 0
            } else {
                created = try container.decode(Double?.self, forKey: .created)
            }
             
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct WalletAmount: Codable {
    var id: Int?
    var wallet: String?
    var balancePendingOnStripeEnd: String?
    var balanceAvailableToWithdraw: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case wallet
        case balancePendingOnStripeEnd
        case balanceAvailableToWithdraw
    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(Int?.self, forKey: .id)
            wallet = try container.decode(String?.self, forKey: .wallet)
            if let value = try? container.decode(String?.self, forKey: .balancePendingOnStripeEnd) {
                balancePendingOnStripeEnd = value
            } else if let value = try? container.decode(Double?.self, forKey: .balancePendingOnStripeEnd) {
                balancePendingOnStripeEnd = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .balanceAvailableToWithdraw) {
                balanceAvailableToWithdraw = value
            } else if let value = try? container.decode(Double?.self, forKey: .balanceAvailableToWithdraw) {
                balanceAvailableToWithdraw = "\(value)"
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct TransactionBodyModel: Codable {
    var id: Int?
    var amount: String?
    var reporting_category: String?
    var type: String?
    var available_on: String?
    var created: String?
    var status: String?
    var net: String?
    var calculatedBalance: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case reporting_category
        case type
        case available_on
        case created
        case status
        case net
        case calculatedBalance
    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
        //    id = try container.decode(Int?.self, forKey: .id)
            
            if let value = try? container.decode(String?.self, forKey: .amount) {
                amount = value
            } else if let value = try? container.decode(Double?.self, forKey: .amount) {
                amount = "\(value)"
            }

            if let value = try? container.decode(String?.self, forKey: .calculatedBalance) {
                calculatedBalance = value
            } else if let value = try? container.decode(Double?.self, forKey: .calculatedBalance) {
                calculatedBalance = "\(value)"
            }

            
            if let value = try? container.decode(String?.self, forKey: .net) {
                net = value
            } else if let value = try? container.decode(Double?.self, forKey: .net) {
                net = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .reporting_category) {
                reporting_category = value
            } else if let value = try? container.decode(Double?.self, forKey: .reporting_category) {
                reporting_category = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .type) {
                type = value
            } else if let value = try? container.decode(Double?.self, forKey: .type) {
                type = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .available_on) {
                available_on = value
            } else if let value = try? container.decode(Double?.self, forKey: .available_on) {
                available_on = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .created) {
                created = value
            } else if let value = try? container.decode(Double?.self, forKey: .created) {
                created = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .status) {
                status = value
            } else if let value = try? container.decode(Double?.self, forKey: .status) {
                status = "\(value)"
            }
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct TransactionModel: Codable {
    
    var stripeBalanceTransactions: [TransactionBodyModel]?
    var balancePendingOnStripeEnd: String?
    var balanceAvailableToWithdraw: String?
    
    enum CodingKeys: String, CodingKey {
        case stripeBalanceTransactions
        case balancePendingOnStripeEnd
        case balanceAvailableToWithdraw
    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            stripeBalanceTransactions = try container.decode([TransactionBodyModel]?.self, forKey: .stripeBalanceTransactions)
            
            if let value = try? container.decode(String?.self, forKey: .balancePendingOnStripeEnd) {
                balancePendingOnStripeEnd = value
            } else if let value = try? container.decode(Double?.self, forKey: .balancePendingOnStripeEnd) {
                balancePendingOnStripeEnd = "\(value)"
            }
            
            if let value = try? container.decode(String?.self, forKey: .balanceAvailableToWithdraw) {
                balanceAvailableToWithdraw = value
            } else if let value = try? container.decode(Double?.self, forKey: .balanceAvailableToWithdraw) {
                balanceAvailableToWithdraw = "\(value)"
            }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}



struct TransfersBodyModel: Codable {
    var id: Int?
    var amount: String?
    var created: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case created
        
    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
        //    id = try container.decode(Int?.self, forKey: .id)
            
            if let value = try? container.decode(String?.self, forKey: .amount) {
                amount = value
            } else if let value = try? container.decode(Double?.self, forKey: .amount) {
                amount = "\(value)"
            }

           

            
           
            
            
            
            if let value = try? container.decode(String?.self, forKey: .created) {
                created = value
            } else if let value = try? container.decode(Double?.self, forKey: .created) {
                created = "\(value)"
            }
            
           
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


struct TransfersModel: Codable {
    
    var stripeBalanceTransfers: [TransfersBodyModel]?
   
    
    enum CodingKeys: String, CodingKey {
        case stripeBalanceTransfers
    }
    
    //MARK: - Decode
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            stripeBalanceTransfers = try container.decode([TransfersBodyModel]?.self, forKey: .stripeBalanceTransfers)
            
            
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
