//
//  Song.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/28/23.
//

import Foundation

struct SongCreationEndpointResponse: Codable {
    let song: Song
}

struct Song: Codable {
    let title: String
    let bpm: Int
    let emotion: String
    let language: String
    let genre: String
    let subject: String
    let paragraphs: [SongParagraph]
    let request: String
    let response: String
}

struct SongParagraph: Codable, Identifiable {
    let title: String
    let phrases: [SongPhrase]
    let id = UUID()

    enum CodingKeys: CodingKey {
        case title
        case phrases
    }
}

struct SongPhrase: Codable, Identifiable {
    let text: String
    let chords: [String]
    let id = UUID()

    enum CodingKeys: CodingKey {
        case text
        case chords
    }
}

extension Song {
    var formattedBPM: String {
        "\(bpm) BPM"
    }

    static var testValue: Song {
        let phrase1 = SongPhrase(text: "This is a phrase", chords: ["Am", "G"])
        let phrase2 = SongPhrase(text: "This is another phrase", chords: ["Gm", "C"])
        let phrase3 = SongPhrase(text: "This is a phrase", chords: ["Am", "G"])
        let phrase4 = SongPhrase(text: "This is another phrase", chords: ["Gm", "C"])
        let songParagraph1 = SongParagraph(title: "Verse 1", phrases: [phrase1, phrase2])
        let songParagraph2 = SongParagraph(title: "Verse 2", phrases: [phrase3, phrase4])
        return Song(
            title: "Test Song",
            bpm: 160,
            emotion: "joy",
            language: "english",
            genre: "reggae",
            subject: "love",
            paragraphs: [songParagraph1, songParagraph2],
            request: "",
            response: "")
    }
}
