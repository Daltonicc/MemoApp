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
    var memoData: MemoList = MemoList(title: "", date: Date(), subContent: "", favoriteStatus: false)
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        navigationItemSetting()
        memoTextViewSetting()
        memoList = localRealm.objects(MemoList.self)
        keyboardNotification()

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
    
    func keyboardNotification() {
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.verticalScrollIndicatorInsets = inset
            }
            
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.verticalScrollIndicatorInsets
            inset.bottom = 9
            strongSelf.memoTextView.verticalScrollIndicatorInsets = inset
        })
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
            //타이틀값 얻으려고 줄단위로 자른 배열 생성. 첫째 줄만 잘라서 변수에 담아볼랬는데 못찾음(문자열 관련 공부 필요) 추후에 방법 찾으면 개선 (해결) -> 9번 참고
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
                        
            let memo = MemoList(title: String(titleForMain), date: nowDate, subContent: String(contentForMain), favoriteStatus: favoriteStatus)
            
            //초기 데이터베이스에 아무것도 없을 때 처리.
            if memoList != nil {
                //아무 텍스트가 없을 때
                if titleForMain == "" && contentForMain == "" {
                    try! localRealm.write {
                        localRealm.delete(memoData)
                        print("1")
                    }
                //기존 메모를 수정할 떄
                } else if memoData.title != "" {
                    try! localRealm.write {
                        localRealm.delete(memoData)
                        localRealm.add(memo)
                        print("2")
                    }
                //새 메모 작성일 때
                } else {
                    try! localRealm.write {
                        localRealm.add(memo)
                        print("3")
                    }
                }
            //최초 데이터베이스가 전무할 때
            } else {
                try! localRealm.write {
                    localRealm.add(memo)
                    print("4")
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

// commit test
