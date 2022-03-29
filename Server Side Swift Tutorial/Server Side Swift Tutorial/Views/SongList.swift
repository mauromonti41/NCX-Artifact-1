//
//  ContentView.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 24/03/22.
//

import SwiftUI

struct SongList: View {
    
    @StateObject var viewModel = SongListViewModel()
    @State var modal: Modaltype? = nil
    
    var body: some View {
        NavigationView{
            List{
                ForEach(viewModel.songs){song in
                    Button{
                        modal = .update(song)
                    }label: {
                        Text(song.title)
                            .font(.title3)
                            .foregroundColor(Color(.label))
                    }
                }.onDelete(perform: viewModel.deleteSong)
            }.navigationTitle(Text("Songs"))
                .toolbar{
                    Button{
                        modal = .add
                    }label :{
                        Label("Add Song", systemImage: "plus.circle")
                    }
                }
        }
        .sheet(item: $modal,
               onDismiss: {
            Task{
                do{
                    try await viewModel.fetchSongs()
                }
                catch{
                    print("ERROR: \(error)")
                }
            }
        }
        ){
            modal in
            switch modal{
            case .add:
                AddUpdateSong(viewModel: AddUpdateSongViewModel())
            case .update(let song):
               AddUpdateSong(viewModel: AddUpdateSongViewModel(currentSong: song))
            }
        }
        .onAppear {
            Task{
                do{
                try await viewModel.fetchSongs()
                }
                catch{
                    print("ERROR : \(error)")
                }
            }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongList()
    }
}
