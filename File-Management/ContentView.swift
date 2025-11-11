//
//  ContentView.swift
//  File-Management
//
//  Created by Mason Kimball on 11/11/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            createFile()
        }
    }
}

#Preview {
    ContentView()
}
