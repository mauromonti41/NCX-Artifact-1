//
//  AddUpdateSong.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 25/03/22.
//

import SwiftUI

struct AddUpdateSong: View {
    @StateObject var viewModel : AddUpdateSongViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            TextField("song title", text: $viewModel.songTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button{
                viewModel.addUpdateAction{
                    presentationMode.wrappedValue.dismiss()
                }
            }label: {
                Text(viewModel.buttonTitle)
            }
    }
}
}

struct AddUpdateSong_Previews: PreviewProvider {
    static var previews: some View {
        AddUpdateSong(viewModel: AddUpdateSongViewModel())
    }
}
