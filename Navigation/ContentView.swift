//
//  ContentView.swift
//  Navigation
//
//  Created by Apple on 06/08/2024.
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath {
        didSet {
            save()
        }
    }
    //This is create a link, or a URL to savePath, with the path named "savePath"
    private let savePath = URL.documentsDirectory.appending(path: "savePath")
    
    init() {
        //this is when getting data from savePath
        if let data = try? Data(contentsOf: savePath) {
            //This is to decode the data from above
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        //still not return? -> Empty Path
        path = NavigationPath()
    }
    
    func save() {
        // THis is to test if in the path there is anything that not codable. And return out the codable array
        guard let representation = path.codable else { return }
        
        do {
            //This to try encode
            let data = try? JSONEncoder().encode(representation)
            //This try to write data to savePath
            try data?.write(to: savePath)
        } catch {
            print("Could not save to savePath")
        }
    }
    
}


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
    
    //Pass the class PathStore to pathStore
    @State private var pathStore = PathStore()
    @State private var tittle = "SwiftUI"
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailView(number: 0 ,path: $pathStore.path)
                .navigationDestination(for: Int.self) { i in
                    DetailView(number: i, path: $pathStore.path)
                }
                .navigationTitle($tittle)
                .navigationBarTitleDisplayMode(.inline)
                
        }
        
        
    }
}

#Preview {
    ContentView()
}
