//
//  ContentView.swift
//  CineBrowse
//
//  Created by Faraz Amjad on 22.02.26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        HomeView(isDarkMode: $isDarkMode)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .animation(.easeInOut(duration: 0.3), value: isDarkMode)
    }
}

#Preview {
    ContentView()
}
