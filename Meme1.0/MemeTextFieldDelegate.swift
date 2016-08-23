//
//  MemeTextFieldDelegate.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/23/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate, UITextViewDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
