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

        memoDateLabel.text = dateFormatting(date: row.date)
        memoDateLabel.textColor = .systemGray2
        
        //빈값일 때 표시
        if row.subContent != "" {
            memoContentLabel.text = row.subContent
        } else {
            memoContentLabel.text = "추가 텍스트 없음"
        }
        memoContentLabel.textColor = .systemGray2
        
    }
    
    func dateFormatting(date: Date) -> String {
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
          dateFormatter.dateFormat = "a HH:mm"
        } else if date >= Date(timeIntervalSinceNow: 60 * 60 * 24 * -7) {
          dateFormatter.dateFormat = "EEEE"
        } else {
          dateFormatter.dateFormat = "yyyy. MM. dd. a hh:mm"
        }
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter.string(from: date)
        
    }



}
