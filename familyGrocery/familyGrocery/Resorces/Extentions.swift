//
//  Extentions.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 15/06/1444 AH.
//

import Foundation
import UIKit

extension UIImageView {
    func RounedImage(){
        self.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.layer.masksToBounds = false
        self.frame(forAlignmentRect: CGRectMake(0, 0, 150, 150))
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 150.0/2.0
        self.clipsToBounds = true
    }
}

extension UIButton {
    func RounedButton(){
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.layer.masksToBounds = false
        self.frame(forAlignmentRect: CGRectMake(0, 0, 44, 44))
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 44.0/2.0
        self.clipsToBounds = true
    }
}

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}
