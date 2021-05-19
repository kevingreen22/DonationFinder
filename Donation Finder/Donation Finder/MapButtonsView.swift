//
//  MapButtonsView.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/16/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct MapButtonsView: View {
    @Binding var isShowingSettings: Bool
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        
                        // settings button
                        Button(action: {
                            print("Settings button tapped")
                            self.isShowingSettings.toggle()
                        }, label: {
                            Image(systemName: "info.circle").imageScale(.large)
                        })
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .sheet(isPresented: $isShowingSettings) {
                                SettingsView()
                        }
                        
                        LocationButton()
                            .frame(width: 15, height: 15)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        CompassButton()
                            .frame(width: 15, height: 15)
                            .padding()
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            
            // Adds a blur view to the top notched area of the device screen
            GeometryReader { geo in
                BlurView(style: .regular)
                    .frame(width: geo.size.width, height: 46, alignment: .center)
                    .edgesIgnoringSafeArea(.top)
            }
            
        }
    }
}


struct MapButtonsView_Previews: PreviewProvider {
    static let view = ViewModel()
    static let userTrackingMode: MKUserTrackingMode = .follow
    
    static var previews: some View {
        MapButtonsView(isShowingSettings: .constant(false)).environmentObject(view)
    }
}



struct LocationButton: UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> MKUserTrackingButton {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        let button = MKUserTrackingButton(mapView: viewModel.mapView)
        return button
    }
    
    func updateUIView(_ uiView: MKUserTrackingButton, context: Context) {
        print("\(type(of: self)).\(#function)\n", terminator: "")

    }
}



struct CompassButton: UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> MKCompassButton {
        print("\(type(of: self)).\(#function)\n", terminator: "")
        let compassBtn = MKCompassButton(mapView: viewModel.mapView)
        compassBtn.compassVisibility = .adaptive
        return compassBtn
    }
    
    func updateUIView(_ uiView: MKCompassButton, context: Context) {
        print("\(type(of: self)).\(#function)\n", terminator: "")
    }
}

