//
//  RecipeListView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/08.
//

import SwiftUI

struct RecipeListView: View {
    
    init(){
        UITextView.appearance().backgroundColor = .clear
    }
    @StateObject var recipeModel = RecipeViewModel()
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Recipe>
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
            NavigationView{
                VStack(spacing:0){
                    if results.isEmpty{
                        Spacer()
                        Text("メニューがありません")
                            .font(.title)
                            .foregroundColor(.primary)
                            .fontWeight(.heavy)
                        Spacer()
                    }else{
                        
                        ScrollView(.vertical,showsIndicators: false, content:{
                            LazyVStack(alignment: .leading, spacing: 20){
                                ForEach(results){ recipe in
                                    VStack(alignment: .leading, spacing: 5, content: {
                                        HStack{
                                            if recipe.imageData?.count ?? 0 != 0{
                                                Image(uiImage: UIImage(data: recipe.imageData ?? Data.init())!)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(10)
                                            }
                                            VStack{
                                                Text(recipe.date ?? Date(),style: .date)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                        Text("料理名")
                                        Text(recipe.recipeName ?? "")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                        Divider()
                                        
                                        Text("料理ジャンル")
                                        Text(recipe.cuisine ?? "")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                    })
                                    .foregroundColor(.primary)
                                    .contextMenu{
                                        Button(action: {
                                            recipeModel.EditItem(item: recipe)
                                        }, label: {
                                            Text("編集")
                                        })
                                        Button(action: {
                                            context.delete(recipe)
                                            try! context.save()
                                        }, label: {
                                            Text("削除")
                                        })
                                    }
                                }
                            }
                            .padding()
                        })
                    }
                    Spacer()
                    
                    AdmobBannerView()
                        .frame(width: 320, height:50)
                }
                .navigationBarTitle("Home", displayMode: .inline)
            }
            Button(action: {recipeModel.isNewData.toggle()}, label: {
                Image(systemName: "pencil")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .padding()
            })
        })
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.primary.opacity(0.06).ignoresSafeArea(.all, edges: .all))
        .sheet(isPresented: $recipeModel.isNewData,
               onDismiss:{
            viewModelValueReset()
        },
               content: {
            NewDataSheet(recipeModel: recipeModel)
        })
    }
    
    func viewModelValueReset() {
        recipeModel.updateItem = nil
        recipeModel.recipeName = ""
        recipeModel.cuisine = ""
        recipeModel.date = Date()
        recipeModel.imageData = Data.init()
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
