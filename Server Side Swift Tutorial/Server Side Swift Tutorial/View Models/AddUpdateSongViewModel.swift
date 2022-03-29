//
//  AddUpdateSongViewModel.swift
//  Server Side Swift Tutorial
//
//  Created by Mauro Monti on 25/03/22.
//

import Foundation


final class AddUpdateSongViewModel : ObservableObject{
    
    @Published var songTitle = ""
    
    var songID: UUID?
    
    var isUpdating: Bool{
        songID != nil
    }
    
    var buttonTitle: String{
        songID != nil ? "Update Song" : "Add Song"
    }
//    This is a void initializer used in case any song is selected or updated
//    the properties will take the default value
    init(){}
//    This is an initializer in case we select a song or we are updating one
    init(currentSong : Song){
        self.songTitle = currentSong.title
        self.songID = currentSong.id
    }
    
    func addSong() async throws{
        let urlString = Constants.baseURL + EndPoints.songs
        
        guard let url = URL(string: urlString) else{
            throw HttpError.badURL
        }
        let song = Song(id: nil, title: songTitle)
        
        try await HttpClient.shared.sendData(to: url, object: song, httpMethod: HttpMethods.POST.rawValue)
    }
    
    func addUpdateAction(completion: @escaping () -> Void){
        Task{
            do{
            if isUpdating{
                        try await updateSong()
                
            }
            else{
               try await addSong()
            }
        }
            catch{
                print("ERROR: \(error)")
            }
            completion()
//            we add a completion since we have to wait that the add or update action finishes
    }
}
    func updateSong() async throws{
        let urlString = Constants.baseURL + EndPoints.songs
        guard let url = URL(string: urlString) else{
            throw HttpError.badURL
        }
        let songToUpdate = Song(id: songID, title: songTitle)
        try await HttpClient.shared.sendData(to: url, object: songToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
    

}
