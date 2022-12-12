//
//  RMCharacterView.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//
import SwiftUI

struct RMCharacterView: View {
    @ObservedObject var vm = RMCharacterViewModel()
    
    
    var body: some View {
       
            VStack{
                if vm.state == .loading{
                    ProgressView().tint(Color.red)
                    
                }
                else if vm.state == .finished {
                    VStack {
                        Text("Filters")
                        HStack{
                            Button("Episode Count"){
                                vm.episodeCountFilter.toggle()
                            }.background(vm.episodeCountFilter ? Color.green : Color.gray)
                            
                            if vm.episodeCountFilter {
                                Button("Ascending"){
                                    vm.ascending.toggle()
                                    vm.descending = false
                                }.background(vm.ascending ? Color.green : Color.gray)
                                Button("Descending"){
                                    vm.descending.toggle()
                                    vm.ascending = false
                                }.background(vm.descending ? Color.green : Color.gray)
                            }
                            
                            Button("Alive"){
                                vm.alive.toggle()
                                vm.notAlive = false
                            }.background(vm.alive ? Color.green : Color.gray)
                            Button("Not alive"){
                                vm.notAlive.toggle()
                                vm.alive = false
                            }.background(vm.notAlive ? Color.green : Color.gray)
                            }
                            
                    }
                    
                    if vm.charactersWithImages.count > 0 {
                        HStack {
                            Image(systemName: "magnifyingglass").padding(4)
                            TextField("Search", text: $vm.searchText)
                        }
                    List {
                        ForEach(vm.filterSearch(), id: \.0.id){ char, image in
                            NavigationLink{
                                RMCharacterDetailedView(character: char, image: image)
                            }label:{
                                RMCharacterRow(character: char, image: image)
                            }
                            
                            
                            
                        }
                        .onMove(perform: move)
                       
                    }
                        Text("\(vm.filterSearch().count) results").font(.callout)
                }
                
            }
        }
        
        
        
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        vm.charactersWithImages.move(fromOffsets: source, toOffset: destination)
        }
}

struct RMCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        RMCharacterView()
    }
}


