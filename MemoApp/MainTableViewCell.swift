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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }



}
