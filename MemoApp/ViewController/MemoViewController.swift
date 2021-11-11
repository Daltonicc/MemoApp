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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        navigationItemSetting()
        memoTextViewSetting()
        
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
            //키보드 바로 띄워주기
            memoTextView.becomeFirstResponder()
        } else {
            memoTextView.text = memoData.title + "\n" + memoData.subContent
        }
    }
    
    
    @objc func shareButtonClicked() {
        
        var shareText: [Any] = []
        
        if let text = memoTextView.text {
            shareText.append(text)
        
            let activityViewController = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
        
            self.present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                if completed {
                    showToast(vc: self, message: "공유 성공")
                } else {
                    showToast(vc: self, message: "공유 실패")
                }
                if let shareError = error {
                    showToast(vc: self, message: "\(shareError.localizedDescription)")
                }
            }
        } else {
            print("공유할 내용이 없습니다.")
        }
    }
    
    @objc func finishButtonClicked() {
        
        if let text = memoTextView.text {
            //타이틀값 얻으려고 줄단위로 자른 배열 생성. 첫째 줄만 잘라서 변수에 담아볼랬는데 못찾음(문자열 관련 공부 필요) 추후에 방법 찾으면 개선
            let textViewArray = text.split(separator: "\n")
            var titleForMain = ""
            var contentForMain = ""
            let nowDate = Date()
            let favoriteStatus = false
            
            //추가 텍스트가 없을때 분기처리. 없으면 빈값으로 받아줌
            if textViewArray.count > 0 {
                titleForMain = String(textViewArray[0])
            }
            
            if textViewArray.count > 1 {
                contentForMain = String(textViewArray[1])
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy.MM.dd a HH:mm"
            let dateForMain = dateFormatter.string(from: nowDate)
                        
            let memo = MemoList(title: String(titleForMain), date: dateForMain, subContent: String(contentForMain), favoriteStatus: favoriteStatus)
            
            //초기 데이터베이스에 아무것도 없을 때 처리.
            if memoList != nil {
                //아무 텍스트가 없을 때
                if titleForMain == "" && contentForMain == "" {
                    try! localRealm.write {
                        localRealm.delete(memoData)
                    }
                } else {
                    try! localRealm.write {
                        localRealm.delete(memoData)
                        localRealm.add(memo)
                    }
                }
            } else {
                try! localRealm.write {
                    localRealm.add(memo)
                }
            }
            
            
            self.navigationController?.popViewController(animated: true)
        } else {
            print("텍스트 없음")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //안됨,,(해결해야 할 부분들 5번 참조)
    func whenYouPressCellAtMainVC() {
        
        memoTextView.text = memoData.title + "\n" + memoData.subContent

    }
}
