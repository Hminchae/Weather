//
//  MapCollectionViewCell.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import UIKit
import MapKit

final class MapCollectionViewCell: BaseCollectionViewCell {
    
    private let mapView = MKMapView()
    
    override func configureHierarchy() {
        contentView.addSubview(mapView)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        let seoulCoordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let region = MKCoordinateRegion(center: seoulCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = seoulCoordinate
        annotation.title = "서울"
        mapView.addAnnotation(annotation)
    }
    
    public func configure() {
        
    }
}
