//
//  ContentView.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/11/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct ContentView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    @State private var isShowingSettings: Bool = false
    @State var isShowingReportProblem: Bool = false
    @EnvironmentObject var dataModel: DataModel
    @EnvironmentObject var viewModel: ViewModel
        
    var body: some View {
        ZStack {
            MapViewRep()
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    self.dataModel.fetchGeoJson()
            }
            .alert(isPresented: $viewModel.showMapAlertDenied) {
                Alert(title: Text("Location access denied"),
                      message: Text("Your location is needed for Donation Finder to locate awesome donation areas."),
                      primaryButton: .cancel(),
                      secondaryButton: .default(Text("Settings"), action: {
                        self.goToDeviceSettings()
                      })
                )
            }
            .alert(isPresented: $viewModel.showMapAlertRestricted) {
                Alert(title: Text("Location Permission Restricted"),
                      message: Text("The app cannot access your location. This is possibly due to active restrictions such as parental controls being in place. Please disable or remove them and enable location permissions in settings."),
                      primaryButton: .cancel(),
                      secondaryButton: .default(Text("Settings"), action: {
                        self.goToDeviceSettings()
                      })
                )
            }
            
            MapButtonsView(isShowingSettings: $isShowingSettings)

            
            SlideOverCard($viewModel.detailsCardPosition) {
                DetailView(isShowingReportProblem: $isShowingReportProblem)
                    .highPriorityGesture(self.viewModel.cardDragGesture)
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let data = DataModel()
    static let view = ViewModel()
    
    static var previews: some View {
        ContentView()
            .environmentObject(data)
            .environmentObject(view)
    }
}


extension ContentView {
    
  ///Path to device settings if location is disabled
  func goToDeviceSettings() {
    guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}

