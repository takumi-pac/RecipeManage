//
//  AddPickerView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2023/01/22.
//

import SwiftUI

struct AddPickerView: View {
    @Environment(\.managedObjectContext) var context
    @State var pickerList: [String] = ["洋食","和食"]
    @State var addPicker: String = ""
    @Binding var isShowScreen: Bool
    @FocusState private var focus: Bool
    
    
    var userDefaults = UserDefaults.standard
    
//    init() {
//        pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? []
//    }
    
    var body: some View {
        
        VStack {
            HStack{
                Button("閉じる") {
                    isShowScreen.toggle()
                }
                .padding()
                
                Spacer()
            }
            
            TextField("追加", text: $addPicker) 
                .padding()
                .background(Color.primary.opacity(0.1))
                .cornerRadius(20)
                .frame(width: 400)
                .focused($focus)
            
            Button("カテゴリを追加"){
                pickerList.append(addPicker)
                userDefaults.set(pickerList, forKey: "pickerList")
                addPicker = ""
                
            } //Button
            
            List {
                ForEach(0..<pickerList.count, id: \.self) { index in
                    Text(pickerList[index])
                }
                .onDelete { (offsets) in
                    pickerList.remove(atOffsets: offsets)
                    userDefaults.set(pickerList, forKey: "pickerList")
                }
            }
            .frame(height:300)
            
            
        } //VStack
        .onAppear{
            pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? []
        }
        .onTapGesture {
            focus = false
        }
        
    }
    
}

struct AddPickerView_Previews: PreviewProvider {
    @State static var isShowScreen = true
    
    static var previews: some View {
        AddPickerView(isShowScreen: $isShowScreen)
            .previewLayout(.sizeThatFits)
    }
}
