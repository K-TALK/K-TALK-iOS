//
//  SampleRealm.swift
//  K-TALK-iOS
//
//  Created by 박세인 on 2023/10/30.
//

import Foundation
import RealmSwift
class readJson{
    func readJson() {
        if let path = Bundle.main.path(forResource: "동음이의어,다의어", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]

                for item in jsonArray {
                    let sampleData = SampleData()
                    sampleData.homonym = item["homonym"] as? String ?? ""
                    sampleData.polysemy = item["polysemy"] as? String ?? ""
                    sampleData.example = item["example"] as? String ?? ""
                    sampleData.wordmean = item["wordmean"] as? String ?? ""

                    // Realm에 저장
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(sampleData)
                        }
                    } catch {
                        print("Error saving data to Realm: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error reading JSON file: \(error.localizedDescription)")
            }
        }
    }
}


class SampleData: Object{
    @Persisted(primaryKey: true) var name: String = UUID().uuidString
    @Persisted var homonym: String = ""
    @Persisted var polysemy: String = ""
    @Persisted var example: String = ""
    @Persisted var wordmean: String = ""
}




