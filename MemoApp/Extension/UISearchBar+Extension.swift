//
//  UISearchBar+Extension.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/08.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
}
