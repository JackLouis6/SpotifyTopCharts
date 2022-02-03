//
//  ContentView.swift
//  SpotifyTopCharts
//
//  Created by Student on 2/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var songs = [Song]()
    
    var body: some View {
     
        NavigationView {
                    List(songs) { song in
                        NavigationLink(
                            destination: Text(song.position)
                                .padding(),
                            label: {
                                Text(song.track_title)
                                Text(song.artists)
                                Text(song.streams)
                            })
                    }
                    .navigationTitle("Spotify Top Charts")
                }
        .onAppear(perform: {
                    getSongs()
                })
    }
    
    func getSongs() {
            let apiKey = "rapidapi-key=11e76f41famsh4a8f4c04d83db94p14e066jsndbc159a476f9"
            let query = "https://spotfiy-charts.p.rapidapi.com/?type=regional&country=global&recurrence=daily&date=latest&\(apiKey)"
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["success"] == true {
                        let contents = json["body"].arrayValue
                        for item in contents {
                            let position = item["sposition"].stringValue
                            let track_title = item["track_title"].stringValue
                            let artists = item["artists"].stringValue
                            let streams = item["streams"].stringValue
                            let song = Song(position: position, track_title: track_title, artists: artists, streams: streams)
                            songs.append(song)
                        }
                    }
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Song: Identifiable {
    let id = UUID()
    var position: String
    var track_title: String
    var artists: String
    var streams: String
    
}
