//
//  LottyMapView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import NMapsMap

final class LottyMapView: NMFMapView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        allowsRotating = false
        allowsTilting = false
        positionMode = .compass
        minZoomLevel = 10.0
        maxZoomLevel = 18.0
        extent = NMGLatLngBounds(
            southWestLat: 31.43,
            southWestLng: 122.37,
            northEastLat: 44.35,
            northEastLng: 131
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
