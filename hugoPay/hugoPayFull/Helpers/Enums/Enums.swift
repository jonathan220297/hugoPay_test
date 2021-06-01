//
//  Enums.swift
//  HugoPay
//
//  Created by Jonathan  Rodriguez on 28/5/21.
//

import Foundation

enum Colors: Int {
    case hugo = 0x391D62
    case hugoNewPurple = 0x38215c
    case hugoDark = 0x341161
    case hugoText = 0x42464D
    case ratingButton = 0x39CEBD
    case hugoLight = 0x8773B6
    case hugoGray = 0x887B9E
    case hugoLightGray = 0xF9F9F9
    case hugoShadow = 0x2443f1
    case hugoPurpleLight = 0xb6aec4
    case hugoPlaceholder = 0xC7C7CD
    case hugoBackgroundBlur = 0x111f3a
    case hugoStrongPurple = 0x1f0d3a
    case hugoPressBtn = 0x8265c4
    case hugoProfileProgress = 0xf1edfb
    case hugoEmptyTableColor = 0x3c265f
    case hugoWrongText = 0xf2835d
    case hugoLogOut = 0x968AA9
    case ccPink = 0xF7BCB3
    case ccWhite = 0xe0e6e7
    case ccYellow = 0xfed56d
    case ccOrange = 0xf3855e
    case hugoGrayBorder =  0xa4a3a6
    case hugoBlueFB =  0x4267b2
    case hugoGrayTermsCondition = 0x647A7E
    case hugoNavigationBarSearchAddres = 0x361865
    case hugoPurplePayService = 0x371865
    case hugoButtonNew = 0x806bb9
    case hugoLightLight = 0x917ec1
    case grapePurple = 0x3c1b5d
    case hugoPayPurple = 0x470076
    case hpFullPurple = 0x591a89
}

enum ColorsCCLetter: Int {
    case ccPurple = 0xfafafa
    case ccPink = 0x5b3934
    case ccWhite = 0x38215c
    case ccOrange = 0xffffff
}

enum ColorsCCNoneDefault: Int {
    case ccPurple = 0x756294
    case ccPink = 0xc37f75
    case ccWhite = 0xdedede
    case ccYellow = 0xfed56d
    case ccOrange = 0xdc5120
}


enum ColorsUInt: UInt {
    case hugo = 0x391D62
    case hugoDark = 0x341161
    case hugoText = 0x42464D
    case ratingButton = 0x39CEBD
    case white = 0xffffff
}

enum Fonts: String {
    case Black = "GothamHTF-Black"
    case XLight = "GothamHTF-XLight"
    case Medium = "GothamHTF-Medium"
    case Light = "GothamHTF-Light"
    case Book = "GothamHTF-Book"
    case BookItalic = "GothamHTF-BookItalic"
    case Ultra = "GothamHTF-Ultra"
    case Bold = "GothamHTF-Bold"
}

enum ComingFrom: Int {
    case MyLocation = 1
    case Address = 2
}

enum AuthType {
    case Login
    case FB
}

enum DetailAction: String {
    case Insert = "addToCart"
    case Update = "updateCart"
    case Remove = "removeFromCart"
}

enum PartnerRefreshType {
    case Full
    case SearchOnly
    case SortOnly
    case None
}

enum OrderStatus: String {
    case DispatchedOrder = "ODE"
    case OrderInserted = "OI"
    case OnWay = "OW"
    case OnWayButNotifiedToClient = "OWN"
    case PreparationOrder = "OP"
}

enum OrderType: String {
    case Ride = "transport"
    case Order = "order"
    case Event = "event"
    case Shipment = "shipment"
    case Entertainment = "entertainment"
    case PayService = "payservice"
    case TopUp = "topup"
}


enum SearchSectionType {
    case TAG
    case PARTNER
}

enum SortPartnerType {
    case RATING
    case PRICE_RANGE
    case DELIVERY_RANK
    case DISTANCE
    case DEFAULT
}
enum SortDeliveryType : String {
    case onDemand = "on_demand"
    case schedule = "scheduled"
    case takeout = "takeout"
}

enum SortType {
    case ASCENDING
    case DESCENDING
}

enum RatingButton {
    case partner, driver, hugo
}

enum ColorCC: String {
    case Purple = "purple"
    case Pink = "pink"
    case White = "white"
    case Yellow = "yellow"
    case Orange = "orange"

}

enum ShowResetPasswordView {
    case temporalCode
    case setNewCode
    case verifyNewCode
}
