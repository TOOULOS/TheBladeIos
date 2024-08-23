//
//  ApiConstants.swift
//  InsureTika
//
//  Created by keshav kumar on 31/01/20.
//  Copyright © 2020 keshav kumar. All rights reserved.
//

import UIKit

internal struct ApiConstants{
    static let baseURL = "https://admin.thebladeapp.com/api/"
   // static let baseURL = "http://18.134.220.89/api/"
    static let login = "login"
    static let forgotPassword = "forgotPassword"
    static let signup = "signup"
    static let aboutUs = "aboutUs"
    static let termsAndConditions = "termsAndConditions"
    static let privacyPolicy = "privacyPolicy"
    static let changePassword = "changePassword"
    static let editProfile = "editProfile"
    static let deleteAccount = "deleteAccount"
    static let logout = "logout"
    static let getProfile = "getProfile"
    static let getOtherUserProfile = "getOtherUserProfile"
    static let notificationListing = "notificationListing"
    static let userHomeScreen = "userHomeScreen"
    static let searchNearbySalonsAndStylists = "searchNearbySalonsAndStylists"
    static let nearbySalons = "nearbySalons"
    static let nearbyStylists = "nearbyStylists"
    static let getServicesForSalonOrSalonStylist = "getServicesForSalonOrSalonStylist"
    static let getSalonServicesBasedOnSalonId = "getSalonServicesBasedOnSalonId"
    static let getHairStylistsBasedOnSalonServiceId = "getHairStylistsBasedOnSalonServiceId"
    static let addBooking = "addBooking"
    static let bookingListing = "bookingListing"
    static let bookingDetail = "bookingDetail"
    static let cancelBookingUserSide = "cancelBookingUserSide"
    static let salonSlotsDayWise = "salonSlotsDayWise"
    static let rescheduleBooking = "rescheduleBooking"
    static let addOrRemoveFavouriteSalonOrStylist = "addOrRemoveFavouriteSalonOrStylist"
    static let favouriteSalonOrStylistListing = "favouriteSalonOrStylistListing"
    static let getSalonDetail = "getSalonDetail"
    static let getSalonStylistDetail = "getSalonStylistDetail"
    static let getStripeSecret = "getStripeSecret"
    static let addReview = "addReview"
    static let givenReviewsListing = "givenReviewsListing"
    static let rewardsData = "rewardsData"
    static let convertRewardPointsToMoneyIntoWallet = "convertRewardPointsToMoneyIntoWallet"
    static let upDateAutoAccept = "editProfile"
    static let addSalonImage = "editProfile"
    static let editStylistProfile = "editProfile"
    static let changeLanguage = "editProfile"
    static let notificationListingPagination = "notificationListingPagination"
    
    
    static let salonSignupStep2AddSalonDetails = "salonSignupStep2AddSalonDetails"
    static let salonSignupStep3AddSalonTimings = "salonSignupStep3AddSalonTimings"
    static let salonSignupStep4AddSalonServices = "salonSignupStep4AddSalonServices"
    static let salonSignupStep5AddSalonStylist = "salonSignupStep5AddSalonStylist"
    static let updateSalonTimings = "updateSalonTimings"
    static let deleteSalonImages = "deleteSalonImages"
    static let getSalonServices = "getSalonServices"
    static let addSalonService = "addSalonService"
    static let editSalonService = "editSalonService"
    static let addSalonStylist = "addSalonStylist"
    static let editSalonStylist = "editSalonStylist"
    static let bookingListingSalonSide = "bookingListingSalonSide"
    static let calendarBasedBookingListingSalonSide = "calendarBasedBookingListingSalonSide"
    static let bookingDetailSalonSide = "bookingDetailSalonSide"
    static let updateBookingStatus = "updateBookingStatus"
    static let manualBooking = "manualBooking"
    static let unblockManualBooking = "unblockManualBooking"
    static let myManualBookings = "myManualBookings"
    static let updateRescheduleBookingStatus = "updateRescheduleBookingStatus"
    static let buySubscription = "buySubscription"
    static let checkSubscription = "checkSubscription"
    static let cancelSubscription = "cancelSubscription"
    static let walletDetail = "walletDetail"
    static let withdrawAmountFromWallet = "withdrawAmountFromWallet"
    static let getChartDataSalonSide = "getChartDataSalonSide"
    
    static let deleteStylistImages = "deleteStylistImages"
    static let getChartDataStylistSide = "getChartDataStylistSide"
    static let getStripeCards = "getStripeCards"
    static let deleteStripeCard = "deleteStripeCard"
    
    static let updateIsIosSubscriptionActive = "updateIsIosSubscriptionActive"
    static let stripeBalanceTransactionsListing = "stripeBalanceTransactionsListing"
    static let walletTransactions = "walletTransactions"
    static let stripeBalanceTransfersListing = "stripeBalanceTransfersListing"
    
    static let rescheduleBookingSalonSide = "rescheduleBookingSalonSide"
    static let addManualBooking = "addManualBooking"
}


internal struct AppName{
    static let value  = "Blase"
}
