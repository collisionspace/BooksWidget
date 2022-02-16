//
//  ContentView.swift
//  Books
//
//  Created by Daniel Slone on 15/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                BooksFetchWorker().fetchBooks(subject: .horror) { result in
                    
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
