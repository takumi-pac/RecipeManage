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
    @Published var cuisine = ""
    @Published var memo = ""
    @Published var date = Date()
    @Published var imageData: Data = Data.init()
    
    @Published var isNewData = false
    @Published var updateItem: Recipe!
    
    func writeData(context: NSManagedObjectContext) {
        
        if updateItem != nil {
            updateItem.date = date
            updateItem.recipeName = recipeName
            updateItem.cuisine = cuisine
            updateItem.memo = memo
            updateItem.imageData = imageData
            
            try! context.save()
            
            updateItem = nil
            date = Date()
            recipeName = ""
            cuisine = ""
            memo = ""
            imageData = Data.init()
            isNewData.toggle()
        } else {
            
            let newRecipe = Recipe(context: context)
            newRecipe.date = date
            newRecipe.recipeName = recipeName
            newRecipe.cuisine = cuisine
            newRecipe.memo = memo
            newRecipe.imageData = imageData
            
            
            do {
                try context.save()
                isNewData.toggle()
                
                date = Date()
                recipeName = ""
                cuisine = ""
                memo = ""
                imageData = Data.init()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func EditItem(item:Recipe) {
        updateItem = item
        
        date = item.date!
        recipeName = item.recipeName ?? ""
        cuisine = item.cuisine ?? ""
        memo = item.memo ?? ""
        imageData = item.imageData ?? Data.init()
        
        isNewData.toggle()
    }
}
