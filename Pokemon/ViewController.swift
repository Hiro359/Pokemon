//
//  ViewController.swift
//  Pokemon
//
//  Created by 重信和宏 on 25/10/16.
//  Copyright © 2016 Hiro. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUp()
            
            
        }
        else { manager.requestWhenInUseAuthorization()
            
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
        setUp()
        }
    }
    
    func setUp() { mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block:
            { (timer) in
                //Spawn a Pokemon
                
                
                if let coord = self.manager.location?.coordinate{
                    
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                    anno.coordinate = coord
                    let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000
                    let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000
                    
                    
                    anno.coordinate.latitude += randoLat
                    anno.coordinate.longitude += randoLon
                    self.mapView.addAnnotation(anno)
                }})
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            
            annoView.frame = frame
            
            return annoView
        }
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        
        annoView.frame = frame
        
        return annoView
        
        
    }
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("We made it")
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        }
        else{ manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        
        if view.annotation is MKUserLocation {
            return }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate{
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)){
                    
                    
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    let alertVC = UIAlertController(title:"YAY", message:"You catched a \(pokemon.name!)", preferredStyle:.alert)
                    
                    let pokedexAction = UIAlertAction(title: "Go to Pokedex", style: .default, handler: {(action) in self.performSegue(withIdentifier: "pokedex.segue", sender: nil)})
                    alertVC.addAction(pokedexAction)
                    
                    
                    
                    let OKaction = UIAlertAction(title: "okay", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    let alertVC = UIAlertController(title:"Ops", message:"You are too far away to catch the \(pokemon.name!)", preferredStyle:.alert)
                    let OKaction = UIAlertAction(title: "okay", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                }
                
            }
            
        }}
    
    @IBAction func centerTapped(_ sender: AnyObject) {
        if let coord = manager.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)}
        
    }
}

