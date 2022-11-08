//
//  RecipeModel.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI
import CoreData

class RecipeViewModel: ObservableObject {
    @Published var recipeName = ""
    @Published var ingredient = ""
    @Published var date = Date()
    @Published var imageData: Data = Data.init()
    
    @Published var isNewData = false
    @Published var updateItem: Recipe!
    
    func writeData(context: NSManagedObjectContext) {
        
        if updateItem != nil {
            updateItem.date = date
            updateItem.recipeName = recipeName
            updateItem.ingredient = ingredient
            updateItem.imageData = imageData
            
            try! context.save()
            
            updateItem = nil
            date = Date()
            recipeName = ""
            ingredient = ""
            imageData = Data.init()
            isNewData.toggle()
        }
        
        let newRecipe = Recipe(context: context)
        newRecipe.date = date
        newRecipe.recipeName = recipeName
        newRecipe.ingredient = ingredient
        newRecipe.imageData = imageData
        
        do {
            try context.save()
            isNewData.toggle()
            
            date = Date()
            recipeName = ""
            ingredient = ""
            imageData = Data.init()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func EditItem(item:Recipe) {
        updateItem = item
        
        date = item.date!
        recipeName = item.recipeName!
        ingredient = item.ingredient!
        imageData = item.imageData ?? Data.init()
        
        isNewData.toggle()
    }
}
