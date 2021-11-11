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
        
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        
        let dateStr = row.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let convertDate = dateFormatter.date(from: dateStr)
        
        let mydateFormatter = DateFormatter()
        mydateFormatter.dateFormat = "a hh:mm"
        let convertStr = mydateFormatter.string(from: convertDate!)
        
        
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
