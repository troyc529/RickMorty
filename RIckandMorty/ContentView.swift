//
//  ContentView.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
        RMCharacterView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
