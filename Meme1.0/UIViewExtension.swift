//
//  UIViewExtension.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/22/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    var imageScale: CGSize {
        let sx = Double(self.frame.size.width / self.image!.size.width)
        let sy = Double(self.frame.size.height / self.image!.size.height)
        var s = 1.0
        switch (self.contentMode) {
        case .ScaleAspectFit:
            s = fmin(sx, sy)
            return CGSize (width: s, height: s)
            
        case .ScaleAspectFill:
            s = fmax(sx, sy)
            return CGSize(width:s, height:s)
            
        case .ScaleToFill:
            return CGSize(width:sx, height:sy)
            
        default:
            return CGSize(width:s, height:s)
        }
    }
}