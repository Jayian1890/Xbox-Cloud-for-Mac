//
//  ContentView.swift
//  xCloud
//
//  Created by Jared T on 2/5/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    private var url: URL? = URL(string: "https://www.xbox.com/play")
    
    var body: some View {
        WebView(data: WebViewData(url: self.url!))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
