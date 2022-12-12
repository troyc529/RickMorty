//
//  RMCharacterDetailedView.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//

import SwiftUI

struct RMCharacterDetailedView: View {
    var character: RMCharacter
    @State var image: UIImage?
    var body: some View {
        VStack{
            HStack{
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                }else{
                    Image(systemName: "person.fill")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                }
                
            }
            Text(character.name).bold()
            Text(character.species).font(.caption2)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear{
            if image == nil {
                NetworkService.loadImage(URL(string: character.image)!, completion: {
                    _image in
                    image = _image
                })
            }
        }
    }
    
        
}


