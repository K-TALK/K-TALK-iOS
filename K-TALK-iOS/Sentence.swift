//
//  Sentence.swift
//  K-TALK-iOS
//
//  Created by JungGue LEE on 2023/11/02.
//

import Foundation
import RealmSwift


class Sentence: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var sentence:String = ""
    
    // id 가 고유 값입니다.
    override static func primaryKey() -> String? {
      return "id"
    }
}
