//
//  RegistrationController.swift
//  HotelRegistrations
//
//  Created by Taron on 06.07.22.
//

import Foundation

final class RegistrationController {
    
    static let registrationsURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = urls.first
        else { fatalError() }
        
        return documentsURL.appendingPathComponent("registrations").appendingPathExtension("plist")
    }()
    
    static var registrations: [Registration] {
        get {
            guard let registrationsData = try? Data(contentsOf: registrationsURL)
            else { return [] }
            
            let registrations = try? PropertyListDecoder().decode([Registration].self, from: registrationsData)
            return registrations ?? []
        }
        
        set {
            guard let data = try? PropertyListEncoder().encode(newValue)
            else { return }
            
            try? data.write(to: registrationsURL)
        }
    }
}
