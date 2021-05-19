//
//  DetailView.swift
//  Donation Finder
//
//  Created by Kevin Green on 9/7/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct DetailView: View {
    @Binding var isShowingReportProblem: Bool
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(dataModel.donationLocation.title!)").font(.title).padding(.leading)
                            Text("\(dataModel.donationLocation.category)").padding(.leading)
                        }
                        Spacer()
                        DismissButton()
                            .padding(.trailing)
                    }
                    
                    Button("Get Directions") {
                        print("Directions Button Tapped")
                        // Opens Maps App to get directions
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        self.dataModel.donationLocation.mapItem?.openInMaps(launchOptions: launchOptions)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.vertical)
                    .padding(.horizontal, UIScreen.main.bounds.width / 3)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8.0)
                    
                    
                    Spacer()
                    
                    GeometryReader { geo in
                        ScrollView {
                            Image("image_placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width, height: 180, alignment: .center)
                                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.17), radius: 10.0)

                            if let hours = dataModel.donationLocation.hours {
                                CollectionSectionView(headerText: "Hours", text: hours)
                            }
                            
                            if let address = dataModel.donationLocation.address {
                                let formattedAddress = address.replacingOccurrences(of: "; ", with: "\n")
                                CollectionSectionView(headerText: "Address", text: formattedAddress)
                            }
                            
                            if let phone = dataModel.donationLocation.phone {
                                CollectionSectionButtonView(isShowingReportProblem: $isShowingReportProblem, headerText: "Phone", text: phone) {
                                    // validation of phone number not included
                                    let dash = CharacterSet(charactersIn: "-")
                                    let cleanString = phone.trimmingCharacters(in: dash)
                                    let tel = "tel://"
                                    let formattedString = tel + cleanString
                                    guard let url: URL = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url as URL)
                                }
                            }
                            
                            
                            if let website = dataModel.donationLocation.website {
                                // should trim website string to just domain
                                let absoluteURL = formatWebsite(website)
                                CollectionSectionButtonView(isShowingReportProblem: $isShowingReportProblem, headerText: "Website", text: absoluteURL) {
                                    guard let url = URL(string: "\(website)") else { return }
                                    UIApplication.shared.open(url)
                                }
                            }
                            
                            
                            if let info = dataModel.donationLocation.info {
                                CollectionSectionView(headerText: "Description", text: info)
                            }
                            
                            CollectionSectionButtonView(isShowingReportProblem: $isShowingReportProblem, headerText: nil, text: "Report a Problem") {
                                // toggle report problem
                                self.isShowingReportProblem.toggle()
                            }
                            
                            
                            
                            // Adds room to the bottom of the scroll view to allow everything to be viewable when scrolled to the bottom, this is because the Slide card view does not fully come on to the screen.
                            VStack {
                                Text(" ")
                                Text(" ")
                                Text(" ")
                                Text(" ")
                                Text(" ")
                            }
                            
                        }
                        .frame(width: geo.size.width)
                        
                    }
                }
            }
        }
    }
}


fileprivate func formatWebsite(_ siteString: String) -> String {
    var noHTTPS = ""
    if siteString.hasPrefix("https://") {
        noHTTPS = siteString.replacingOccurrences(of: "https://", with: "")
    } else if siteString.hasPrefix("http://") {
        noHTTPS = siteString.replacingOccurrences(of: "http://", with: "")
    }

    if let slashIndex = noHTTPS.firstIndex(of: "/") {
        noHTTPS.removeSubrange(slashIndex..<noHTTPS.endIndex)
    }
    
    return noHTTPS
}



struct DetailView_Previews: PreviewProvider {
    static let dataModel = DataModel()
    
    static var previews: some View {
        DetailView(isShowingReportProblem: .constant(false)).environmentObject(dataModel)
    }
}



struct CollectionSectionView: View {
    @State var headerText: String?
    @State var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if let headerText = headerText {
                Text(headerText).padding(.leading).foregroundColor(Color.gray)
            }
            Text(text)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
                .padding(.leading)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.black)
                .background(Color.white)
                .cornerRadius(8.0)
                .padding(.trailing)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.17), radius: 10.0)
        }
        .padding([.top, .leading])
    }
}


struct CollectionSectionButtonView: View {
    @Binding var isShowingReportProblem: Bool
    @State var headerText: String?
    @State var text: String
    @State var action: () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let headerText = headerText {
                Text(headerText).padding(.leading).foregroundColor(Color.gray)
            }
            Button(action: {
                action()
            }, label: {
                Text(text)
            })
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30, height: 44, alignment: .leading)
            .padding(.leading)
            .multilineTextAlignment(.leading)
            .background(Color.white)
            .cornerRadius(8.0)
            .padding(.trailing)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.17), radius: 10.0)
            .sheet(isPresented: $isShowingReportProblem) {
                ReportAProblem()
        }
        }
        .padding([.top, .leading])
    }
}

