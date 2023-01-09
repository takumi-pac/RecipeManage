//
//  CalendarView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2022/11/14.
//


import SwiftUI
import UIKit
import CoreData
import FSCalendar

struct CalendarTestView: UIViewRepresentable {
    @Binding var selectedDate: String
    
    func makeUIView(context: Context) -> FSCalendar {
        
        typealias UIViewType = FSCalendar
        
        let fsCalendar = FSCalendar()
        
        fsCalendar.delegate = context.coordinator
        fsCalendar.dataSource = context.coordinator
        //カスタマイズ
        //表示
        fsCalendar.scrollDirection = .vertical //スクロールの方向
        fsCalendar.scope = .month //表示の単位（週単位 or 月単位）
        fsCalendar.locale = Locale(identifier: "ja") //表示の言語の設置（日本語表示の場合は"ja"）
        //ヘッダー
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20) //ヘッダーテキストサイズ
        fsCalendar.appearance.headerDateFormat = "yyyy/M" //ヘッダー表示のフォーマット
        fsCalendar.appearance.headerTitleColor = UIColor.label //ヘッダーテキストカラー
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0 //前月、翌月表示のアルファ量（0で非表示）
        //曜日表示
        fsCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 20) //曜日表示のテキストサイズ
        fsCalendar.appearance.weekdayTextColor = .darkGray //曜日表示のテキストカラー
        fsCalendar.appearance.titleWeekendColor = .red //週末（土、日曜の日付表示カラー）
        //カレンダー日付表示
        fsCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16) //日付のテキストサイズ
        fsCalendar.appearance.titleFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold) //日付のテキスト、ウェイトサイズ
        fsCalendar.appearance.todayColor = .clear //本日の選択カラー
        fsCalendar.appearance.titleTodayColor = .orange //本日のテキストカラー
        
        fsCalendar.appearance.selectionColor = .clear //選択した日付のカラー
        fsCalendar.appearance.borderSelectionColor = .blue //選択した日付のボーダーカラー
        fsCalendar.appearance.titleSelectionColor = .black //選択した日付のテキストカラー
        
        fsCalendar.appearance.borderRadius = 0 //本日・選択日の塗りつぶし角丸量
        
        return fsCalendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator{
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarTestView
        var datesWithEvents: Set<String> = []
        var eventsFlg: Bool = false
        let formatter = DateFormatter()
        
        init(_ parent:CalendarTestView){
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

            let tmpDate = Calendar(identifier: .gregorian)
            let year = tmpDate.component(.year, from: date)
            let month = tmpDate.component(.month, from: date)
            let day = tmpDate.component(.day, from: date)
            parent.selectedDate = "\(year)/\(month)/\(day)"

        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            formatter.dateFormat = "yyyy/M/d"
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            
            if eventsFlg == false {
                getAllData()
                eventsFlg.toggle()
            }
            
            if datesWithEvents.contains(formatter.string(from: date)) {
                return 1
            } else {
                return 0
            }
            
        }
        
        func getAllData() -> Void {
            let persistenceController = PersistenceController.shared
            let context = persistenceController.container.viewContext
            
            let recipeModel = RecipeViewModel()
            let request = NSFetchRequest<Recipe>(entityName: "Recipe")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                let recipe = try context.fetch(request)
                
                if recipeModel.isNewData == true {
                    self.eventsFlg = false
                }
                
                if recipe.count > 0 {
                    for i in 0..<recipe.count {
                        if i == 0 {
                            datesWithEvents = [formatter.string(from:recipe[i].date!)]
                        } else {
                            datesWithEvents.insert(formatter.string(from:recipe[i].date!))
                        }
                        print(datesWithEvents)
                    }
                } else {
                    datesWithEvents = []
                }
                
            }
            catch {
                fatalError()
            }
        }
        
    }
}

struct CalendarView: View {
    @State var selectedDate = String()
    @ObservedObject var recipeModel = RecipeViewModel()
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)],animation: .spring()) var results : FetchedResults<Recipe>
    @Environment(\.managedObjectContext) private var context
    let formatter = DateFormatter()
    
    var body: some View {
        VStack {
            CalendarTestView(selectedDate: $selectedDate)
                .frame(height: 400)
            
            Text(selectedDate)
                .font(.title)
                .padding()
            
            ScrollView(.vertical,showsIndicators: false, content:{
                LazyVStack(alignment: .leading, spacing: 20){
                    ForEach(results){ recipe in
                        if selectedDate == Format(recipeDate: recipe.date!) {
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
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                Divider()
                                
                                Text("材料")
                                Text(recipe.cuisine ?? "")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                            })
                        } // IF
                    }// FOREACH
                } // LAZYVSTACK
            }) // SCROLL VIEW
        }
    }
}

func Format(recipeDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/M/d"
    let tempDate = formatter.string(for: recipeDate)
    return tempDate!
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
