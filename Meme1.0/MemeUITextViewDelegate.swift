//
//  MemeUITextViewDelegate.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/23/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

class MemeUITextViewDelegate : NSObject, UITextViewDelegate {
    var appDelegate: AppDelegate!

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
   
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if text == "\n" {
        
        textView.resignFirstResponder()
        // Return FALSE so that the final '\n' character doesn't get added
        return false;
        }
        // For any other character return TRUE so that the text gets added to the view
        return true;
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if textView.text.isEmpty && textView.frame.origin.y > appDelegate.centerPointY{
            textView.text = "BOTTOM"
            textView.textColor = UIColor.lightGrayColor()
        } else if textView.text.isEmpty && textView.frame.origin.y < appDelegate.centerPointY{
            textView.text = "TOP"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
}