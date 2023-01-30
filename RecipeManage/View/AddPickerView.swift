//
//  AddPickerView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2023/01/22.
//

import SwiftUI

struct AddPickerView: View {
    @Environment(\.managedObjectContext) var context
    @State var pickerList: [String] = ["洋食","和食","中華","軽食"]
    @State var addPicker: String = ""
    @Binding var isShowScreen: Bool
    @FocusState private var focus: Bool
    
    
    var userDefaults = UserDefaults.standard
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                Button("閉じる") {
                    isShowScreen = false
                }
                .padding()
                .foregroundColor(.orange)
                
                Spacer()
            }
            
            TextField("追加", text: $addPicker) 
                .padding()
                .background(Color.primary.opacity(0.1))
                .cornerRadius(20)
                .frame(width: 400)
                .focused($focus)
            
            Button("追加"){
                pickerList.append(addPicker)
                userDefaults.set(pickerList, forKey: "pickerList")
                addPicker = ""
                print(pickerList)
            } //Button
            .foregroundColor(.white)
            .frame(width:UIScreen.main.bounds.width - 300,height: 45)
            .background(Color.orange)
            .cornerRadius(15)
            
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
            pickerList = userDefaults.array(forKey: "pickerList") as? [String] ?? ["洋食","和食","中華","軽食"]
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
