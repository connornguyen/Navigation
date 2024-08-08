//
//  ContentView.swift
//  Navigation
//
//  Created by Apple on 06/08/2024.
//

import SwiftUI


//Hashable because UUID, string and Int is comform to hashable
struct Student: Hashable {
    var id = UUID()
    var name: String
    var age: Int
}

struct DetailView: View {
    
    var number: Int
    @Binding var path: NavigationPath
    
    
    var body: some View {
        NavigationLink("Go to random number", value: Int.random(in: 0...1000))
            .navigationTitle("Number \(number)")
    }
}


struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            DetailView(number: 0 ,path: $path)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i, path: $path)
                }
        }
    }
}

#Preview {
    ContentView()
}
