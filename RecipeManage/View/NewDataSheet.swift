//
//  NewDataSheet.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI

struct NewDataSheet: View {
    // MARK: - PROPERTY
    @ObservedObject var recipeModel: RecipeViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var imageData: Data = .init(capacity:0)
    @State var isActionSheet = false
    @State var isImagePicker = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var image = Image(systemName: "photo")
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        CameraView(recipeModel: recipeModel, imageData: $imageData, source: $source, image: $image, isActionSheet: $isActionSheet, isImagePicker: $isImagePicker)
                            .padding(.top, 50)
                        
                        NavigationLink(
                            destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
                            isActive:$isImagePicker,
                            label: {
                                Text("")
                            })
                    }
                    HStack{
                        Text("料理名")
                        TextEditor(text: $recipeModel.recipeName)
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    HStack(spacing: 10){
                        Text("材料")
                        
                        TextEditor(text: $recipeModel.ingredient)
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .frame(width:300 ,height:100)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button(action: {recipeModel.writeData(context: context)}, label: {
                        Label(title:{Text(recipeModel.updateItem == nil ? "Add Now" : "Update")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        },
                              icon: {Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                        .padding(.vertical)
                        .frame(width:UIScreen.main.bounds.width - 30)
                        .background(Color.blue)
                        .cornerRadius(50)
                    })
                    .padding()
                    .disabled(recipeModel.recipeName == "" ? true : false)
                    .opacity(recipeModel.recipeName == "" ? 0.5 : 1)
                }
            }
        }
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .bottom))
    }
}

struct NewDataSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewDataSheet(recipeModel: RecipeViewModel())
    }
}
