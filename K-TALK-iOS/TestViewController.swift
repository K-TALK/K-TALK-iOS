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
        wordClassfication()
    }
    
   
    
}
// Realm 데이터베이스에서 SampleData 객체를 검색
func wordClassfication() {
    //    do {
    let realm = try! Realm()
    let results = realm.objects(SampleData.self)
    
    do {
            let realm = try Realm()
            let results = realm.objects(SampleData.self)

            // "~다"로 끝나는 단어 필터링
            let endsWith = results.filter { sampleData in
                return sampleData.wordname.hasSuffix("다")
            }

            // "~다"로 끝나지 않는 단어 필터링
            let doesNotEndWith = results.filter { sampleData in
                return !sampleData.wordname.hasSuffix("다")
            }

            // 결과 출력
            print("Words that end with '다':")
            for sampleData in endsWith {
                print("단어: \(sampleData.wordname)")
            }

            print("\nWords that do not end with '다':")
            for sampleData in doesNotEndWith {
                print("단어: \(sampleData.wordname)")
            }
        } catch {
            print("Error querying data from Realm: \(error.localizedDescription)")
        }
}
// 사용 예제


