//
//  MainTableViewCell.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/08.
//

import UIKit
import RealmSwift

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    let localRealm = try! Realm()
    var memoList: Results<MemoList>!
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoDateLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    
    func cellconfiguration(row: MemoList) {
        
        memoTitleLabel.text = row.title
        memoTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        memoDateLabel.text = row.date
        memoDateLabel.textColor = .systemGray2
        
        //빈값일 때 표시
        if row.subContent != "" {
            memoContentLabel.text = row.subContent
        } else {
            memoContentLabel.text = "추가 텍스트 없음"
        }
        memoContentLabel.textColor = .systemGray2
        
    }



}
