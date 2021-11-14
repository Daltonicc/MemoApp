//
//  WalkthroughViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/12.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewSetting()

    }
    
    func viewSetting() {
            
        mainView.backgroundColor = .black
        mainView.layer.cornerRadius = 10
        
        titleLabel.text = "처음 오셨군요! \n환영합니다:) \n\n당신만의 메모를 작성하고\n관리해보세요!"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.backgroundColor = .black
        titleLabel.numberOfLines = 0
        
        okayButton.setTitle("확인", for: .normal)
        okayButton.backgroundColor = .orange
        okayButton.tintColor = .white
        okayButton.layer.cornerRadius = 10
    }

    @IBAction func okayButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
