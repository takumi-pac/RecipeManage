//
//  RandamMenuView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/12/21.
//
// TODO: 入力した料理のレシピをWebで検索して表示

import SwiftUI

struct RandamMenuView: View {
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Recipe>
    @Environment(\.managedObjectContext) private var context
    @State var isShowMenu: Bool = false
    @State var isWebView: Bool = false
    @State var seachRecipeWord : String = ""
    
    var body: some View {
        
        VStack {
            Spacer()
            
            if isShowMenu == true {
                RouletteCharacters(text:randam(arr:results) , delay: 0)
                    .padding(50)
            }
            
            Button(action: {
                isShowMenu.toggle()
            }, label:  {
                Text("料理をランダムに表示")
                    .fontWeight(.semibold)
                            .frame(width: 200, height: 48)
                            .foregroundColor(Color(.white))
                            .background(Color(.orange))
                            .cornerRadius(24)
            })
            
            Spacer()
            AdmobBannerView()
                .frame(width: 320, height:50)
        }
    }
}

struct RouletteCharacters: View {
    let characters: Array<String.Element>
    let fontSize: Float = 25
    var delay: Double

    init(text: String, delay: Double){
        self.characters = Array(text)
        self.delay = delay
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing:0){
                ForEach(0..<characters.count, id: \.self) { num in
                    RouletteCharacter(characters: String(characters),
                                      finalCharacter: String(characters[num]),
                                      number: num,
                                      fontSize: fontSize,
                                      baseTime: delay)
                }
                Spacer()
            }
        }
    }
}

struct RouletteCharacter: View {
    @State var characters: Array<String.Element>
    @State var finalCharacter: String
    @State var separatedCharacter: String
    @State var timer: Timer!
    @State var number: Int
    @State var fontSize: Float
    @State var baseTime: Double
    @State var opacity: Double = 0
    var speedDuration: Double = 0.2
    
    init(characters: String, finalCharacter: String, number: Int, fontSize: Float, baseTime: Double){
        self.characters = Array(characters)
        self.finalCharacter = finalCharacter
        self.separatedCharacter = finalCharacter
        self.number = number
        self.fontSize = fontSize
        self.baseTime = baseTime
    }
    
    var body: some View {
        Text(String(separatedCharacter))
            .font(.custom("Arial", size: CGFloat(fontSize)))
            .fontWeight(.heavy)
            .foregroundColor(Color(CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)))
            .opacity(opacity)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + (baseTime / 4) + speedDuration * Double(1 + number)){
                    withAnimation(.linear(duration: 0.2)) {
                        opacity = 1
                    }
                }
                startTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + (baseTime + speedDuration * Double(1 + number))) {
                    stopTimer()
                    separatedCharacter = finalCharacter
                }
            }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05,
                                          repeats: true, block: { _ in
            // shuffle and set characters.
            separatedCharacter = String(characters[Int.random(in: 0..<characters.count)])
        })
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

func randam(arr: FetchedResults<Recipe>) -> String {
    var array: [String] = []
    if arr.count != 0 {
        for i in 0..<arr.count {
            array.append(String(arr[i].recipeName!))
        }
        return array.randomElement()!
    } else {
        return "対象のレシピがありません"
    }
}

struct RandamMenuView_Previews: PreviewProvider {
    @State static var isShow = false
    
    static var previews: some View {
        RandamMenuView()
    }
}
