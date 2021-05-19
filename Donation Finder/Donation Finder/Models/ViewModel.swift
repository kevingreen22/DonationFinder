//
//  ViewModel.swift
//  Donation Finder
//
//  Created by Kevin Green on 8/21/20.
//  Copyright © 2020 SBK DIgital. All rights reserved.
//

import SwiftUI
import MapKit

class ViewModel: ObservableObject {
    @Published var mapView = MKMapView(frame: .zero)
    @Published var environment = false
    @Published var donationCardPosition = CardPosition.bottom
    @Published var detailsCardPosition = CardPosition.hidden
    @Published var backgroundStyle = BackgroundStyle.blur
    @Published var cardDragGesture = DragGesture()
    @Published var showMapAlertDenied: Bool = false
    @Published var showMapAlertRestricted: Bool = false
    @Published var isAnnotationSelected: Bool = false
}


