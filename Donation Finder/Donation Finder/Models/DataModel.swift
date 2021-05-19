//
//  DataModel.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/30/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit

enum DonationCategoryType: String, CaseIterable {
    case clothes = "clothes"
    case food = "food"
    case blood = "blood"
    case recycle = "recycle"
}

enum MarkerImageName: String, CaseIterable {
    case clothes = "clothes_marker"
    case food = "food_marker"
    case blood = "blood_marker"
    case recycle = "recycle_marker"
}

enum UDKeys {
    static let clothesToggle = "clothes toggle"
    static let foodToggle = "food toggle"
    static let bloodToggle = "blood toggle"
    static let recycleToggle = "recycle toggle"
}


class DataModel: ObservableObject {
    @Published var originalDonationLocations = [DonationLocation]()
    @Published var donationLocations = [DonationLocation]()
    @Published var donationLocation = DonationLocation()
    @Published var ommitedCategoryTypes = [DonationCategoryType]()
    @Published var clothesToggleState: Bool = UserDefaults.standard.bool(forKey: UDKeys.clothesToggle) {
        didSet {
            UserDefaults.standard.set(self.clothesToggleState, forKey: UDKeys.clothesToggle)
            self.clothesToggleState ? ommitedCategoryTypes.removeAll { $0 == .clothes } : ommitedCategoryTypes.append(.clothes)
            self.filterAnnotationArray()
        }
    }
    @Published var foodToggleState: Bool = UserDefaults.standard.bool(forKey: UDKeys.foodToggle) {
        didSet {
            UserDefaults.standard.set(self.foodToggleState, forKey: UDKeys.foodToggle)
            self.foodToggleState ? ommitedCategoryTypes.removeAll { $0 == .food } : ommitedCategoryTypes.append(.food)
            self.filterAnnotationArray()
        }
    }
    @Published var bloodToggleState: Bool = UserDefaults.standard.bool(forKey: UDKeys.bloodToggle) {
        didSet {
            UserDefaults.standard.set(self.bloodToggleState, forKey: UDKeys.bloodToggle)
            self.bloodToggleState ? ommitedCategoryTypes.removeAll { $0 == .blood } : ommitedCategoryTypes.append(.blood)
            self.filterAnnotationArray()
        }
    }
    @Published var recycleToggleState: Bool = UserDefaults.standard.bool(forKey: UDKeys.recycleToggle) {
        didSet {
            UserDefaults.standard.set(self.recycleToggleState, forKey: UDKeys.recycleToggle)
            self.recycleToggleState ? ommitedCategoryTypes.removeAll { $0 == .recycle } : ommitedCategoryTypes.append(.recycle)
            self.filterAnnotationArray()
        }
    }
    
    
    /// Fetch json and decode and update an array property
    func fetchGeoJson(ofType category: DonationCategoryType? = nil) {
//        if let category = category {
        //        var apiURL = ""
        //
        //        switch category {
        //        case .clothes:
        //             apiURL = "https://getGeoJSON/from/clothes.json"
        //        case .food:
        //             apiURL = "https://getGeoJSON/from/food.json"
        //        case .blood:
        //             apiURL = "https://getGeoJSON/from/blood.json"
        //        case .recycle:
        //             apiURL = "https://getGeoJSON/from/recycle.json"
        //        }
//        }
        
        /// this is for testing from local JSON file
        guard let fileName = Bundle.main.url(forResource: "features", withExtension: "geojson"),
            let donationLocation = try? Data(contentsOf: fileName) else { return }
        
        do {
            let features = try MKGeoJSONDecoder().decode(donationLocation).compactMap { $0 as? MKGeoJSONFeature }
            let validWorks = features.compactMap(DonationLocation.init)
            donationLocations.append(contentsOf: validWorks)
            originalDonationLocations = donationLocations
            print("JSON retrieved & added to array of data model")
        } catch {
            print("Unexpected error: \(error).")
        }
        
        /// this is for fetching JSON file via URL
        //        guard let url = URL(string: apiURL) else { print("Invalid URL"); return }
        
        //        if let data = try? Data(contentsOf: url) {
        //            do {
        //                let features = try MKGeoJSONDecoder().decode(data).compactMap { $0 as? MKGeoJSONFeature }
        //
        //                let donationAnnotations = features.compactMap(DonationLocation.init)
        //                self.dataModel.donationLocations.append(contentsOf: donationAnnotations)
        //
        //                print("GeoJSON features retrieved.")
        //            } catch {
        //                print("Unexpected error: \(error.localizedDescription).")
        //            }
        //        } else {
        //            print("Data error")
        //        }
    }

    
}



extension DataModel {
   
    /// Filters the array of Donation locations to remove annotations for the Ommited Category types.
    func filterAnnotationArray() {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        
        self.donationLocations = originalDonationLocations
        
        for category in ommitedCategoryTypes {
            if category == .clothes {
                self.donationLocations.removeAll { $0.category == DonationCategoryType.clothes.rawValue }
            }
            
            if category == .food {
                self.donationLocations.removeAll { $0.category == DonationCategoryType.food.rawValue }
            }
            
            if category == .blood {
                self.donationLocations.removeAll { $0.category == DonationCategoryType.blood.rawValue }
            }
            
            if category == .recycle {
                self.donationLocations.removeAll { $0.category == DonationCategoryType.recycle.rawValue }
            }
        }
        
        print("Filtering finished")
    }
}
