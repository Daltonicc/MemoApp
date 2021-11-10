//
//  MemoViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/10.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        
        navigationItemSetting()
        
        memoTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        memoTextView.backgroundColor = .black
        



    }
    
    func navigationItemSetting() {
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
        
        navigationItem.rightBarButtonItems = [finishButton, shareButton]
        
        
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func finishButtonClicked() {
        
    }

}
