//
//  CameraView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var recipeModel: RecipeViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var imageData : Data
    @Binding var source: UIImagePickerController.SourceType
    
    var image = UIImage(systemName: "photo")
    
    @Binding var isActionSheet: Bool
    @Binding var isImagePicker: Bool
    
    
    var body: some View {
        
        VStack(spacing:0){
            ZStack{
                VStack{
                    HStack {
                        Spacer()
                        
                        if let data = imageData {
                            Image(uiImage: (UIImage(data: data) ?? image)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            self.source = .photoLibrary
                            self.isImagePicker.toggle()
                        }, label: {
                            Text("フォルダから選択")
                                .foregroundColor(.orange)
                        })
                        .padding()
                        
                        Button(action: {
                            self.source = .camera
                            self.isImagePicker.toggle()
                        }, label: {
                            Image(systemName: "camera")
                                .foregroundColor(.orange)
                        })
                        .padding()
                        
                        Spacer()
                    } //HSTACk
                    .padding()
                } //VSTACK
                .sheet(isPresented: $isImagePicker) {
                    ImagePicker(sourceType: self.source, image: self.$imageData)
                }
            }
        }
        .navigationBarTitle("レシピを追加", displayMode: .inline)
        
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var image: Data
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                var data = uiImage.pngData()
                parent.image = data!
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
