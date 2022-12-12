//
//  RMCharacterViewModel.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//

import Foundation
import SwiftUI
import Combine

class RMCharacterViewModel: ObservableObject {
   
   @Published var characters: [RMCharacter] = [RMCharacter]()
   @Published var charactersWithImages: [(RMCharacter, UIImage?)]  = [(RMCharacter, UIImage?)]()

   @Published var display: [(RMCharacter, UIImage)] = [(RMCharacter, UIImage)]()
   @Published var searchText = ""
   
   @Published var ascending = false
   @Published var descending = false
   @Published var episodeCountFilter = false
   @Published var alive = false
   @Published var notAlive = false
   private var cancellables = Set<AnyCancellable>()
   
   enum State{
       case loading
       case finished
       case na
   }
   
   private(set) var state : State = .na
   
   
   init() {
       
       
       self.state = .loading
      
       self.fetchCharacterData {
           chars in
           self.getImagesForCharacters(chars) { res in
               DispatchQueue.main.async {
                   self.charactersWithImages = res
                  // self.display = self.charactersWithImages
                   self.state = .finished
               }
           }
       }
      
       
       
       
   }
   
   
 
   
   func fetchCharacterData(completion: @escaping([RMCharacter]) -> Void) {
       
        var string = "[1"
       
       for i in 2...200 {
           string += ",\(i)"
       }
       string += "]"
       
       NetworkService.getData(URL(string: "https://rickandmortyapi.com/api/character/\(string)")!) { data in
           
           if let data = data {
               NetworkService.decodeData([RMCharacter].self, data) { model in
                   print(" AMOUNT OF CHARACTERS ! \(model?.count)")
                   if let model = model{
                       completion(model)
                       return
                       
                   }
                   else{
                       completion([RMCharacter]())
                       return
                   }
               }
           }
           
           else{
               completion([RMCharacter]())
               return
           }
       }
       
   }
   
   
   func getImagesForCharacters(_ chars: [RMCharacter], completion: @escaping([(RMCharacter, UIImage?)]) -> Void ){
       
       var res = [(RMCharacter, UIImage?)]()
       var _dispatchGroup = DispatchGroup()
       
       //let semaphore = DispatchSemaphore(value: 0)
       DispatchQueue.global(qos: .userInitiated).async {
           for i in chars {
               print("INDEX \(i.id)")
               _dispatchGroup.enter()
               NetworkService.loadImage(URL(string: i.image)!, completion: {
                   _image in
                   
                   if let _image = _image{
                       res.append((i, _image))
                       print(Thread.current)
                       _dispatchGroup.leave()
                       //semaphore.signal()
                   }
                   else{
                       print("got a nil image! ")
                       //semaphore.signal()
                       res.append((i, nil))
                       _dispatchGroup.leave()
                   }
                   
               })
              // semaphore.wait()
               
           }
           _dispatchGroup.wait()
           print("I AM DONE WITH TASKS!")
           completion(res)
           return
          
       }
   }

   
   func filterSearch() -> [(RMCharacter, UIImage?)] {
       
       self.state = .loading
       
       if !episodeCountFilter && !alive && !notAlive{
           if searchText.isEmpty {
               self.state = .finished
               return charactersWithImages
           }
           self.state = .finished
           return charactersWithImages.filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
       }
       
       else if alive && !notAlive && episodeCountFilter && descending && !ascending {
           if searchText.isEmpty{
               self.state = .finished
               return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
                   .filter({$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText) && $0.0.isAlive()})
       }
       else if notAlive && !alive && episodeCountFilter && descending && !ascending {
           if searchText.isEmpty{
               self.state = .finished
               return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
                   .filter({!$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText) && !$0.0.isAlive()})
       }
       
       else if notAlive && !alive && episodeCountFilter && ascending && !descending {
           if searchText.isEmpty{
               self.state = .finished
               return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
                   .filter({!$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText) && !$0.0.isAlive()})
       }
       else if alive && !notAlive && episodeCountFilter && ascending && !descending {
           if searchText.isEmpty{
               self.state = .finished
               return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
                   .filter({$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText) && $0.0.isAlive()})
       }
       else if episodeCountFilter && descending && !ascending {
           if searchText.isEmpty{
               self.state = .finished
               return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
           }
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() > $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
       }
       
      else if episodeCountFilter && ascending && !descending  {
          if searchText.isEmpty{
              self.state = .finished
              return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
          }
          self.state = .finished
           return charactersWithImages.sorted(by: {$0.0.getNumEpisodes() < $1.0.getNumEpisodes() })
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
       }
       
       else if alive && !notAlive{
           if searchText.isEmpty {
               self.state = .finished
               return charactersWithImages.filter({$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.filter({!$0.0.isAlive()})
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
       }
       else if notAlive && !alive{
           
           if searchText.isEmpty {
               self.state = .finished
               return charactersWithImages.filter({!$0.0.isAlive()})
           }
           self.state = .finished
           return charactersWithImages.filter({!$0.0.isAlive()})
               .filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
           
       }
       
       if searchText.isEmpty {
           self.state = .finished
           return charactersWithImages
       }
       self.state = .finished
       return charactersWithImages.filter({$0.0.name.localizedCaseInsensitiveContains(searchText)})
   }
   
}



