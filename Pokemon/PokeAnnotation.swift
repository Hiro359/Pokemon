//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by 重信和宏 on 30/10/16.
//  Copyright © 2016 Hiro. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
 var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon:Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon 
    
    self.coordinate = coord}
    
    
    


}
