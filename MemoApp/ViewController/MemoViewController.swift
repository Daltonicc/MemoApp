//
//  MemoViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/10.
//

import UIKit
import RealmSwift

class MemoViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    let localRealm = try! Realm()
    var memoList: Results<MemoList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        
        navigationItemSetting()
        
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        memoTextView.backgroundColor = .black

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //키보드 바로 띄워주기
        memoTextView.becomeFirstResponder()
    }
     
    func navigationItemSetting() {
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
        
        navigationItem.rightBarButtonItems = [finishButton, shareButton]
        
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func finishButtonClicked() {
        

        if let text = memoTextView.text {
            //타이틀값 얻으려고 줄단위로 자른 배열 생성. 첫째 줄만 잘라서 변수에 담아볼랬는데 못찾음(문자열 관련 공부 필요) 추후에 방법 찾으면 개선
            let textViewArray = text.split(separator: "\n")
            let titleForMain = textViewArray[0]
            //만약 엔터를 안치고 넘어갔을때 처리 필요(타이틀부분만 타이핑했을 때)
            let contentForMain = textViewArray[1]
            
            let nowDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy.MM.dd a HH:mm"
            let dateForMain = dateFormatter.string(from: nowDate)
                        
            let memo = MemoList(title: String(titleForMain), date: dateForMain, subContent: String(contentForMain))
            
            try! localRealm.write {
                localRealm.add(memo)
            }
            
            
    
        }
    }

}
