//
//  DonationLocationAnnotationViews.swift
//  Donation Finder
//
//  Created by Kevin Green on 9/3/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import Foundation
import MapKit


//class DonationLocationAnnotationView: MKAnnotationView {
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let donationLocation = newValue as? DonationLocation else { return }
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
//            mapsButton.setBackgroundImage(UIImage(imageLiteralResourceName: "Map"), for: .normal)
//            rightCalloutAccessoryView = mapsButton
//
//            image = donationLocation.image
//
//            let detailLabel = UILabel()
//            detailLabel.numberOfLines = 0
//            detailLabel.font = detailLabel.font.withSize(12)
//            detailLabel.text = donationLocation.location
//            detailCalloutAccessoryView = detailLabel
//        }
//    }
//}


class DonationLocationMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            print("\(type(of: self)).\(#function)\n", terminator: "")
            if let donationLocation = newValue as? DonationLocation {
                clusteringIdentifier = "DonationLocation"
                
                if donationLocation.category == DonationLocationType.clothes.rawValue {
                    glyphImage = donationLocation.glyphImage
                    markerTintColor = donationLocation.markerTintColor
                    glyphTintColor = .white
                    displayPriority = .required
                    titleVisibility = .visible
                    animatesWhenAdded = true
                    
                } else if donationLocation.category == DonationLocationType.food.rawValue {
                    glyphImage = donationLocation.glyphImage
                    markerTintColor = donationLocation.markerTintColor
                    glyphTintColor = .white
                    displayPriority = .defaultHigh
                    titleVisibility = .visible
                    animatesWhenAdded = true
                    
                }  else if donationLocation.category == DonationLocationType.blood.rawValue {
                    glyphImage = donationLocation.glyphImage
                    markerTintColor = donationLocation.markerTintColor
                    glyphTintColor = .white
                    displayPriority = .defaultHigh
                    titleVisibility = .visible
                    animatesWhenAdded = true
                    
                }  else if donationLocation.category == DonationLocationType.recycle.rawValue {
                    glyphImage = donationLocation.glyphImage
                    markerTintColor = donationLocation.markerTintColor
                    glyphTintColor = .white
                    displayPriority = .defaultHigh
                    titleVisibility = .visible
                    animatesWhenAdded = true
                }
                
                collisionMode = .circle
            }
        }
    }
}


class ClusterView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var annotation: MKAnnotation? {
        willSet {
            print("\(type(of: self)).\(#function)\n", terminator: "")
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                let count = cluster.memberAnnotations.count
                
                let clothesCount = cluster.memberAnnotations.filter { member -> Bool in
                    return (member as! DonationLocation).category == DonationLocationType.clothes.rawValue
                }.count
                
                let foodCount = cluster.memberAnnotations.filter { member -> Bool in
                    return (member as! DonationLocation).category == DonationLocationType.food.rawValue
                }.count
                
                let bloodCount = cluster.memberAnnotations.filter { member -> Bool in
                    return (member as! DonationLocation).category == DonationLocationType.blood.rawValue
                }.count
                
                let recycleCount = cluster.memberAnnotations.filter { member -> Bool in
                    return (member as! DonationLocation).category == DonationLocationType.recycle.rawValue
                }.count
                
                let mostLocationsByTypeAndNumber = getMaxCountAndType([
                                                                    DonationCategoryType.clothes:clothesCount, DonationCategoryType.food:foodCount, DonationCategoryType.blood:bloodCount, DonationCategoryType.recycle:recycleCount
                ])
                
                image = renderer.image { _ in
                    // Fill full circle with dominant category type color
                    switch mostLocationsByTypeAndNumber.0 {
                    case .clothes: UIColor.green.setFill()
                    case .food: UIColor.purple.setFill()
                    case .blood: UIColor.red.setFill()
                    case .recycle: UIColor.blue.setFill()
                        
                    }
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    
                    
                    // Fill pie with "clothes" color
                    if mostLocationsByTypeAndNumber.0 != .clothes {
                        UIColor.green.setFill()
                        let clothesPiePath = UIBezierPath()
                        clothesPiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                              startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(clothesCount)) / CGFloat(count),
                                              clockwise: true)
                        clothesPiePath.addLine(to: CGPoint(x: 20, y: 20))
                        clothesPiePath.close()
                        clothesPiePath.fill()
                    }


                    // Fill pie with "food" color
                    if mostLocationsByTypeAndNumber.0 != .food {
                        UIColor.purple.setFill()
                        let foodPiePath = UIBezierPath()
                        foodPiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(foodCount)) / CGFloat(count),
                                           clockwise: true)
                        foodPiePath.addLine(to: CGPoint(x: 20, y: 20))
                        foodPiePath.close()
                        foodPiePath.fill()
                    }


                    // Fill pie with "blood" color
                    if mostLocationsByTypeAndNumber.0 != .blood {
                        UIColor.red.setFill()
                        let bloodPiePath = UIBezierPath()
                        bloodPiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                            startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(bloodCount)) / CGFloat(count),
                                            clockwise: true)
                        bloodPiePath.addLine(to: CGPoint(x: 20, y: 20))
                        bloodPiePath.close()
                        bloodPiePath.fill()
                    }


                    // Fill pie with "recycle" color
                    if mostLocationsByTypeAndNumber.0 != .recycle {
                        UIColor.blue.setFill()
                        let recyclePiePath = UIBezierPath()
                        recyclePiePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                              startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(recycleCount)) / CGFloat(count),
                                              clockwise: true)
                        recyclePiePath.addLine(to: CGPoint(x: 20, y: 20))
                        recyclePiePath.close()
                        recyclePiePath.fill()
                    }

                    
                    
                    
                    // Fill inner circle with white color
                    UIColor.white.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

                    // Finally draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)

                }
            }
            
            
        }
    }
    
    fileprivate func getMaxCountAndType(_ dict: [DonationCategoryType:Int]) -> (DonationCategoryType, Int) {
        let maxNum = max(dict[DonationCategoryType.clothes]!, dict[DonationCategoryType.food]!, dict[DonationCategoryType.blood]!, dict[DonationCategoryType.recycle]!)
        
        var category: DonationCategoryType = .clothes
        
        for (cat, num) in dict {
            if num == maxNum {
                category = cat
            }
        }
        
        return (category, maxNum)
    }
}

