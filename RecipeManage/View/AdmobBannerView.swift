//
//  AdmobBannerView.swift
//  RecipeManage
//
//  Created by 松田拓海 on 2023/01/10.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct AdmobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let banner = GADBannerView(adSize: GADAdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = "ca-app-pub-8659152615389502/4042260163" // 自身の広告IDに置き換える
        banner.rootViewController = window!.rootViewController
        banner.load(GADRequest())
        return banner // 最終的にインスタンスを返す
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // 特にないのでメソッドだけ用意
    }
}

struct AdmobBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdmobBannerView()
    }
}
