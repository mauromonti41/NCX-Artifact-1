//
//  SongListViewModel.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 24/03/22.
//

import Foundation
import SwiftUI

class SongListViewModel : ObservableObject{
    
    @Published var songs = [Song]()
    
    func fetchSongs() async throws{
        
        let urlString = Constants.baseURL + EndPoints.songs
        
        guard let url = URL(string: urlString) else{
            throw HttpError.badURL
        }
        
        let songResponse : [Song] = try await HttpClient.shared.fetch(url: url)
        
        //        Here it is important to let the refresh of the fetched songs on the main thread because it is strictly related to the UI and so it has to be refreshed before than other elements
        DispatchQueue.main.async{
            self.songs = songResponse
        }
    }
    
    func deleteSong (at offsets : IndexSet){
        offsets.forEach{i in
            guard let songID = songs[i].id else{
                return
            }
            guard let url = URL(string: Constants.baseURL + EndPoints.songs + "/\(songID)") else{
                return
            }
            Task{
                do{
                    try await HttpClient.shared.delete(at: songID, url: url)
                }
                catch{
                    print("ERROR: \(error)")
                }
            }
        }
        songs.remove(atOffsets: offsets)
    }
}
