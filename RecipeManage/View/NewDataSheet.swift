//
//  NewDataSheet.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI
import KeyboardObserving

struct NewDataSheet: View {
    // MARK: - PROPERTY
    @ObservedObject var recipeModel: RecipeViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var imageData: Data = .init(capacity:0)
    @State var isActionSheet = false
    @State var isImagePicker = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    @State var pickerList: [String] = ["洋食","和食","中華","軽食"]
    @State var isShowScreen = false
    
    @State private var image = UIImage(systemName: "photo")
    
    @FocusState private var focus: Bool
    
    var userDefaults = UserDefaults.standard
    var list: [String] = []
    
    // MARK: - BODY
    var body: some View {
        
        
        NavigationView {
            ScrollViewReader { reader in
                ScrollView {
                    VStack (spacing:0){
                        
                        HStack {
                            CameraView(recipeModel: recipeModel, imageData: $recipeModel.imageData, source: $source, isActionSheet: $isActionSheet, isImagePicker: $isImagePicker)
                                .padding(.top, 50)
                        } //HSTACK
                        
                        Group {
                            
                            VStack(spacing:10) {
                                
                                TextField("料理名", text: $recipeModel.recipeName)
                                    .padding()
                                    .background(Color.primary.opacity(0.1))
                                    .frame(height: 100)
                                    .cornerRadius(10)
                                    .focused($focus)
                                
                                Divider()
                                
                                HStack{
                                    Text("料理ジャンル")
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    
                                    Picker(selection: $recipeModel.cuisine, label: Text("料理ジャンル")) {
                                        
                                        if pickerList.isEmpty == false{
                                            ForEach(pickerList, id: \.self) { picker in
                                                Text(picker)
                                            }
                                        } else {
                                            Text("カテゴリを追加してください")
                                                .font(.footnote)
                                        }
                                        
                                    }
                                    .frame(width: 300, height:80)
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Button("編集"){
                                        isShowScreen.toggle()
                                    }
                                    .foregroundColor(.orange)
                                    .sheet(isPresented: $isShowScreen, onDismiss: {
                                        pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? ["洋食","和食","中華","軽食"]
                                        print(pickerList)
                                    }) {
                                        AddPickerView(isShowScreen: $isShowScreen)
                                            .presentationDetents([.height(UIScreen.main.bounds.height / 1.7)])
                                    }
                                    
                                    Spacer()
                                    
                                } // HSTACK
                                
                                Divider()
                                
                                
                                TextField("メモ", text: $recipeModel.memo)
                                    .padding()
                                    .border(Color.primary.opacity(0.5),width: 1)
                                    .frame(height:100)
                                    .autocapitalization(.none)
                                    .focused($focus)
                                    .multilineTextAlignment(.leading)
                                    .ignoresSafeArea(.keyboard,edges: .bottom)
                                
                                
                            } // VSTACK
                            .padding()
                            .ignoresSafeArea(.keyboard,edges: .bottom)
                            
                        }
                        
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
                    
                } //SCROLLVIEW
                
            }
            
        }
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .bottom))
        .onAppear{
            pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? ["洋食","和食","中華","軽食"]
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
