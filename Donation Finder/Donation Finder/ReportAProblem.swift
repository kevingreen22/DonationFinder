//
//  ReportAProblem.swift
//  Donation Finder
//
//  Created by Kevin Green on 9/24/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI

struct ReportAProblem: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack {
//            TitleBar()
//            Divider()
            
            NavigationView {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Enter Title", text: Binding($dataModel.donationLocation.title)!)
                    }
                    
                    Section(header: Text("Location")) {
                        Image(systemName: "location").imageScale(.large)
                    }
                    
                    Section(header: Text("Category")) {
                        Picker("Category", selection: $dataModel.donationLocation.category) {
                            Text(DonationCategoryType.clothes.rawValue).autocapitalization(.words)
                            Text(DonationCategoryType.food.rawValue).autocapitalization(.words)
                            Text(DonationCategoryType.blood.rawValue).autocapitalization(.words)
                            Text(DonationCategoryType.recycle.rawValue).autocapitalization(.words)
                        }
                    }
                    
                    Section(header: Text("Address")) {
                        TextField("Enter Address", text: Binding($dataModel.donationLocation.address)!)
                    }
                    
                    Section(header: Text("Hours")) {
                        TextField("Enter hours", text: Binding($dataModel.donationLocation.hours)!)
                    }
                    
                    Section(header: Text("Description")) {
                        TextField("Description", text: Binding($dataModel.donationLocation.info)!) { (changed) in
                            
                        } onCommit: {
                            
                        }

                    }
                    
                    
                    
                }
                .navigationBarTitle(Text("Edit Details"))
            }
        }
    }
    
}

struct ReportAProblem_Previews: PreviewProvider {
    static var previews: some View {
            ReportAProblem()
    }
}


struct TitleBar: View {
    var body: some View {
        HStack {
            Button(action: {
                // dismiss report a problem view
            }, label: {
                Text("Cancel")
            })
            .padding()
            
            Spacer()
            
            Text("Edit Location Details")
                .font(.body)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                // handle submit
            }, label: {
                Text("Submit")
            })
            .padding()
            .disabled(true)
            
            
        }
        .frame(height: 44)
        
        
    }
}

