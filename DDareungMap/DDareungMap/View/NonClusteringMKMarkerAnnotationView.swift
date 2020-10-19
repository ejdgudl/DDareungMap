//
//  NonClusteringMKMarkerAnnotationView.swift
//  DDareungMap
//
//  Created by 김동현 on 2020/10/19.
//

import Foundation
import MapKit

// NonClustering
class NonClusteringMKMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            displayPriority = MKFeatureDisplayPriority.required
        }
    }
}
