//
//  CameraView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var recipeModel: RecipeViewModel
    
    @Binding var imageData : Data
    @Binding var source:UIImagePickerController.SourceType
    
    @Binding var image:Image
    
    @Binding var isActionSheet:Bool
    @Binding var isImagePicker:Bool
    
    
    var body: some View {
        
        VStack(spacing:0){
            ZStack{
                NavigationLink(
                    destination: Imagepicker(show: $isImagePicker, image: $imageData, sourceType: source),
                    isActive:$isImagePicker,
                    label: {
                        Text("")
                    })
                VStack{
                    HStack(spacing:30){
                        Spacer()
                        
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                        Button(action: {
                            self.source = .photoLibrary
                            self.isImagePicker.toggle()
                        }, label: {
                            Text("フォルダから選択")
                        })
                        Button(action: {
                            self.source = .camera
                            self.isImagePicker.toggle()
                        }, label: {
                            Text("撮影")
                        })
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear(){
            loadImage()
        }
        .navigationBarTitle("レシピを追加", displayMode: .inline)
    }
    
    func loadImage() {
        if imageData.count != 0{
            recipeModel.imageData = imageData
            self.image = Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
        }else{
            self.image = Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "photo")!)
        }
    }
}

