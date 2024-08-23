//
//  Parser.swift
//  MaidFinder
//
//  Created by Apple on 19/11/19.
//  Copyright © 2019 Mac_Mini17. All rights reserved.
//
//http://184.72.23.251:3182/api
//
//or
//
//http://app.thechattingtimmy.com:3182/api

import Foundation
import Moya

extension TargetType {
   
    func parseModel(data: Data) -> Any? {
        
        print(data)
        switch self {
        case is SignupEP:
            let endpoint = self as! SignupEP
            
            switch endpoint {
            
            case .login(email: let email, password: let password):
                return JSONHelper<ObjectData<SignupModel>>().getCodableModel(data: data)
            case .forgotPassword, .changePassword, .deleteAccount, .logout, .addBooking, .salonSignupStep2AddSalonDetails, .salonSignupStep3AddSalonTimings, .rescheduleBooking, .updateIsIosSubscriptionActive, .walletTransactions:
                return JSONHelper<DefaultModel>().getCodableModel(data: data)
            case .signup , .editProfile, .upDateAutoAccept, .addSalonImage, .editStylistProfile, .getProfile, .salonSignupStep4AddSalonServices:
                return JSONHelper<ObjectData<SignupModel>>().getCodableModel(data: data)
            case .aboutUs, .termsAndConditions, .privacyPolicy:
                return JSONHelper<ObjectData<PageModel>>().getCodableModel(data: data)
            case .userHomeScreen:
                return JSONHelper<ObjectData<CustomerHomeModel>>().getCodableModel(data: data)
            case .addOrRemoveFavouriteSalonOrStylist, .deleteSalonImages, .deleteStylistImages:
                return JSONHelper<DefaultModel>().getCodableModel(data: data)
            case .nearbySalons:
                return JSONHelper<ObjectData<[CustomerHomeNearByModel]>>().getCodableModel(data: data)
            case .searchNearbySalonsAndStylists:
                return JSONHelper<ObjectData<[SearchModel]>>().getCodableModel(data: data)
            case .nearbyStylists:
                return JSONHelper<ObjectData<[CustomerHomeTopRatedModel]>>().getCodableModel(data: data)
            case .favouriteSalonOrStylistListing:
                return JSONHelper<ObjectData<[CustomerHomeNearByModel]>>().getCodableModel(data: data)
            case .getSalonDetail, .getSalonStylistDetail:
                return JSONHelper<ObjectData<SaloonDetailModel>>().getCodableModel(data: data)
            case .bookingListing:
                return JSONHelper<ObjectData<[BookingModel]>>().getCodableModel(data: data)
            case .notificationListing, .notificationListingPagination:
                return JSONHelper<ObjectData<[NotificationModel]>>().getCodableModel(data: data)
            case .givenReviewsListing:
                return JSONHelper<ObjectData<[ReviewModel]>>().getCodableModel(data: data)
            case .bookingListingSalonSide, .calendarBasedBookingListingSalonSide:
                return JSONHelper<ObjectData<[BookingModel]>>().getCodableModel(data: data)
            case .updateBookingStatus, .convertRewardPointsToMoneyIntoWallet, .rescheduleBookingSalonSide, .addManualBooking:
                return JSONHelper<DefaultModel>().getCodableModel(data: data)
            case .editSalonService, .addSalonService:
                return JSONHelper<ObjectData<SaloonStylistServiceModel>>().getCodableModel(data: data)
            case .rewardsData:
                return JSONHelper<ObjectData<RewardModel>>().getCodableModel(data: data)

            case .addReview, .changeLanguage, .cancelBookingUserSide:
                return JSONHelper<DefaultModel>().getCodableModel(data: data)
            case .walletDetail:
                return JSONHelper<ObjectData<WalletAmount>>().getCodableModel(data: data)
            case .stripeBalanceTransactionsListing:
                return JSONHelper<ObjectData<TransactionModel>>().getCodableModel(data: data)
            case  .stripeBalanceTransfersListing:
                return JSONHelper<ObjectData<TransfersModel>>().getCodableModel(data: data)
            case .updateSalonTimings:
                return JSONHelper<ObjectData<SignupModel>>().getCodableModel(data: data)
            case .withdrawAmountFromWallet, .manualBooking, .unblockManualBooking, .deleteStripeCard:
                return JSONHelper<DefaultModel>().getCodableModel(data: data)
            case .getChartDataSalonSide, .getChartDataStylistSide:
                return JSONHelper<ObjectData<DashboardBodyModel>>().getCodableModel(data: data)
            case .salonSlotsDayWise:
                return JSONHelper<ObjectData<SlotModel>>().getCodableModel(data: data)
            case .addSalonStylist, .editSalonStylist:
                return JSONHelper<ObjectData<SaloonStylistDetailModel>>().getCodableModel(data: data)
            case .getStripeCards:
                return JSONHelper<ObjectData<[CardModel]>>().getCodableModel(data: data)
            }
            
            
            
            default:
                return nil
        }
    }
}
