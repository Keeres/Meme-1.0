//
//  Struct.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/24/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    //Properties
    let topText:String?
    let bottomText:String?
    var origianlImage = UIImage?()
    var memeImage = UIImage?()

    init(topText:String, bottomText:String, image: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.origianlImage = image
        self.memeImage = memedImage
        
    }
}