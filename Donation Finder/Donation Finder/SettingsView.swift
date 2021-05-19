//
//  SettingsView.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/12/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit

struct SettingsView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack {
            Text("Legend").padding().font(.largeTitle)
            Text("Choose which types of donation locations to show on the map.").padding().foregroundColor(Color.gray)
            
            HStack {
                VStack(alignment: .leading) {
//                    ForEach(DonationCategoryType.allCases, id: \.self) { categoryType in
//                        DonationLegendToggleView(donationCategoryType: categoryType)
//                    }
                    
                    // Clothes toggle
                    HStack {
                        Image(getMarkerImage(for: .clothes))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                                         
                        Spacer()
                        
                        Toggle(isOn: self.$dataModel.clothesToggleState) {
                            Text("Clothes")
                        }
                    }
                    
                    // Food toggle
                    HStack {
                        Image(getMarkerImage(for: .food))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                                           
                        Spacer()
                        
                        Toggle(isOn: self.$dataModel.foodToggleState) {
                            Text("Food")
                        }
                    }
                    
                    // Blood toggle
                    HStack {
                        Image(getMarkerImage(for: .blood))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Spacer()
                        
                        Toggle(isOn: self.$dataModel.bloodToggleState) {
                            Text("Blood")
                        }
                    }
                    
                    // Recycle toggle
                    HStack {
                        Image(getMarkerImage(for: .recycle))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Spacer()
                        
                        Toggle(isOn: self.$dataModel.recycleToggleState) {
                            Text("Recycle")
                        }
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                
                Spacer()

            }
            
            Spacer()
        }
    }
    
    
    
    fileprivate func getMarkerImage(for type: DonationCategoryType) -> String {
        switch type {
        case .clothes:
            return MarkerImageName.clothes.rawValue
        case .food:
            return MarkerImageName.food.rawValue
        case .blood:
            return MarkerImageName.blood.rawValue
        case .recycle:
            return MarkerImageName.recycle.rawValue
        }
    }
}


struct SettingsView_Previews: PreviewProvider {    
    static var previews: some View {
        SettingsView()
            .environmentObject(DataModel())
            .environmentObject(ViewModel())
    }
}



//struct DonationLegendToggleView: View {
//    var index = 0
//    @State var donationCategoryType: DonationCategoryType
//    @EnvironmentObject var dataModel: DataModel
//
//    var body: some View {
//        HStack {
//            Image(getMarkerImage(type: donationCategoryType))
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//
//            Text(self.dataModel.legendToggles[index].donationCategoryTypeLabel.rawValue.capitalizeFirstLetter())
//                .font(.callout)
//
//            Spacer()
//
//            Toggle(isOn: self.$dataModel.legendToggles[index].enabled) {
//            }
//        }
//    }
    
    
//    fileprivate func getMarkerImage(type: DonationCategoryType) -> String {
//        switch type {
//        case .clothes:
//            return MarkerImageName.clothes.rawValue
//        case .food:
//            return MarkerImageName.food.rawValue
//        case .blood:
//            return MarkerImageName.blood.rawValue
//        case .recycle:
//            return MarkerImageName.recycle.rawValue
//        }
//    }
    
    
    
//}




extension String {
    func capitalizeFirstLetter() -> String {
        let first = self[self.startIndex].uppercased()
        let temp = String(self.dropFirst())
        return first + temp
    }
    
}
