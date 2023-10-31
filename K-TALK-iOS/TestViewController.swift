//
//  TestViewController.swift
//  K-TALK-iOS
//
//  Created by 박세인 on 2023/10/30.
//

import Foundation
import UIKit
import RealmSwift

class TestViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonData = readJson()
        jsonData.readJson()
        queryRealmData()
    }
    
   
    
}
// Realm 데이터베이스에서 SampleData 객체를 검색
func queryRealmData() {
    do {
        let realm = try Realm()
        let results = realm.objects(SampleData.self)

        for sampleData in results {
            print("Name: \(sampleData.name)")
            print("Homonym: \(sampleData.homonym)")
            print("Polysemy: \(sampleData.polysemy)")
            print("Example: \(sampleData.example)")
            print("Word Mean: \(sampleData.wordmean)")
        }
    } catch {
        print("Error querying data from Realm: \(error.localizedDescription)")
    }
}

// 사용 예제


