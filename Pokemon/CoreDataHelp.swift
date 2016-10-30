//
//  CoreDataHelp.swift
//  Pokemon
//
//  Created by 重信和宏 on 25/10/16.
//  Copyright © 2016 Hiro. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon(){
    
    createPokemon(name: "Mew",  imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Abra",  imageName: "abra")
    createPokemon(name: "Bellsprout",  imageName: "bellsprout")
    createPokemon(name: "Bullbasaur",  imageName: "bullbasaur")
    createPokemon(name: "Charmander",  imageName: "charmander")
    createPokemon(name: "Pikachu-2",  imageName: "pikachu-2")
    createPokemon(name: "Snorlax",  imageName: "snorlax")
    
    
    
}

func createPokemon(name: String, imageName: String){
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
    
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    
}

func getAllPokemon() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
            
        }
        return pokemons
    } catch{}
    return []
}

func getAllCaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest <Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }
    catch{}
    return []
    
}
func getAllUncaughtPokemons() -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest <Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    }
    catch{}
    return []
    
}

