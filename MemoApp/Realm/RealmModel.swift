//
//  RealmModel.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/10.
//

import Foundation
import RealmSwift

class MemoList: Object {
    
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var subContent: String
    @Persisted var favoriteStatus: Bool

    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String, date: Date, subContent: String, favoriteStatus: Bool) {
        self.init()
        
        self.title = title
        self.date = date
        self.subContent = subContent
        self.favoriteStatus = favoriteStatus
        
    }
}
