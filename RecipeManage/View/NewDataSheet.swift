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
    @State var cuisine:[String] = ["洋食","和食","中華"]
    
    @State private var image = Image(systemName: "photo")
    @State private var selection = "選択してください"
    
    @FocusState private var focus: Bool
    
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
                            }) //NavigationLink
                    } //HSTACK
                    VStack{
                        
                        TextField("料理名", text: $recipeModel.recipeName)
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .frame(height: 100)
                            .cornerRadius(10)
                            .focused($focus)
                        
                        VStack {
                            Picker(selection: $selection, label: Text("料理ジャンル")) {
                                ForEach(0 ..< cuisine.count, id: \.self) { num in
                                    Text(self.cuisine[num])
                                }
                            }
                            .onChange(of: selection) { genre in
                                recipeModel.cuisine = genre
                            }
                            .frame(width: 400)
                            .pickerStyle(WheelPickerStyle())
                            
                            Text(recipeModel.cuisine)
                            
                        }
                        
//                        TextField("料理ジャンル",text: $recipeModel.cuisine)
//                            .padding()
//                            .background(Color.primary.opacity(0.1))
//                            .frame(height: 100)
//                            .cornerRadius(10)
//                            .focused($focus)
//                            .toolbar {
//                                ToolbarItemGroup(placement: .keyboard) {
//                                    Spacer()
//                                    Button("完了") {
//                                        focus = false
//                                    }
//                                }
//                            }
                    } // HSTACK
                    .padding()
                    
                    Button(action: {recipeModel.writeData(context: context)}, label: {
                        Label(title:{Text(recipeModel.updateItem == nil ? "メニュー登録" : "メニュー更新")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        },
                              icon: {Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                        })
                        .padding(.vertical)
                        .frame(width:UIScreen.main.bounds.width - 30)
                        .background(Color.orange)
                        .cornerRadius(15)
                    }) //BUTTON
                    .padding()
                    .disabled(recipeModel.recipeName == "" ? true : false)
                    .opacity(recipeModel.recipeName == "" ? 0.5 : 1)
                } //VSTACK
                
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
