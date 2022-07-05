//
//  Registration.swift
//  HotelRegistrations
//
//  Created by Taron on 29.06.22.
//

import Foundation

struct Registration {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let checkInDate: Date
    let checkOutDate: Date
    let numberOfAdults: Int
    let numberOfChildren: Int
    let wifi: Bool
    let roomType: RoomType
}
