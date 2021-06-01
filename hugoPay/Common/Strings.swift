//
//  Strings.swift
//  Hugo
//
//  Created by Juan Jose Maceda on 12/26/16.
//  Copyright © 2016 Clever Mobile Apps. All rights reserved.
//

import Foundation
import HugoCommons

struct AlertString {
    
    struct CreditCard {
        static let CCTypeRequiredWarningTitle = "CCTypeRequiredWarningTitle".localizedString
        static let CCTypeRequiredWarningMessage = "CCTypeRequiredWarningMessage".localizedString
    }
    
    struct History {
        static let ProductAlertTitle = "ProductAlertTitle".localizedString
        static let ProductAlertMsg = "ProductAlertMsg".localizedString
    }
    
    struct Order {
        static let OrderActiveTitle = "OrderActiveTitle".localizedString
    }
    
    struct ProductOptions {
        static let ProductRequireDocTitle = "ProductRequireDocTitle".localizedString
        static let ProductRequireDocMsg = "ProductRequireDocMsg".localizedString
    }
   
    struct CCBook {
        static let LimitExceededTitle = "LimitExceededTitle".localizedString
        static let LimitExceededMessage = "LimitExceededMessage".localizedString
        static let CarNotAvailableTitle = "CarNotAvailableTitle".localizedString
    }
    
    struct ATM {
        static let DailyLimitExceededTitle = "DailyLimitExceededTitle".localizedString
        static let DailyLimitExceededMessage = "DailyLimitExceededMessage".localizedString
    }
    
    struct CCRegistration{
        static let CardSavedSuccessTitle = "CardSavedSuccessTitle".localizedString
        static let ConfirmSaveTitle = "ConfirmSaveTitle".localizedString
        static let ConfirmSaveMessage = "ConfirmSaveMessage".localizedString
        
        static let CVCTitleAutorization_Enter = "CVCTitleAutorization_Enter".localizedString
        static let CVCDescAutorization_Base = "CVCDescAutorization_Base".localizedString
        static let CVCDescAutorization_Middle = "CVCDescAutorization_Middle".localizedString
        static let CVCDescAutorization_End = "CVCDescAutorization_End".localizedString
    }
    

    static let SubscriptionFailTitle = "SubscriptionFailTitle".localizedString
    static let SubscriptionFailBody = "SubscriptionFailBody".localizedString
    static let AProblemOcurredTitle = "AProblemOcurredTitle".localizedString
    static let RequiredFields = "RequiredFields".localizedString
    static let LocationChangedTitle = "LocationChangedTitle".localizedString
    static let LocationChangedMessage = "LocationChangedMessage".localizedString
    static let LocationChangedSelectQuestion = "LocationChangedSelectQuestion".localizedString
    static let LocationChangedAddQuestion = "LocationChangedAddQuestion".localizedString
    static let LocationChangedAcceptLabelBtn = "LocationChangedAcceptLabelBtn".localizedString
    static let LocationNeedToBeActive = "LocationNeedToBeActive".localizedString
    static let LocationNoAccess = "LocationNoAccess".localizedString
    static let LocationNoAccess2 = "LocationNoAccess2".localizedString
    static let LocationWithoutAccess = "LocationWithoutAccess".localizedString
    static let LocationNeededForPartners = "LocationNeededForPartners".localizedString
    static let NotInDelivereArea = "NotInDelivereArea".localizedString
    static let LocationImpossibleLocation = "LocationImpossibleLocation".localizedString
    static let OrderNoSamePartner = "OrderNoSamePartner".localizedString
    static let OrderNoSamePartnerTitle = "OrderNoSamePartnerTitle".localizedString
    static let OrderRequiredOptions = "OrderRequiredOptions".localizedString
    static let OrderRequiredOptionsTitle = "OrderRequiredOptionsTitle".localizedString
    static let OrderAddSpecialInstructions = "OrderAddSpecialInstructions".localizedString
    static let OrderActiveTitle = "OrderActiveTitle".localizedString
    static let OrderActive = "OrderActive".localizedString
    static let HelpTitle = "HelpTitle".localizedString

    static let helpBody = "helpBody".localizedString
    static let helpYes = "helpYes".localizedString
    static let helpNo = "helpNo".localizedString
    static let helpRequested = "helpRequested".localizedString
    static let helpRequestFailedTitle = "helpRequestFailedTitle".localizedString
    static let helpRequestFailedMessage = "helpRequestFailedMessage".localizedString
    static let phoneCallSmsFailedMessage = "phoneCallSmsFailedMessage".localizedString
    static let phoneCallSmsSucess = "phoneCallSmsSucess".localizedString
    static let OK = "OK".localizedString
    static let NO = "NO".localizedString
    static let Si = "Si".localizedString
    static let NoCoverTitle = "NoCoverTitle".localizedString
    static let NoCoverMessage = "NoCoverMessage".localizedString
    static let DeleteAddressTitle = "DeleteAddressTitle".localizedString
    static let DeleteAddressMessage = "DeleteAddressMessage".localizedString
    static let DeleteCardTitle = "DeleteCardTitle".localizedString
    static let DeleteCardMessage = "DeleteCardMessage".localizedString
    static let ActionDeleteLabel = "ActionDeleteLabel".localizedString
    static let ActionEditLabel = "ActionEditLabel".localizedString
    static let WelcomeBetaTitle = "WelcomeBetaTitle".localizedString
    static let WelcomeBetaMessage = "WelcomeBetaMessage".localizedString
    static let BetaNewVersionTitle = "BetaNewVersionTitle".localizedString
    static let BetaNewVersionMessage = "BetaNewVersionMessage".localizedString
    static let NoInternetAccessTitle = "NoInternetAccessTitle".localizedString
    static let NoInternetAccessMessage = "NoInternetAccessMessage".localizedString
    static let ComingTitle = "ComingTitle".localizedString
    static let ComingMessage = "ComingMessage".localizedString
    static let CloseSessionTitle = "CloseSessionTitle".localizedString
    static let CloseSessionMessage = "CloseSessionMessage".localizedString
    static let CancelOrderTitle = "CancelOrderTitle".localizedString
    static let CancelOrderMessage = "CancelOrderMessage".localizedString
    static let CancelShipmentTitle = "CancelShipmentTitle".localizedString
    static let CancelShipmentMessage = "CancelShipmentMessage".localizedString
    static let NeedChangeMessage = "NeedChangeMessage".localizedString
    static let MinimumAmountTitle = "MinimumAmountTitle".localizedString
    static let MinimumAmounMessage = "MinimumAmounMessage".localizedString
    static let NoChangeAction = "NoChangeAction".localizedString
    static let CancelLabel = "CancelLabel".localizedString
    static let CloseLabel = "lbl_To_Close".localizedString
    static let ViewLabel = "ViewLabel".localizedString
    static let AcceptLabel = "lbl_To_Accept".localizedString
    static let ConfirmLabel = "ConfirmLabel".localizedString
    static let AddressTitle = "AddressTitle".localizedString
    static let AddressTitleTakeOut = "AddressTitleTakeOut".localizedString
    static let PaymentTypeTitle = "PaymentTypeTitle".localizedString
    static let SelectPaymentTypeTitle = "SelectPaymentTypeTitle".localizedString
    static let CCLabel = "CCLabel".localizedString
    static let RedeemLabel = "RedeemLabel".localizedString
    static let CashLabel = "lbl_Cash".localizedString
    static let ListoLabel = "ListoLabel".localizedString
    static let GoToTracking = "GoToTracking".localizedString
    static let StayOnApp = "StayOnApp".localizedString
    static let AddressTypeRequired = "AddressTypeRequired".localizedString
    static let OrderDeliveredTitle = "OrderDeliveredTitle".localizedString
    static let OrderDeliveredMessage = "OrderDeliveredMessage".localizedString
    static let AllFieldRequired = "AllFieldRequired".localizedString
    static let BirthdateRequired = "BirthdateRequired".localizedString
    static let PasswordRequired = "PasswordRequired".localizedString
    static let WeakPasswordSubmitted = "WeakPasswordSubmitted".localizedString
    static let AccessRequiredTitle = "AccessRequiredTitle".localizedString
    static let AccessToCameraExplanation = "AccessToCameraExplanation".localizedString
    static let AccessToCameraExplanation2 = "AccessToCameraExplanation2".localizedString
    static let PaymentRequiredWarningTitle = "PaymentRequiredWarningTitle".localizedString
    static let PaymentRequiredWarningMessage = "PaymentRequiredWarningMessage".localizedString
    static let ProblemTitle = "ProblemTitle".localizedString
    static let EmailNoValidMessage = "EmailNoValidMessage".localizedString
    static let PassNoValidMessage = "PassNoValidMessage".localizedString
    static let NoValidTitle = "NoValidTitle".localizedString
    static let UserRequired = "UserRequired".localizedString
    static let UserNameRequired = "UserNameRequired".localizedString
    static let UserOrPassNoValidTitle = "UserOrPassNoValidTitle".localizedString
    static let Sent = "Sent".localizedString
    static let EmailSentMessage = "EmailSentMessage".localizedString
    static let EmailNoValidTitle = "EmailNoValidTitle".localizedString
    static let EmailNoValidMessage2 = "EmailNoValidMessage2".localizedString
    static let EmailRequiredTitle = "EmailRequiredTitle".localizedString
    static let VerifiedMobileTitle = "VerifiedMobileTitle".localizedString
    static let FeedbackExcelentTitle = "FeedbackExcelentTitle".localizedString
    static let FeedbackHowToImproveTitle = "FeedbackHowToImproveTitle".localizedString
    static let ProfileSaved = "ProfileSaved".localizedString
    static let MinOrderRequiredTitle = "MinOrderRequiredTitle".localizedString
    static let MinOrderRequiredMessage = "MinOrderRequiredMessage".localizedString
    static let CominSoonTitle = "CominSoonTitle".localizedString
    static let CominSoonMessage = "CominSoonMessage".localizedString
    static let CloseTitle = "CloseTitle".localizedString
    static let CloseMessage = "CloseMessage".localizedString
    static let ViewOrderBtnTitle = "ViewOrderBtnTitle".localizedString
    static let NoAvailable = "NoAvailable".localizedString
    static let FirstInstallTitle = "FirstInstallTitle".localizedString
    static let FirstInstallMsg = "FirstInstallMsg".localizedString
    static let NeedLoginTitle = "NeedLoginTitle".localizedString
    static let NeedLoginDesc = "NeedLoginDesc".localizedString
    static let authReason = "authReason".localizedString
    static let authErrorTitle = "authErrorTitle".localizedString
    static let authErrorDesc = "authErrorDesc".localizedString
    static let CCPaymentErrorTitle = "CCPaymentErrorTitle".localizedString
    static let CCPaymentErrorMessage = "CCPaymentErrorMessage".localizedString
    static let CCPaymentTimeoutErrorMessage = "CCPaymentTimeoutErrorMessage".localizedString
    static let CCPaymentMinimunAmountTitle = "CCPaymentMinimunAmountTitle".localizedString
    static let CCPaymentMinimunAmountBody = "CCPaymentMinimunAmountBody".localizedString
    static let NewVersionTitle = "NewVersionTitle".localizedString
    static let NewVersionMessage = "NewVersionMessage".localizedString
    static let NewVersionButton = "NewVersionButton".localizedString
    static let ConfirmAddressTitle = "ConfirmAddressTitle".localizedString
    static let ConfirmAddressOK = "ConfirmAddressOK".localizedString
    static let OrderProcessError = "OrderProcessError".localizedString
    static let OrderProcessTerritoryTitleError = "OrderProcessTerritoryTitleError".localizedString
    static let OrderProcessTerritoryMsgError = "OrderProcessTerritoryMsgError".localizedString
    static let CCPaymentGeneralTitle = "CCPaymentGeneralTitle".localizedString
    static let CCPaymentGeneralMsg = "CCPaymentGeneralMsg".localizedString
    static let CCShowCSSTitle = "CCShowCSSTitle".localizedString
    static let CCShowCSSMsg = "CCShowCSSMsg".localizedString
    static let Entendido = "Entendido".localizedString
    static let ChooseOtherAddrTitle = "ChooseOtherAddrTitle".localizedString
    static let NoValidCouponTitle = "NoValidCouponTitle".localizedString
    static let NoValidCouponMsg = "NoValidCouponMsg".localizedString
    static let YouHaveNewPrizesTitle = "YouHaveNewPrizesTitle".localizedString
    static let SaturatedPartnerTitle = "SaturatedPartnerTitle".localizedString
    static let SaturatedPartnerMessage = "SaturatedPartnerMessage".localizedString
    static let GeneralSaturatedTitle = "GeneralSaturatedTitle".localizedString
    static let GeneralSaturatedMessage = "GeneralSaturatedMessage".localizedString
    static let NoLocationPossibleMessage = "NoLocationPossibleMessage".localizedString
    static let GoToSettingsMessage = "GoToSettingsMessage".localizedString
    static let SelectTerritoriesMessage = "SelectTerritoriesMessage".localizedString
    static let WrongTerritoryAddressTitle = "WrongTerritoryAddressTitle".localizedString
    static let WrongTerritoryAddressMessage = "WrongTerritoryAddressMessage".localizedString
    static let WrongSetRangeAddressTitle = "WrongSetRangeAddressTitle".localizedString
    static let WrongSetRangeAddressMessage = "WrongSetRangeAddressMessage".localizedString
//    static let WrongTerritoryAddressDeleteOrderMessage = "Hemos detectado que tienes una orden pendiente de procesar, si cambias de dirección perderás tus cambios ¿Deseas cambiar continuar?"
    static let WrongTerritoryAddressDeleteOrderMessage2 = "WrongTerritoryAddressDeleteOrderMessage2".localizedString
    static let WrongTerritoryAddressDeleteOrderMessage = "WrongTerritoryAddressDeleteOrderMessage".localizedString
    static let WrongRangeAddressDeleteOrderMessage = "WrongRangeAddressDeleteOrderMessage".localizedString
    static let DeleteBillingTitle = "DeleteBillingTitle".localizedString
    static let DeleteBillingMessage = "DeleteBillingMessage".localizedString
    static let PartnerLimitTitle = "PartnerLimitTitle".localizedString
    static let PartnerLimitMessage = "PartnerLimitMessage".localizedString
    
    static let ShipmentAddSpecialInstructions = "ShipmentAddSpecialInstructions".localizedString
    static let ShipmentAddDescriptionInstructionsA = "ShipmentAddDescriptionInstructionsA".localizedString
    static let ShipmentAddDescriptionInstructionsB = "ShipmentAddDescriptionInstructionsB".localizedString
    static let InfoShipment = "InfoShipment".localizedString
    static let ShipmentPreviewError = "ShipmentPreviewError".localizedString
    static let ShipmentAddRideComment = "ShipmentAddRideComment".localizedString
    static let ShipmentRoundTrip = "ShipmentRoundTrip".localizedString
    
    
    //Trasportation
    static let VehicleNotAvailable = "VehicleNotAvailable".localizedString
    static let VehicleNotAvailableDetail = "VehicleNotAvailableDetail".localizedString
    static let CancelRideTitlePicking = "lbl_Cancel_Trip".localizedString
    static let CancelRideSubTitlePicking = "CancelRideSubTitlePicking".localizedString
    static let CancelRideMessagePicking = "CancelRideMessagePicking".localizedString
    static let CallTitlePicking = "CallTitlePicking".localizedString
    static let CallSubTitlePicking = "CallSubTitlePicking".localizedString
    static let CallMessagePicking = "CallMessagePicking".localizedString
    static let CancelRideTitleOnWay = "lbl_End_Trip".localizedString
    static let CancelRideSubTitleOnWay = "CancelRideSubTitleOnWay".localizedString
    static let CancelRideMessageOnWay = "CancelRideMessageOnWay".localizedString
    static let CallTitleOnWay = "CallTitleOnWay".localizedString
    static let CallSubTitleOnWay = "CallSubTitleOnWay".localizedString
    static let CallMessageOnWay = "CallMessageOnWay".localizedString
    static let HotZoneTitle = "HotZoneTitle".localizedString
    static let HotZoneSubTitle = "HotZoneSubTitle".localizedString
    static let HotZoneMessage = "HotZoneMessage".localizedString
    static let ErrorCDTitle = "ErrorCDTitle".localizedString
    static let ErrorCDSubTitle = "ErrorCDSubTitle".localizedString
    static let ErrorCDMessage = "ErrorCDMessage".localizedString
    static let ErrorChatTitle = "ErrorChatTitle".localizedString
    static let ErrorChatMessage = "ErrorChatMessage".localizedString
    
    struct Service {
        static let noOperationalTitle = "noOperationalTitle".localizedString
        static let noOperationalMessage = "noOperationalMessage".localizedString
    }
    
    struct Token {
        static let tokenErrorTitle = "tokenErrorTitle".localizedString
        static let tokenErrorMessage = "tokenErrorMessage".localizedString
        static let tokenErrorDigitsTitle = "tokenErrorDigitsTitle".localizedString
        static let tokenErrorDigitsMessage = "tokenErrorDigitsMessage".localizedString
        static let orderLoadErrorMessage = "orderLoadErrorMessage".localizedString
        static let tokenLoadNewOrderTitle = "tokenLoadNewOrderTitle".localizedString
        static let tokenLoadNewOrderMessage = "tokenLoadNewOrderMessage".localizedString
    }
    
    struct PhoneVerification {
        static let GetHelpTitle = "GetHelpTitle".localizedString
        static let GetHelpMsg = "GetHelpMsg".localizedString
        static let cannotGetPhoneMessage = "cannotGetPhoneMessage".localizedString
        static let cannotHaveBlankSpacesMessage = "cannotHaveBlankSpacesMessage".localizedString
        static let cannotHaveLetttersMessage = "cannotHaveLetttersMessage".localizedString
        static let cannotHaveMoreOrLessCharactersMessage = "cannotHaveMoreOrLessCharactersMessage".localizedString
        static let cannotHaveCountryCodeInPhoneMessage = "cannotHaveCountryCodeInPhoneMessage".localizedString
        static let confirmPhoneTitle = "confirmPhoneTitle".localizedString
        static let confirmPhoneMessage = "confirmPhoneMessage".localizedString
    }
    
    struct ProductsByCategory {
        static let ProductNotAvailableTitle = "ProductNotAvailableTitle".localizedString
        static let ProductNotAvailableMessage = "ProductNotAvailableMessage".localizedString
        static let DraftExist = "DraftExist".localizedString
    }
    
}

struct APDLGT {
    static let PRS1D = getMyCustomString("PRS1D")
    static let PRSR = getMyCustomString("PRSR")
    static let P4YR = getMyCustomString("P4YR")
    static let A55T5R = getMyCustomString("A55T5R")
    static let GM4P5K3 = getMyCustomString("GM4P5K3")
    static let GP14C3S = "&key=" + getMyCustomString("GP14C3S")
    static let PRMTRX = getMyCustomString("PRMTRX")
    static let ZDSKR = getMyCustomString("ZDSKR")
    static let ZDSK1D = getMyCustomString("ZDSK1D")
    static let ZDSKCLNT = getMyCustomString("ZDSKCLNT")
    static let ZDSCHAT = getMyCustomString("ZDSCHAT")
    static let ZDSAPPID = getMyCustomString("ZDAPPID")
    static let APP5FL1YR = getMyCustomString("APP5FL1YR")
    static let G4P1UR1 = getMyCustomString("G4P1UR1")
    static let G4P1T0PUP = getMyCustomString("G4P1T0PUP")
    static let GO4P1K3Y = getMyCustomString("GO4P1K3Y")
    static let USERUR1 = getMyCustomString("USERUR1")
    static let USERUR1KEY = getMyCustomString("USERUR1KEY")
    static let EL4STIC = getMyCustomString("EL4STIC")
    static let EL4STICURL = getMyCustomString("EL4STICURL")
    //VGS
    static let VGSURL   = getMyCustomString("VGSURL")
    static let VGSTKN   = getMyCustomString("VGSTKN")
    static let VID      = getMyCustomString("VAULTID")
    // HugoPay
    static let HPUR1 = getMyCustomString("HPUR1")
    static let HPK3Y = getMyCustomString("HPK3Y")
    static let HPCY1V = getMyCustomString("HPCY1V")
    static let HPCYK3Y = getMyCustomString("HPCYK3Y")
    // HugoPayFull
    static let HPFUR1 = getMyCustomString("HPFUR1")
    static let HPFK3Y = getMyCustomString("HPFK3Y")
    static let HPFURCI = getMyCustomString("HPFURCI")
}

struct Keys {
    
    struct OrderStatus {
        static let INSERTED = "OI"
        static let PREPARATION = "OP"
        static let DELIVERED_BY_PARTNER = "ODE"
        static let ON_WAY = "OW"
        static let ON_WAY_AND_NOTIFIED_TO_CLIENT = "OWN"
        static let DELIVERED_BY_DRIVER = "OD"
        static let CANCELLED = "OC"
        static let CANCELLED_NEED_PAY_TO_PARTNER = "OCC"
        static let DUPLICATED = "DP"
        static let ADDRESS_REVISION = "AR"
        static let FRAUDULENT_CARD = "OCCR"
        static let REJECTED = "OR"
        static let DRAFT = "ODRAFT"
    }
    
    struct Collections {
        static let Order = "Order"
    }
    
    struct OrderFields {
        static let ActiveStatusList = [
            Keys.OrderStatus.INSERTED,
            Keys.OrderStatus.PREPARATION,
            Keys.OrderStatus.DELIVERED_BY_PARTNER,
            Keys.OrderStatus.ON_WAY,
            Keys.OrderStatus.ON_WAY_AND_NOTIFIED_TO_CLIENT,
            Keys.OrderStatus.ADDRESS_REVISION,
            Keys.OrderStatus.REJECTED,
            Keys.OrderStatus.DUPLICATED,
            Keys.OrderStatus.FRAUDULENT_CARD]
        
        static let ObjectId = "objectId"
        static let ObjectIdV3 = "object_id"
        static let Branch = "branch"
        static let Territory = "territory"
        static let Country = "country"
        static let ClientIdPointer = "client_id"
        static let IsZoneMode = "is_zone_mode"
        static let DeviceId = "device_id"
        static let OrderId = "order_id"
        static let PartnerId = "partnerId"
        static let OrderStatus = "order_status"
        static let DriverIdPointer = "driver_id"
        static let OrderInsertedTime = "order_inserted_time"
        static let PartnerName = "partner_name"
        static let DriverName = "driver_name"
        static let PartnerLog = "partner_logo"
        static let PartnerIdPointer = "partner_id"
        static let BusinessStatus = "business_status"
        static let DisableOrder = "disable_order"
    }
    
    static let PREFPanicMode = "panic_mode"
    static let PREFSortKey = "sort_key"
    static let PREFSortDelivery = "delivery_sort"
    static let PREFShowNewOnly = "show_new_only"
    static let PREFBranch = "business_data"
    static let PREFBusinessStatus = "business_status"
    static let PREFPendingShowTracking = "tracking_status"
    static let PREFIdentifyZendesk = "identity_zendesk"
    //
    static let NOTIBranchFinished = "branch_finished"
    //
    
    struct Firebase {
        static let PARTNER_NAME = "partner_name";
        static let PAYMENT_TYPE = "payment_type";
        static let COMING_SOON_EVENT = "coming_soon"
    }
    
    struct NotificationCenter {
        struct Identifiers {
            static let ProcessOrder = "processOrder"
            static let UserNeedBilling = "userNeedBilling"
            static let PanicMode = "showPanicModeAlert"
            static let RateMode = "showRateModeAlert"
            static let UserLikePartner = "userLikePartner"
            static let TerritoryResult = "territoryResult"
            static let PaymentTypeResult = "paymentTypeResult"
            static let UserLogout = "userLogout"
            static let DoContact = "doContact"
        }
    }
    
    struct SmsOption {
        static let whatsapp = "conceptomovil_whatsapp"
    }
}

struct CloudEndPoints {
    static let Ranges = "getterritoryrange"
    static let PanicMode = "panicmodestatus"
    static let PartnerIsOpen = "partnerisopen"
    static let OrderDetail = "getorderdetailv2"
    static let OrderDetailV3 = "getorderdetailv3"
    static let Territories = "territories"
    static let TerritoriesByCountry = "territoriesbycountry"
    static let CallRequestOptions = "callrequestlist"
    static let TokenValidation = "tokenvalidation"
    static let FilterOrderByDate = "filterordersbydate"
    static let PaymentTypes = "paymenttypes"
    static let Services = "getservices"
    static let ServicesV2 = "newgetservices"
    static let ClientHistory = "getclienthistory"
    static let CallRequest = "callrequestclient"
    static let CallRequestNewRegister = "callrequestnewcheckin"
    static let NewAreaCodes = "newgetareacodelist"
    static let EventSummary = "eventsummary"
    static let FeedEvents = "getevents"
    static let CheckEventCode = "checkeventcode"
    static let HistorailEntertainmentDetail = "getdigital"
    static let ReturnStock = "returnstock"
    static let ShowTickets = "showtickets"
    static let CheckOutTickets = "checkouttickets"
    static let PaymentOfTickets = "paymentoftickets"
    static let CheckrRedeemCode = "checkredeemcode"
}

struct Strings {
    struct CreditCard {
        static let VISA = "Visa"
        static let MASTERCARD = "MasterCard"
        static let AMEX = "American Express"
        static let CardTypeTitle = "CardTypeTitle".localizedString
        struct ValidationRules {
            static let CardNameRequired = "CardNameRequired".localizedString
            static let NumCardRequired = "NumCardRequired".localizedString
            static let NumCardLength = "NumCardLength".localizedString
            static let MonthRequired = "MonthRequired".localizedString
            static let MonthLength = "MonthLength".localizedString
            static let YearRequired = "YearRequired".localizedString
            static let YearLength = "YearLength".localizedString
            static let PinRequired = "PinRequired".localizedString
        }
        
        static let ExpCardInfoTitle = "ExpCardInfoTitle".localizedString
        static let ExpCardInfoMessage = "ExpCardInfoMessage".localizedString
        static let CVCCardInfoTitle = "CVCCardInfoTitle".localizedString
        static let CVCCardInfoMessage = "CVCCardInfoMessage".localizedString
    }
    
    struct Storyboards {
        static let Order = "Order"
        static let Main = "Main"
        static let Profile = "Profile"
        static let PartnersProducts = "PartnersProducts"
        static let Business = "Business"
        static let Others = "Others"
        static let Registration = "Registration"
        static let Billing = "Billing"
        static let CC = "CC"
        static let Tracking = "Tracking"
        static let HistoryAndTracking = "HistoryAndTracking"
        static let Search = "SearchSortPartners"
        static let HugoPayTutorial = "HugoPayTutorial"
    }
    
    struct ViewControllers {
        struct Identifiers {
            static let Chooser = "UIViewController-BYZ-38-t0r"
            static let CCBook = "CCBookViewController"
            static let AddressBook = "AddressBookViewController"
            static let Summary = "OrderSummary-H1T-sB-weQ"
            static let Update = "updateViewController"
            static let Welcome = "welcomeViewController"
            static let VerifyPhone = "verifyPhoneViewController"
            static let PartnerProducts = "partnerProductsViewController"
            static let Token = "tokenViewController"
            static let Billing = "billingViewController"
            static let BillingForm = "billingFormViewController"
            static let BillingNavigation = "billingNavigationController"
            static let ItemOptions = "ItemOptionsViewController"
            static let Territory = "territoryViewController"
            static let Feed = "Feed"
            static let RegisterCreditCard = "registerCreditCardViewController"
            static let CallRequest = "callRequestViewController"
            static let Help = "helpViewController"
            static let Tracking = "TrackingViewController"
            static let SCHDetail = "ScheduleOrderDetailViewController"
            static let DriverTip = "driverTipController"
            static let RatingOptions = "ratingOptionsViewController"
            static let ProductsByCategory = "productsByCategoryViewController"
            static let AdvanceSearch = "AdvanceSearchViewController"
            
            // HUGO PAY TUTORIAL
            static let hugoPayTutorial = "hugoPayTutorial"
            static let hugoPayTutorialStepOne = "hugoPayTutorialStepOne"
            static let hugoPayTutorialStepTwo = "hugoPayTutorialStepTwo"
            static let hugoPayTutorialStepThree = "hugoPayTutorialStepThree"
            static let hugoPayTutorialStepFour = "hugoPayTutorialStepFour"
            static let hugoPayTutorialStepFive = "hugoPayTutorialStepFive"
            static let hugoPayTutorialStepSix = "hugoPayTutorialStepSix"
            static let hugoPayTutorialStepSeven = "hugoPayTutorialStepSeven"
            static let hugoPayTutorialStepEight = "hugoPayTutorialStepEight"

        }
    }
    
    struct UserDefaultsKeys {
        static let AppOpenedCount = "app_opened_count"
        static let AppOpenedCountForUpdate = "app_opened_count_for_update"
        static let AppAllReadyShowUpdate = "app_already_show_update"
        static let AppAllReadyShowReview = "app_already_show_review"
        static let AppAllReadyShowInfoShipment = "app_already_show_info_shipment"
    }
    
  
    static let GeneralErrorTitle = "GeneralErrorTitle".localizedString
    static let GeneralErrorMsg = "GeneralErrorMsg".localizedString
    
    static let originalNote = "originalNote".localizedString
    static let Actualizar = "Actualizar".localizedString
    static let Agregar = "Agregar".localizedString
    static let FreeCouponCode = "FreeCouponCode".localizedString
    static let Free = "Free".localizedString
    static let Soon = "Soon".localizedString
    static let Close = "Close".localizedString
    static let Min = "Min".localizedString
    static let DeliveryCost = "lblDeliveryCost".localizedString
    static let notificationService = "notificationService".localizedString
    static let searchLabelPlaceholder = "searchLabelPlaceholder".localizedString
    static let GeneralPanicModeStatusMessage = "GeneralPanicModeStatusMessage".localizedString
    static let PartnerPanicModeStatusMessage = "PartnerPanicModeStatusMessage".localizedString
    static let Saturated = "Saturated".localizedString
    static let KM_UNITS = "KM_UNITS".localizedString

    // Feed
    static let newPartner = "lbl_PartnerTable_New".localizedString
    static let commerceHeaderTitle = "lbl_Main_commerce_title".localizedString

    // Product extra information
    static let dimentions = "Dimensiones"
    static let madeIn = "Hecho en"
    static let calories = "Calorías"
    static let caloriesLabelString = "kCal"
}

