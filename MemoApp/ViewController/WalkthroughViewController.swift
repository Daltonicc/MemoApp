//
//  WalkthroughViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/12.
//

import UIKit

class WalkthroughViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        alertController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alertController()

    }

    func alertController() {
        
        let alert = UIAlertController(title: "처음 오셨군요! 환영합니다.", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
    }
}
