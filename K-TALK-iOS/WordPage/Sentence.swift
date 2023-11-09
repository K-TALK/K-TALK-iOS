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
    
    // id가 고유 값
    override static func primaryKey() -> String? {
      return "id"
    }
}

class Quiz: Object {
    @objc dynamic var id:Int = 0
    @objc dynamic var Quiz:String = ""
    @objc dynamic var Answer1:String = ""
    @objc dynamic var Answer2:String = ""
    @objc dynamic var Answer3:String = ""
    @objc dynamic var Answer4:String = ""
    @objc dynamic var correctAnswer:String = ""
    
    // id가 고유 값
    override static func primaryKey() -> String? {
        return "id"
    }
}
