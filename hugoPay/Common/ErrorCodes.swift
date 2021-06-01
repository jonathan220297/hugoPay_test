//
//  ErrorCodes.swift
//  Hugo
//
//  Created by Developer on 2806//18.
//  Copyright © 2018 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct ErrorCodes {
    
    struct ProcessOrder {
        static let PartnerIdIsNilWhileCreateOrder = "1100"
        static let ProcessOrderBlockerIsNil = "1101"
        static let UnableToCastToStringPFCloundResponse = "1102"
        static let PFCloudFunctionValidatePromotionFailed = "1103"
        static let PartnerIdIsNilWhileCheckingStatus = "1104"
        static let TerritoryIdDoesntExists = "1105"
        static let CCTimeout = "1106"
        static let ExceptionWithCodeFromCCPayment = "1107"
        static let UnableToCastBlockerPositionZeroAsString = "1108"
        static let WrongCashConversionToDouble = "1109"
        static let UnableToAddProductToOrder = "1110"
        static let EmptyTotalForCash = "1111"
        static let EmptyDefaultAddress = "1112"
        static let EmptyTotalsForOrder = "1113"
        static let EmptyClientInfo = "1114"
        static let EmptyOrderInfo = "1115"
        static let EmptyRequiredCode = "1116"
        static let EmptyResponseOrderCreate = "1117"
    }
    
    struct OrderDraft {
        static let CouldntCreateDraft = "1125"
        static let CouldntCancelDraft = "1126"
    }

    struct OrderSummary {
        static let UserHasNoProfile = "1150"
        static let OrderIsEmpty = "1151"
        static let UnableToFindPartnerForOrder = "1152"
    }
    
    struct SearchLocation {
        static let UnableToSaveAddress = "1200"
        static let UnableToCreateAddress = "1201"
        static let VCIsNotAddressBook = "1202"
    }
    
    struct PastOrderDetail {
        static let OrderIdOrPartnerIdIsNil = "1250"
        static let PFCLoudFunctionDulplicateOrderFailed = "1251"
        static let PFCLoudFailedLoadDraftOrderAfterOrderFromHistory = "1252"
    }
    
    struct Search {
        static let TerritoryFromPartnerManagerIsNil = "1300"
    }
    
    struct ItemOptions {
        static let ProductLimitExceeded = "1350"
    }
    
    struct PartnerManager {
        static let GeoLocationORTerritoryFromUserIsNil = "1400"
    }
    
    struct Login {
        static let UserBlocked = "1450"
    }
    
    struct CCRegistration {
        static let EmptyCardNumber = "1500"
        static let EmptySplitExpDate = "1501"
        static let EmptySplitCardNUmber = "1502"
        static let ValidationCCStartCCEnd = "1503"
        static let EmptyResultSaveCard = "1504"
        static let EmptyResultAvailableCard = "1505"
        static let CardNotFoundInList = "1506"
        static let EmptyCardList = "1507"
        static let EmptyCCNumber = "1508"
        static let EmptyCCType = "1509"
    }
    
    struct PaymentTypeSelection {
        static let EmptyCardIndexFromCCBook = "1550"
        static let EmptyCardListFromCCBook = "1551"
        static let IncompleteParamsForValidCards = "1552"
        static let ErrorCardsToDic = "1553"
        static let CannotLoadSecureCards = "1554"
        static let EmptyUserCardListFromManager = "1555"
        static let LoopSplitCardNumberError = "1556"
    }
  
    struct DriverTip {
        static let CCEmptyFromCCBook = "1600"
    }
    
    struct VerifyPhone {
        static let EmptyPhoneLength = "1650"
    }
    
    struct DoCCPayment {
        static let ErrorReceived = "1700"
        static let HttpResponseNil = "1701"
        static let ErrorStatusCode = "1702"
        static let DataIsNil = "1703"
        static let WrongJsonCast = "1704"
        static let SuccessPropNotFound = "1705"
        static let WrongJsonSerialization = "1706"
        static let OtherError = "1707"
        static let WrongJsonSerializationFromException = "1708"
        static let PreticketNil = "1709"
        static let OrderIdNil = "1710"
        static let CCInfoIncomplete = "1711"
        static let CannotPrepareDataForSubmission = "1712"
        static let PreticketErrorReceived = "1713"
        static let PreticketParamForSubmission = "1714"
    }

    struct EndlessScroll {
        static let IndexOutOfBounds = "1750"
    }

    struct CCBook {
        static let IncompleteParamsForValidCards = "1770"
        static let ErrorCardsToDic = "1771"
        static let CannotLoadSecureCards = "1772"
    }


    struct RideInvitation {
        static let CreateInvitationFailed = "1800"
    }
    
    
    
    struct RideSummary {
        static let RideNotFound = "1900"
        static let LoadRequestVehicleResponseAddressesNil = "1901"
        static let LoadRequestVehicleResponseNil = "1902"
        static let LoadSearchingRideResponseNil = "1903"
        static let CancelSearchResponseNil = "1904"
        static let CancelSearchResponseAddressesNil = "1905"
        static let LoadRaidAcceptedResponseNil = "1906"
        static let ChangeRouteResponseNil = "1907"
        static let UserNotFound = "1908"
        static let CancelRideSuccessFalse = "1909"
        
        struct CarsController {
            static let UserNotFound = "1915"
            static let RequestVehicleResponseNil = "1916"
            static let RequestVehicleWithRaidResponseNil = "1917"
        }
        
        struct RideSearch {
            static let APIRequestPlaceFailed = "1925"
            static let APIRequestInfoIncomplete = "1926"
        }
        
        struct ArrivingController {
            static let DriverNotFound = "1945"
            static let RideIdIsNil = "1946"
            static let CancelRideFailed = "1947"
        }
    }
    
    struct FinalizeRide {
        static let RideIdIsNil = "1950"
        static let UserNotFound = "1951"
        static let TerritoryIdIsNil = "1952"
    }

    struct Shipment {
        static let GeneralShipmentError = "1975"
    }

    struct Tracking {
        static let OrderObjectIdIsNil = "2000"
        static let OrderDetailIsNil = "2001"
        static let UserClientIdIsNil = "2002"
        static let ShipmentObjectIdIsNil = "2003"
        
        struct Sheet {
            static let OrderIdIsNil = "2015"
            static let OrderObjectIdIsNil = "2016"
            static let OrderServiceIsNil = "2017"
            static let OrderDetailIsNil = "2018"
            static let OrderDriverIsNil = "2019"
            static let ShipmentDetailIsNil = "2020"
            static let ShipmentServiceIsNil = "2021"
            static let ShipmentObjectIdIsNil = "2022"
        }
        
        struct Redis {
            static let TokenIsNil = "2030"
            static let ObjectIdIsNil = "2033"
            static let ClientIdIsNil = "2034"
            static let AlamofireRequestFailed = "2035"
            static let AlamofireSuccessFailed = "2036"
            static let AlamofireParseFailed = "2037"
        }
    }
    
    struct NewRegister {
        
        struct MyLocation {
            static let TerritoryIsNil = "2500"
            static let CLLocationIsNil = "2501"
            static let SelectedAddressIsNil = "2502"
            static let CouldntSaveAddress = "2503"
        }

        struct SMSRequest {
            static let FailToSendSMS = "2520"
        }
        
        struct FacebookLogin {
            static let UnsupportedAction = "2565"
            static let SDKLoginWithFBFailed = "2566"
            static let APILoginWithFBFailed = "2567"
            static let FailedUpdatePassword = "2568"
            static let AccountNotMatchCallRequestFailed = "2569"
        }
        
        struct UserInfo {
            static let UpdateFailed = "2570"
            static let CreatePasswordFailed = "2571"
        }
        
        struct RecoverPassword {
            static let RequestInfoFailed = "2575"
            static let RequestCodeFailed = "2676"
            static let ValidationCodeFailed = "2577"
        }
        
        struct UpdatePassword {
            static let Failed = "2580"
            static let LoginFailed = "2581"
        }

        struct SMSPhoneCall {
            static let ParseFailed = "2600"
        }

    }
    
    struct NewProfile {
        
        struct ValidateEmail {
            static let ValidationFailed = "3000"
        }
        
    }
    
    struct Entertainment {
        
        struct Main {
            static let RequestEventFailed = "3250"
        }
        
        struct Summary {
            static let RequestSummaryFailed = "3300"
        }
        
        struct Historial {
            static let RequestTicketsFailed = "3450"
        }
        
    }
    
    struct HugoPay{
        struct PayServices {
            static let GetPayServicesFail = "3500"
            static let VerifyAutomaticFail = "3501"
            
        }
        struct PayServicesProviders {
            static let GetPayProvidersFail = "3505"
            
        }
        struct PayServicesForm {
            static let GetPayServicesFormFail = "3510"
            static let VerifyManualFail = "3511"
            static let VerifyAutomaticFail = "3512"
            
        }
        struct PayServicesCheckout {
            static let GetCheckoutManualFail = "3515"
            static let GetCheckoutAutomaticFail = "3516"
            static let GetCheckoutDetailFail = "3517"
            static let DoPaymentFail = "3518"
            
        }
        struct TopUp {
            static let GetTopUpFormFail = "3550"
            static let GetTopUpAmountFail = "3551"
            static let GetTopUpCheckoutFail = "3552"
            static let DoPaymentTopUpFail = "3553"
            
        }
        struct DetailHistory {
            static let GetDetailHistoryFail = "3570"
            
        }
        
        struct UserNotifications {
            static let GetUserNotificationsFail = "3590"
        }
        
        struct QRCodePayment {
            static let QRPaymentRejectTransaction = "3530"
        }
        
        struct Login {
//            static let RegisterPinFail = "3600"
            static let RegisterPinFail = "3600"
            static let VerifyPinFail = "3601"
            static let VerifyBiometricsFail = "3602"
        }
        
    }

}
