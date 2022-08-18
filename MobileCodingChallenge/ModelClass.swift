//  ModelClass.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 16/08/22.

import Foundation

struct CountryModel: Codable {
    var name: CountryNameModel?
}

struct CountryNameModel: Codable {
    var common: String?
}

struct SignupModel {
    var username: String?
    var email: String?
    var country: String?
    var password: String?
}

struct UserList: Codable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: AddressModel?
    var phone: String?
    var website: String?
    var company: CompanyModel?
}

struct AddressModel: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: GeoCodeModel?
}

struct CompanyModel: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}

struct GeoCodeModel: Codable {
    var lat: String?
    var lng: String?
}
