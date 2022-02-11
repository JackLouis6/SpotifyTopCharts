//
//  ContentView.swift
//  SpotifyTopCharts
//
//  Created by Student on 2/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var songs = [Song]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(songs) { song in
                if let url = URL(string: song.track_url) {
                    Link(destination: url) {
                    HStack {
                        Text(song.position)
                        Text("-")
                        Text(song.track_title)
                        Text("Streams:")
                        Text(song.streams)
                        }
                    }
                }
            }
            .navigationTitle("Spotify Top Charts")
        }
        .onAppear(perform: {
            getSongs()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the Songs"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func getSongs() {
        let apiKey = "rapidapi-key=11e76f41famsh4a8f4c04d83db94p14e066jsndbc159a476f9"
        let query = "https://spotfiy-charts.p.rapidapi.com/?type=regional&country=global&recurrence=daily&date=latest&\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["response"] == "success" {
                    let contents = json["content"].arrayValue
                    for item in contents {
                        let position = item["position"].stringValue
                        let track_title = item["track_title"].stringValue
                        let track_url = item["track_url"].stringValue
                        let streams = item["streams"].stringValue
                        let song = Song(position: position, track_title: track_title, track_url: track_url, streams: streams)
                        songs.append(song)
                    }
                    return
                }
            }
        }
        showingAlert = true
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
    var track_url: String
    var streams: String
    
}
