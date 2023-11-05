//
//  ContentView.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 22.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection)
        {
            NewsView()
                .tag(1)
            
            SearchView()
                .tag(2)
            
            SettingsView()
                .tag(3)
        } //: TabView
        .overlay(alignment: .bottom) {
            CustomTabView(tabSelection: $tabSelection)
        }
    }
}

#Preview {
    ContentView()
}
