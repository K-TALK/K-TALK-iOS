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
    //    do {
    let realm = try! Realm()
    let results = realm.objects(SampleData.self)
    //        let data : [Sdata?] = results.compactMap {
    //            sampleData in
    //            guard !sampleData.num.isEmpty,
    //                  !sampleData.wordname.isEmpty,
    //                  !sampleData.homonym.isEmpty,
    //                  !sampleData.polysemy.isEmpty,
    //                  !sampleData.example.isEmpty,
    //                  !sampleData.wordmean.isEmpty
    //            else{
    //                return nil
    //            }
    //            return SampleData(num: sampleData.num, wordname: sampleData.wordname, homonym: sampleData.homonym, polysemy: sampleData.polysemy, example: sampleData.example, wordmean: sampleData.wordmean)
    //        }
    
    //
    for sampleData in results {
        print("Name: \(sampleData.wordname)")
        print("Homonym: \(sampleData.homonym)")
        print("Polysemy: \(sampleData.polysemy)")
        print("Example: \(sampleData.example)")
        print("Word Mean: \(sampleData.wordmean)")
    }
//    catch {
//        print("Error querying data from Realm: \(error.localizedDescription)")
//    }
    //    }catch {
    //        print("Error querying data from Realm: \(error.localizedDescription)")
    //    }
}
// 사용 예제


