//
//  wordData.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/07.
//

import Foundation

struct WordData: Codable {
    let 번호: Int
    let 단어: String
    let 동음이의어: String
    let 다의어: String
    let 예시: String
    let 의미: String
}

func loadWordDataFromJSON() -> [WordData] {
    if let path = Bundle.main.path(forResource: "동음이의어,다의어", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let wordData = try JSONDecoder().decode([WordData].self, from: data)
            return wordData
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    return []
}
