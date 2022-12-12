//
//  RMCharacterRow.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/15/22.
//


import SwiftUI

struct RMCharacterRow: View {
   var character: RMCharacter
   @State var image: UIImage?
   
   var body: some View {
       
       HStack {
           
           if let image = image{
               Image(uiImage: image)
                   .resizable()
                   .frame(width: 20, height: 20, alignment: .leading)
               Text(character.name).bold()
               
           }
           else{
               Image(systemName: "person.fill")
               Text(character.name).bold()
           }
       }
       
       .onAppear{
           if image == nil {
               NetworkService.loadImage(URL(string: character.image)!) { _image  in
                   DispatchQueue.main.async {
                      image = _image
                   }
                   
               }
           }
       }
   }
}


