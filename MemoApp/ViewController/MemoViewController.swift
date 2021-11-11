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
    var memoData: MemoList = MemoList(title: "", date: "", subContent: "", favoriteStatus: false)
    let test = UITextView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        
        navigationItemSetting()
        memoTextViewSetting()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //키보드 바로 띄워주기
        memoTextView.becomeFirstResponder()
    }
    
    
    // MARK: - Method
    
    func navigationItemSetting() {
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
        
        navigationItem.rightBarButtonItems = [finishButton, shareButton]
        
    }
    
    func memoTextViewSetting() {
        
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        memoTextView.backgroundColor = .black
        memoTextView.font = UIFont.systemFont(ofSize: 20)
        
        if memoData.title == "" {
            memoTextView.text = ""
        } else {
            memoTextView.text = memoData.title + "\n" + memoData.subContent
        }
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func finishButtonClicked() {
        
        if let text = memoTextView.text {
            //타이틀값 얻으려고 줄단위로 자른 배열 생성. 첫째 줄만 잘라서 변수에 담아볼랬는데 못찾음(문자열 관련 공부 필요) 추후에 방법 찾으면 개선
            let textViewArray = text.split(separator: "\n")
            let titleForMain = textViewArray[0]
            let nowDate = Date()
            var contentForMain = ""
            let favoriteStatus = false
            
            //추가 텍스트가 없을때 분기처리. 없으면 빈값으로 받아줌
            if textViewArray.count > 1 {
                contentForMain = String(textViewArray[1])
            } else {
                contentForMain = ""
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy.MM.dd a HH:mm"
            let dateForMain = dateFormatter.string(from: nowDate)
                        
            let memo = MemoList(title: String(titleForMain), date: dateForMain, subContent: String(contentForMain), favoriteStatus: favoriteStatus)
            
            try! localRealm.write {
                localRealm.add(memo)
            }
            
            self.navigationController?.popViewController(animated: true)
            
            //텍스트 없을때
        } else {
            //디비에서 삭제해야함
            print("텍스트 없음")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //안됨,,(해결해야 할 부분들 5번 참조)
    func whenYouPressCellAtMainVC() {
        
        memoTextView.text = memoData.title + "\n" + memoData.subContent

    }
}
