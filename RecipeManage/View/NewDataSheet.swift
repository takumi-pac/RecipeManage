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
    @State var pickerList: [String] = ["洋食","和食"]
    @State var isShowScreen = false
    
    @State private var image = Image(systemName: "photo")
    
    @FocusState private var focus: Bool
    
    var userDefaults = UserDefaults.standard
    var list: [String] = []
        
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
                    VStack {
                        
                        TextField("料理名", text: $recipeModel.recipeName)
                            .padding()
                            .background(Color.primary.opacity(0.1))
                            .frame(height: 100)
                            .cornerRadius(10)
                            .focused($focus)
                            
                        
                        HStack {
                            Picker(selection: $recipeModel.cuisine, label: Text("料理ジャンル")) {
                                
                            
                                if pickerList.isEmpty == false{
                                    ForEach(pickerList, id: \.self) { picker in
                                        Text(picker)
                                    }
                                }
                                
                            }
                            .frame(width: 300, height:100)
                            .pickerStyle(WheelPickerStyle())
                            
                            Button("編集"){
                                isShowScreen.toggle()
                            }
                            .sheet(isPresented: $isShowScreen, onDismiss: {
                                pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? []
                                print(pickerList)
                            }) {
                                AddPickerView(isShowScreen: $isShowScreen)
                                    .presentationDetents([.medium])
                            }
                            
                            Spacer()
                        }
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $recipeModel.memo)
                                    .padding()
                                    .border(Color.primary.opacity(0.5),width: 1)
                                    .frame(height:150)
                                    .autocapitalization(.none)
                                    .focused($focus)
                                
                                if recipeModel.memo.isEmpty {
                                    Text("メモ").foregroundColor(Color.primary.opacity(0.5))
                                }
                            } // ZStack
                            
                            
                            
                        } // VSTACK
                        .padding()
                        
                        
                        Button(action: {recipeModel.writeData(context: context)}, label: {
                            Label(title:{Text(recipeModel.updateItem == nil ? "メニュー登録" : "メニュー更新")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            },
                                  icon: {Image(systemName: "pencil")
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
            .onAppear{
                pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? []
            }
            .onTapGesture {
                focus = false
            }
        }
    
    }


    
    struct NewDataSheet_Previews: PreviewProvider {
        static var previews: some View {
            NewDataSheet(recipeModel: RecipeViewModel())
        }
    }
