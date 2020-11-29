//
//  Config.swift
//  UseGoogleMap
//
//  Created by NguyenVu on 29/11/2020.
//

import Foundation
import CoreLocation

final class ConfigManager{
    static let shared = ConfigManager()
    
    init() {
    }
    
    let googleMapStyle = "[{\"stylers\":[{\"saturation\":-100},{\"gamma\":1}]},{\"elementType\":\"labels.text.stroke\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"administrative.neighborhood\",\"elementType\":\"labels.text.fill\",\"stylers\":[{\"color\":\"#333333\"}]},{\"featureType\":\"poi.business\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi.business\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi.place_of_worship\",\"elementType\":\"labels.icon\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"poi.place_of_worship\",\"elementType\":\"labels.text\",\"stylers\":[{\"visibility\":\"off\"}]},{\"featureType\":\"road\",\"elementType\":\"geometry\",\"stylers\":[{\"visibility\":\"simplified\"}]},{\"featureType\":\"road.local\",\"elementType\":\"labels.text\",\"stylers\":[{\"color\":\"#333333\"},{\"weight\":0.5}]},{\"featureType\":\"transit.station\",\"elementType\":\"labels.icon\",\"stylers\":[{\"saturation\":50},{\"gamma\":1}]},{\"featureType\":\"water\",\"stylers\":[{\"hue\":\"#50a5d1\"},{\"saturation\":50},{\"visibility\":\"on\"}]}]"
    
}
