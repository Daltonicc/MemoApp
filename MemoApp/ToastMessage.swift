//
//  ToastMessage.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/11.
//

import UIKit

func showToast(vc: UIViewController ,message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
    let toastLabel = UILabel(frame: CGRect(x: vc.view.frame.size.width/2 - 75, y: vc.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds = true
    vc.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0
        
    }, completion: {(isCompleted) in
        
        toastLabel.removeFromSuperview() })
    
}


