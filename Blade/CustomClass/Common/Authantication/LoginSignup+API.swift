//
//  LoginSignup+API.swift
//  InsureTika
//
//  Created by keshav kumar on 31/01/20.
//  Copyright © 2020 keshav kumar. All rights reserved.
//

import Foundation
import Moya

enum SignupEP {
    case login(email: String, password: String)
    case forgotPassword(email: String)
    case signup(role: String, name: String, email: String, password: String, countryCode: String, phone: String, latitude: String, longitude: String, location: String, image: Data)
    case aboutUs
    case termsAndConditions
    case privacyPolicy
    case changePassword(oldPassword: String, newPassword: String)
    case editProfile(name: String, countryCode: String, phone: String, latitude: String, longitude: String, location: String, image: Data, salonCountryCode: String, salonPhone: String, salonName: String, salonDescription: String)
    case deleteAccount
    case logout
    
    case userHomeScreen(latitude: String, longitude: String)
    case addOrRemoveFavouriteSalonOrStylist(salonOrStylistId: String, isFav: String)
    case nearbySalons(latitude: String, longitude: String)
    case nearbyStylists(latitude: String, longitude: String)
    case favouriteSalonOrStylistListing(type: String)
    case getSalonDetail(salonId: String)
    case getSalonStylistDetail(stylistId: String)
    case bookingListing(type: String, page: String, limit: String)
    case notificationListing
    case givenReviewsListing
    case bookingListingSalonSide(type: String, page: String, limit: String)
    case updateBookingStatus(id: String, status: String)
    case addReview(bookingId: String, toUserId: String, rating: String, review: String)
    case updateSalonTimings(id: String, startTime: String, endTime: String, isClosed: Int, breakStartTime1: String, breakEndTime1: String, breakStartTime2: String, breakEndTime2: String)
    case walletDetail
    case withdrawAmountFromWallet(amount: String)
    case editSalonStylist(id: String, name: String, email: String, countryCode: String, phone: String, bio: String, salonServiceIds: String,status: String, deleteSalonServiceIds: String, image: Data)
    case getChartDataSalonSide(type: String, whoseData: String, stylistId: String, year: String)
    case calendarBasedBookingListingSalonSide(bookingDate: String)
    case manualBooking(bookingDate: String, bookingTime: String, bookingEndTime: String)
    case salonSlotsDayWise(salonId: String, salonStylistId: String, date: String)
    case unblockManualBooking(bookingDate: String, bookingTime: String, bookingEndTime: String)
    case upDateAutoAccept(isAutoAcceptBooking: String)
    case addSalonImage(salonImages: Data)
    case deleteSalonImages(salonImageIds: String)
    case editSalonService(id: String, serviceType: String, serviceName: String, serviceDescription: String, price: String, time: String, timeValue: String, status: String)
    case addSalonService(serviceType: String, serviceName: String, serviceDescription: String, price: String, time: String, timeValue: String)
    case addSalonStylist(name: String, email: String, countryCode: String, phone: String, salonServiceIds: String, bio: String, image: Data?)
    case getChartDataStylistSide(type: String, year: String)
    case deleteStylistImages(stylistImageIds: String)
    case editStylistProfile(name: String, countryCode: String, phone: String, bio: String, image: Data?)
    case getStripeCards
    case deleteStripeCard(id: String)
    case getProfile
    case addBooking(salonId: String, salonStylistId: String, salonServiceIds: String, bookingDate: String, bookingTime: String, amountToBePaid: String, discount: String, totalAmount: String, paymentMethod: String, stripeAndPaymentAmountFromWallet: String, usePreviouslyAddedCard: String, previouslyAddedCardId: String, cardNumber: String, cardExpMonth: String, cardExpYear: String, cardCvc: String, isSaveCard: String, setDefaultPaymentMethod: String)
    case salonSignupStep2AddSalonDetails(salonName: String, salonDescription: String, salonCountryCode: String, salonPhone: String, salonImages: [Data])
    case salonSignupStep3AddSalonTimings(salonTimings: [[String: String]])
    case salonSignupStep4AddSalonServices(salonServices: [[String: String]])
    case rewardsData
    case changeLanguage(languageType: String)
    case convertRewardPointsToMoneyIntoWallet(rewardPoints: String)
    case cancelBookingUserSide(id: String)
    case searchNearbySalonsAndStylists(latitude: String, longitude: String, keyword: String)
    case rescheduleBooking(id: String, bookingDate: String, bookingTime: String)
    
    case updateIsIosSubscriptionActive(isIosSubscriptionActive: String)
    case stripeBalanceTransactionsListing(limit: String, page: String)
    case walletTransactions(limit: String, page: String)
    
    case stripeBalanceTransfersListing(limit: String, page: String)
    case notificationListingPagination(page: String, limit: String)
    case addManualBooking(manualCustomerName: String, manualCustomerCountryCodePhone: String, salonServiceIds: String, bookingDate: String, bookingTime: String, amountToBePaid: String, discount: String, totalAmount: String)
    case rescheduleBookingSalonSide(id: String, bookingDate: String, bookingTime: String)
}

extension SignupEP: TargetType {
    var method: Moya.Method {
        switch self {
        case .forgotPassword, .changePassword, .editProfile, .logout , .updateSalonTimings, .editSalonStylist, .upDateAutoAccept, .addSalonImage, .editSalonService, .editStylistProfile, .salonSignupStep2AddSalonDetails, .salonSignupStep3AddSalonTimings, .salonSignupStep4AddSalonServices, .changeLanguage, .convertRewardPointsToMoneyIntoWallet, .cancelBookingUserSide, .updateIsIosSubscriptionActive:
            return .put
        case .aboutUs, .termsAndConditions, .privacyPolicy, .notificationListing, .givenReviewsListing, .walletDetail, .getStripeCards, .getProfile, .rewardsData:
            return .get
        case .deleteAccount, .unblockManualBooking, .deleteSalonImages, .deleteStylistImages, .deleteStripeCard:
            return .delete
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data("No Data found".utf8)
    }
    
    var task: Task {
        switch self {
        case .signup , .editProfile , .editSalonStylist, .addSalonImage, .addSalonStylist, .editStylistProfile, .salonSignupStep2AddSalonDetails:
            return .uploadMultipart(multipartBody ?? [])
        case .aboutUs, .termsAndConditions, .privacyPolicy, .notificationListing, .givenReviewsListing, .walletDetail, .getStripeCards, .getProfile, .rewardsData:
            return .requestParameters(parameters: self.parameters, encoding: URLEncoding.default)
     
        default:
            return .requestParameters(parameters: self.parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .forgotPassword, .signup, .aboutUs, .termsAndConditions, .privacyPolicy:
            return ["securitykey": "__blade_007"]
        default:
            return ["securitykey": "__blade_007",
                    "Authorization" : "Bearer \(UserPreference.shared.data?.token ?? "")"]
        }
    }
    
    var baseURL : URL{
        return URL(string: ApiConstants.baseURL)!
    }
    ////email, phone_number, country_code
    var path: String{
        switch self {
        case .login(_): return ApiConstants.login
        case .forgotPassword: return ApiConstants.forgotPassword
        case .signup: return ApiConstants.signup
        case .privacyPolicy: return ApiConstants.privacyPolicy
        case .termsAndConditions: return ApiConstants.termsAndConditions
        case .aboutUs: return ApiConstants.aboutUs
        case .changePassword: return ApiConstants.changePassword
        case .editProfile: return ApiConstants.editProfile
        case .deleteAccount: return ApiConstants.deleteAccount
        case .logout: return ApiConstants.logout
        case .userHomeScreen: return ApiConstants.userHomeScreen
        case .addOrRemoveFavouriteSalonOrStylist: return ApiConstants.addOrRemoveFavouriteSalonOrStylist
        case .nearbySalons: return ApiConstants.nearbySalons
        case .nearbyStylists: return ApiConstants.nearbyStylists
        case .favouriteSalonOrStylistListing: return ApiConstants.favouriteSalonOrStylistListing
        case .getSalonDetail: return ApiConstants.getSalonDetail
        case .bookingListing: return ApiConstants.bookingListing
        case .notificationListing: return ApiConstants.notificationListing
        case .givenReviewsListing: return ApiConstants.givenReviewsListing
        case .bookingListingSalonSide: return ApiConstants.bookingListingSalonSide
        case .updateBookingStatus: return ApiConstants.updateBookingStatus
        case .addReview: return ApiConstants.addReview
        case .updateSalonTimings: return ApiConstants.updateSalonTimings
        case .walletDetail: return ApiConstants.walletDetail
        case .withdrawAmountFromWallet: return ApiConstants.withdrawAmountFromWallet
        case .editSalonStylist: return ApiConstants.editSalonStylist
        case .getChartDataSalonSide: return ApiConstants.getChartDataSalonSide
        case .calendarBasedBookingListingSalonSide: return ApiConstants.calendarBasedBookingListingSalonSide
        case .manualBooking: return ApiConstants.manualBooking
        case .salonSlotsDayWise: return ApiConstants.salonSlotsDayWise
        case .unblockManualBooking: return ApiConstants.unblockManualBooking
        case .upDateAutoAccept: return ApiConstants.upDateAutoAccept
        case .addSalonImage: return ApiConstants.addSalonImage
        case .deleteSalonImages: return ApiConstants.deleteSalonImages
        case .editSalonService: return ApiConstants.editSalonService
        case .addSalonService: return ApiConstants.addSalonService
        case .addSalonStylist: return ApiConstants.addSalonStylist
        case .getChartDataStylistSide: return ApiConstants.getChartDataStylistSide
        case .deleteStylistImages: return ApiConstants.deleteStylistImages
        case .editStylistProfile: return ApiConstants.editStylistProfile
        case .getSalonStylistDetail: return ApiConstants.getSalonStylistDetail
        case .getStripeCards: return ApiConstants.getStripeCards
        case .deleteStripeCard: return ApiConstants.deleteStripeCard
        case .getProfile: return ApiConstants.getProfile
        case .addBooking: return ApiConstants.addBooking
        case .salonSignupStep2AddSalonDetails: return ApiConstants.salonSignupStep2AddSalonDetails
        case .salonSignupStep3AddSalonTimings: return ApiConstants.salonSignupStep3AddSalonTimings
        case .salonSignupStep4AddSalonServices: return ApiConstants.salonSignupStep4AddSalonServices
        case .rewardsData: return ApiConstants.rewardsData
        case .changeLanguage: return ApiConstants.changeLanguage
        case .convertRewardPointsToMoneyIntoWallet: return ApiConstants.convertRewardPointsToMoneyIntoWallet
        case .cancelBookingUserSide: return ApiConstants.cancelBookingUserSide
        case .searchNearbySalonsAndStylists: return ApiConstants.searchNearbySalonsAndStylists
        case .rescheduleBooking: return ApiConstants.rescheduleBooking
        case .updateIsIosSubscriptionActive: return ApiConstants.updateIsIosSubscriptionActive
        case .stripeBalanceTransactionsListing: return ApiConstants.stripeBalanceTransactionsListing
        case .walletTransactions: return ApiConstants.walletTransactions
        case .stripeBalanceTransfersListing: return ApiConstants.stripeBalanceTransfersListing
        case .notificationListingPagination: return ApiConstants.notificationListingPagination
        case .addManualBooking: return ApiConstants.addManualBooking
        case .rescheduleBookingSalonSide: return ApiConstants.rescheduleBookingSalonSide
            
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .login(let email, let password):
            let lng = UserDefaults.standard.value(forKey: "CurrentLang") as? String ?? ""
            let fcmToken = UserDefaults.standard.value(forKey: "Firebase_Token") as? String ?? ""
            return ["email":email, "password":password, "deviceToken": fcmToken, "deviceType": "1", "languageType": lng]
        case .forgotPassword(let email):
            return ["email": email]
        case .stripeBalanceTransactionsListing(let limit, let page):
            return ["limit": limit, "page": page]
        case .walletTransactions(let limit, let page):
            return ["limit": limit, "page": page]
        case .signup(let role, let name, let email, let password, let countryCode, let phone, let latitude, let longitude, let location, _):
            let lng = UserDefaults.standard.value(forKey: "CurrentLang") as? String ?? ""
            return ["role": role, "name": name, "email": email, "password": password, "countryCode": countryCode, "phone": phone, "latitude": latitude, "longitude": longitude, "location": location, "languageType": lng]
        case .aboutUs, .termsAndConditions, .privacyPolicy, .deleteAccount, .logout, .notificationListing, .givenReviewsListing, .walletDetail, .rewardsData:
            return [:]
        case .changePassword(let oldPassword, let newPassword):
            return ["oldPassword": oldPassword, "newPassword": newPassword]
        case .editProfile( let name, let countryCode, let phone, let latitude, let longitude, let location,  _, let salonCountryCode, let salonPhone, let salonName, let salonDescription):
            let fcmToken = UserDefaults.standard.value(forKey: "Firebase_Token") as? String ?? ""
            return ["name":name, "countryCode":countryCode, "phone": phone, "deviceToken": fcmToken, "deviceType": "1", "latitude": latitude, "longitude": longitude, "location": location, "salonCountryCode": salonCountryCode, "salonPhone": salonPhone, "salonName": salonName, "salonDescription": salonDescription]
        case .userHomeScreen(let latitude, let longitude):
            return ["latitude": latitude, "longitude": longitude]
        case .addOrRemoveFavouriteSalonOrStylist(let salonOrStylistId, let isFav):
            return ["salonOrStylistId": salonOrStylistId, "isFav": isFav]
        case .nearbySalons(let latitude, let longitude):
            return ["latitude": latitude, "longitude": longitude]
        case .nearbyStylists(let latitude, let longitude):
            return ["latitude": latitude, "longitude": longitude]
        case .favouriteSalonOrStylistListing(let type):
            return ["type": type]
        case .getSalonDetail(let salonId):
            return ["salonId": salonId]
        case .bookingListing(let type, let page, let limit):
            return ["type": type, "page": page, "limit": limit]
        case .bookingListingSalonSide(let type, let page, let limit):
            return ["type": type, "page": page, "limit": limit]
        case .updateBookingStatus(let id, let status):
            return ["id": id, "status": status]
            
        case .addReview(let bookingId, let toUserId, let rating, let review):
            return ["bookingId": bookingId, "toUserId": toUserId, "rating": rating, "review": review]
        case .updateSalonTimings(let id, let startTime, let endTime, let isClosed, let breakStartTime1, let breakEndTime1, let breakStartTime2, let breakEndTime2):
            if isClosed == 2 {
                return ["id": id, "isClosed": 0, "breakStartTime2": breakStartTime2, "breakEndTime2": breakEndTime2]
            }
            if isClosed == 0 && startTime == "" {
                return ["id": id, "isClosed": isClosed, "breakStartTime1": breakStartTime1, "breakEndTime1": breakEndTime1, "breakStartTime2": breakStartTime2, "breakEndTime2": breakEndTime2]
            } else {
                return ["id": id, "startTime": startTime, "endTime": endTime, "isClosed": isClosed, "breakStartTime1": breakStartTime1, "breakEndTime1": breakEndTime1, "breakStartTime2": breakStartTime2, "breakEndTime2": breakEndTime2]
            }
            
        case .withdrawAmountFromWallet(let amount):
            return ["amount": amount]
        case .editSalonStylist(let id, let name, let email, let countryCode, let phone, let bio, let salonServiceIds, let  status, let deleteSalonServiceIds, _):
            return ["id": id, "name": name, "email": email, "countryCode": countryCode, "phone": phone, "bio": bio, "salonServiceIds": salonServiceIds, "status": status, "deleteSalonServiceIds": deleteSalonServiceIds]
        case .getChartDataSalonSide(let type, let whoseData, let stylistId, let year):
            return ["type": type, "whoseData": whoseData, "stylistId": stylistId, "year": year]
        case .calendarBasedBookingListingSalonSide(let bookingDate):
            return ["bookingDate": bookingDate]
        case .manualBooking(let bookingDate, let bookingTime, let bookingEndTime):
            return ["bookingDate": bookingDate, "bookingTime": bookingTime, "bookingEndTime": bookingEndTime]
        case .salonSlotsDayWise(let salonId, let salonStylistId, let date):
            return ["salonId": salonId, "salonStylistId": salonStylistId, "date": date, "time": "00:00 am"]
        case .unblockManualBooking(let bookingDate, let bookingTime, let bookingEndTime):
            return ["bookingDate": bookingDate, "bookingTime": bookingTime, "bookingEndTime": bookingEndTime]
        case .upDateAutoAccept(let isAutoAcceptBooking):
            return ["isAutoAcceptBooking": isAutoAcceptBooking]
        case .addSalonImage( _), .getStripeCards, .getProfile:
            return [:]
        case .deleteSalonImages(let salonImageIds):
            return ["salonImageIds": salonImageIds]
        case .editSalonService(let id, let serviceType, let serviceName, let serviceDescription, let price, let time, let timeValue, let status):
            return ["id": id, "serviceType": serviceType, "serviceName": serviceName, "serviceDescription": serviceDescription, "price": price, "time": time, "timeValue": timeValue, "status": status]
        case .addSalonService(let serviceType, let serviceName, let serviceDescription, let price, let time, let timeValue):
            return ["serviceType": serviceType, "serviceName": serviceName, "serviceDescription": serviceDescription, "price": price, "time": time, "timeValue": timeValue]
        case .addSalonStylist(let name, let email, let countryCode, let phone, let salonServiceIds, let bio, _):
            return ["name": name, "email": email, "countryCode": countryCode, "phone": phone, "salonServiceIds": salonServiceIds, "bio": bio]
        case .getChartDataStylistSide(let type, let year):
            return ["type": type, "year": year]
        case .deleteStylistImages(let stylistImageIds):
            return ["stylistImageIds": stylistImageIds]
        case .editStylistProfile(let name, let countryCode, let phone, let bio, _):
            return ["name": name, "countryCode": countryCode, "phone": phone, "bio": bio]
        case .getSalonStylistDetail(let stylistId):
            return ["stylistId": stylistId]
        case .deleteStripeCard(let id):
            return ["id": id]
        case .addBooking(let salonId, let salonStylistId, let salonServiceIds, let bookingDate, let bookingTime, let amountToBePaid, let discount, let totalAmount, let paymentMethod, let stripeAndPaymentAmountFromWallet, let usePreviouslyAddedCard, let previouslyAddedCardId, let cardNumber, let cardExpMonth, let cardExpYear, let cardCvc, let isSaveCard, let setDefaultPaymentMethod):
            return ["salonId": salonId, "salonStylistId": salonStylistId, "salonServiceIds": salonServiceIds, "bookingDate": bookingDate, "bookingTime": bookingTime, "amountToBePaid": amountToBePaid, "discount": discount, "totalAmount": totalAmount, "paymentMethod": paymentMethod, "stripeAndPaymentAmountFromWallet": stripeAndPaymentAmountFromWallet, "usePreviouslyAddedCard": usePreviouslyAddedCard, "previouslyAddedCardId": previouslyAddedCardId, "cardNumber": cardNumber, "cardExpMonth": cardExpMonth, "cardExpYear": cardExpYear, "cardCvc": cardCvc, "isSaveCard": isSaveCard, "setDefaultPaymentMethod": setDefaultPaymentMethod]
        case .salonSignupStep2AddSalonDetails(let salonName, let salonDescription, let salonCountryCode, let salonPhone, _):
            return ["salonName": salonName, "salonDescription": salonDescription, "salonCountryCode": salonCountryCode, "salonPhone": salonPhone]
        case .salonSignupStep3AddSalonTimings(let salonTimings):
            return ["salonTimings": salonTimings]
        case .salonSignupStep4AddSalonServices(let salonServices):
            return ["salonServices": salonServices]
        case .changeLanguage(let languageType):
            let lng = UserDefaults.standard.value(forKey: "CurrentLang") as? String ?? ""
            return ["languageType": lng]
        case .convertRewardPointsToMoneyIntoWallet(let rewardPoints):
            return ["rewardPoints": rewardPoints]
        case .cancelBookingUserSide(let id):
            return ["id": id]
        case .searchNearbySalonsAndStylists(let latitude, let longitude, let keyword):
            return ["latitude": latitude, "longitude": longitude, "keyword": keyword]
        case .rescheduleBooking(let id, let bookingDate, let bookingTime):
            return ["id": id, "bookingDate": bookingDate, "bookingTime": bookingTime]
        case .updateIsIosSubscriptionActive(let isIosSubscriptionActive):
            return ["isIosSubscriptionActive": isIosSubscriptionActive]
        case .stripeBalanceTransfersListing(let limit, let page):
            return ["limit": limit, "page": page]
        case .notificationListingPagination(let page, let limit):
            return ["page": page, "limit": limit]
        case .rescheduleBookingSalonSide(let id, let bookingDate, let bookingTime):
            return["id": id, "bookingDate": bookingDate, "bookingTime": bookingTime]
        case .addManualBooking(let manualCustomerName, let manualCustomerCountryCodePhone, let salonServiceIds, let bookingDate, let bookingTime, let amountToBePaid, let discount, let totalAmount):
            return ["manualCustomerName": manualCustomerName, "manualCustomerCountryCodePhone": manualCustomerCountryCodePhone, "salonServiceIds": salonServiceIds, "bookingDate": bookingDate, "bookingTime": bookingTime, "amountToBePaid": amountToBePaid, "discount": discount, "totalAmount": totalAmount]
        }
    }
    
    
    var multipartBody: [MultipartFormData]? {
        
        switch self {
        case .signup(_, _, _, _, _, _, _, _, _, let image):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            let data = image
            multipartData.append(MultipartFormData.init(provider: .data(data) , name: "image", fileName: str, mimeType: "image/jpeg"))
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
            
        case .editProfile(_, _, _, _, _, _, let image, _, _,_ ,_):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            if image.count > 0 {
                let data = image
                multipartData.append(MultipartFormData.init(provider: .data(data) , name: "image", fileName: str, mimeType: "image/jpeg"))
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
            
        case .editSalonStylist(_, _, _, _, _, _, _,_, _, let image):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            if image.count > 0 {
                let data = image
                multipartData.append(MultipartFormData.init(provider: .data(data) , name: "image", fileName: str, mimeType: "image/jpeg"))
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
            
        case .addSalonImage(let salonImages):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            if salonImages.count > 0 {
                let data = salonImages
                multipartData.append(MultipartFormData.init(provider: .data(data) , name: "salonImages", fileName: str, mimeType: "image/jpeg"))
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
            
        case .addSalonStylist(_, _, _, _, _, _, let image):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            if image?.count ?? 0 > 0 {
                let data = image!
                multipartData.append(MultipartFormData.init(provider: .data(data) , name: "image", fileName: str, mimeType: "image/jpeg"))
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
        case .editStylistProfile(_, _, _, _, let image):
            var multipartData = [MultipartFormData]()
            let str = "\(Date().timeIntervalSince1970).jpeg"
            if image?.count ?? 0 > 0 {
                let data = image!
                multipartData.append(MultipartFormData.init(provider: .data(data) , name: "image", fileName: str, mimeType: "image/jpeg"))
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
        case .salonSignupStep2AddSalonDetails(_, _, _, _, let salonImages):
            var multipartData = [MultipartFormData]()
            
            for i in salonImages {
                let str = "\(Date().timeIntervalSince1970).jpeg"
                let data = i
                if i.count > 10 {
                    multipartData.append(MultipartFormData.init(provider: .data(data) , name: "salonImages", fileName: str, mimeType: "image/jpeg"))
                }
                
            }
            
            
            parameters.forEach( { (key, value) in
                let tempvalue = "\(value)"
                let data = tempvalue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
                
            })
            return multipartData
        
        default:
            return nil
        }
    }
}

//(user_id: String, req_type : String, year:String, make:String, model:String,vehicle_usage:String,ownership:String,vin:String,miles_covered:String,lic_plate:String,vehicle_id:String)
//email, password
