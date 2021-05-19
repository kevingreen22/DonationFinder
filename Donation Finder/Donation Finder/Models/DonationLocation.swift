//
//  DonationLocation.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/30/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class DonationLocation: NSObject, MKAnnotation, Identifiable {
    var id = UUID()
    var title: String?
    var category: String
    var location: String?
    var imageURL: String?
    var address: String?
    var hours: String?
    var phone: String?
    var website: String?
    var info: String?
    var coordinate: CLLocationCoordinate2D
    
    override init() {
        title = "UsAgain"
        category = "Clothes Bin"
        location = "Parking lot"
        imageURL = "https://usagain/images/imageName.png"
        address = "145 Cypress Ave.; San Bruno, Ca, 94066; United States"
        hours = "Everyday: 8am - 8pm"
        phone = "800-765-5555"
        website = "https://Stuckbykev.com"
        info = "We accept clothing, shoes & bedding."
        coordinate = CLLocationCoordinate2D()
    }
    
    init(title: String,
         category: String,
         location: String?,
         imageURL: String?,
         address: String?,
         hours: String?,
         phone: String?,
         website: String?,
         info: String?,
         coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.category = category
            self.location = location
            self.imageURL = imageURL
            self.address = address
            self.hours = hours
            self.phone = phone
            self.website = website
            self.info = info
            self.coordinate = coordinate
            super.init()
        }
    
    init?(feature: MKGeoJSONFeature) {
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
            else {
                return nil
        }
        
        title = properties["title"] as? String ?? "Unknown Title"
        category = properties["category"] as? String ?? "Unknown Category"
        location = properties["location"] as? String ?? "Unknown Location"
        imageURL = properties["imageURL"] as? String ?? "Unknown image"
        address = properties["address"] as? String ?? "Unknown address"
        hours = properties["hours"] as? String ?? "Unknown hours"
        phone = properties["phone"] as? String ?? "Unknown phone"
        website = properties["website"] as? String ?? "Unknown website"
        info = properties["info"] as? String ?? "No Info"
        coordinate = point.coordinate
        super.init()
    }
    
    
    var markerTintColor: UIColor  {
        switch category {
        case "clothes":
            return .green
        case "food":
            return .purple
        case "recycle":
            return .blue
        case "blood":
            return .red
        default:
            return .lightGray
        }
    }
    
    
    var image: UIImage? {
        guard let image = UIImage(contentsOfFile: imageURL ?? "unknownImage.png") else { return nil }
        return image
    }

    var glyphImage: UIImage {
        switch category {
        case "clothes":
            return UIImage(imageLiteralResourceName: "clothes.png")
        case "food":
            return UIImage(imageLiteralResourceName: "food.png")
        case "recycle":
            return UIImage(imageLiteralResourceName: "recycle.png")
        case "blood":
            return UIImage(imageLiteralResourceName: "blood.png")
        default:
            return UIImage(imageLiteralResourceName: "unknown.png")
        }
    }
    
    
    var mapItem: MKMapItem? {
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location
        return mapItem
    }
    
}

enum DonationLocationType: String {
    case clothes = "clothes"
    case food = "food"
    case recycle = "recycle"
    case blood = "blood"
}





// For preview only
extension DonationLocation {
    static var example: DonationLocation {
        let location = DonationLocation(title: "San Francisco", category: "clothes", location: "Bay area", imageURL: nil, address: nil, hours: nil, phone: nil, website: nil, info: nil, coordinate: CLLocationCoordinate2D(latitude: 37.77, longitude: -122.41))
        return location
    }
}
