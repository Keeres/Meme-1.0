//
//  ViewController.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/22/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var appDelegate: AppDelegate!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    var centerPointY:CGFloat?
    var centerPointX:CGFloat?

   // let memeTextFieldDelegate = MemeTextFieldDelegate()
    let memeTextViewDelegate = MemeUITextViewDelegate()
    
    /*let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30.0)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    */
    let memeAttributeString = NSAttributedString(string: " ", attributes:[NSStrokeColorAttributeName : UIColor.blackColor(),NSForegroundColorAttributeName : UIColor.whiteColor(),NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30.0)!,
        NSStrokeWidthAttributeName : -5.0])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        shareButton.enabled = false;
     //   let centerPoint = (imageView.frame.size.height - imageView.frame.origin.y)/2 + imageView.frame.origin.y
        
     /*   topTextfield.delegate = memeTextFieldDelegate
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.text = "TOP"
        topTextfield.textAlignment = NSTextAlignment.Center
        */

        self.navigationController?.toolbarHidden = false
        topTextView.delegate = memeTextViewDelegate
        topTextView.attributedText = memeAttributeString
        topTextView.textAlignment = NSTextAlignment.Center
        topTextView.textContainer.maximumNumberOfLines = 2;
        topTextView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        topTextView.textColor = UIColor.lightGrayColor()
        topTextView.text = " "

        bottomTextView.delegate = memeTextViewDelegate
        bottomTextView.attributedText = memeAttributeString
        bottomTextView.textAlignment = NSTextAlignment.Center
        bottomTextView.textContainer.maximumNumberOfLines = 2;
        bottomTextView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        bottomTextView.textColor = UIColor.lightGrayColor()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        centerPointY = (imageView.frame.size.height - imageView.frame.origin.y)/2 + imageView.frame.origin.y
        centerPointX = imageView.frame.size.width/8

        appDelegate.centerPointY = centerPointY
        appDelegate.centerPointX = centerPointX

        if imageView.image != nil{
            
            let scale = imageView.imageScale
            topTextView.frame.origin.x = centerPointX!
            bottomTextView.frame.origin.x = centerPointX!

            if imageView.image?.size.height > imageView.image?.size.width{
                topTextView.frame.origin.y = centerPointY! - imageView.image!.size.height*scale.height/1.9
            }else{
                topTextView.frame.origin.y = centerPointY! - imageView.image!.size.height*scale.height
            }
print(topTextView.frame.origin.y)
            if imageView.image?.size.height > imageView.image?.size.width{
                bottomTextView.frame.origin.y = centerPointY! + imageView.image!.size.height*scale.height/3
            }else{
                bottomTextView.frame.origin.y = centerPointY! + imageView.image!.size.height*scale.height/3.6
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        shareButton.enabled = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // GERATE MEME
    func generateMemedImage() -> UIImage
    {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.toolbarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.toolbarHidden = false

        return memedImage
    }
    
    // BUTTONS
    @IBAction func cameraButton(sender: AnyObject) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickImageController, animated: true, completion: nil)
    }

    @IBAction func cancelButton(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)

        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func AlbumButton(sender: AnyObject) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        let memeImage = generateMemedImage()
        
        let activityViewControler = UIActivityViewController(activityItems:[memeImage], applicationActivities: nil)
       // self.presentViewController(activityViewControler, animated: true, completion: nil)
        self.presentViewController(activityViewControler, animated: true, completion: {
            //Create the meme
            let meme = Meme(topText: self.topTextView.text, bottomText: self.bottomTextView.text, image: self.imageView.image!, memedImage: memeImage)
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            
        })

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit;
        topTextView.text = "TOP"
        bottomTextView.text = "BOTTOM"
        topTextView.textColor = UIColor.lightGrayColor()
        bottomTextView.textColor = UIColor.lightGrayColor()
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    // NOTIFICATIONS
    // view controller is signing up to be notified when keyboard will apper
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    // view controller unsubscribes notification when keyboard will disapper
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
   
    // show and shift keyboard when notification is recieved
    func keyboardWillShow(notification: NSNotification) {  //notification annouce information across class
        if bottomTextView.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification) //origin is top of the view
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {  //notification annouce information across class
        if bottomTextView.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification) //origin is top of the view
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //notification carries information inside userInfo dictionary
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

