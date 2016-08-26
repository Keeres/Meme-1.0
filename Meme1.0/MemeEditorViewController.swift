//
//  MemeEditorViewController.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/22/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var appDelegate: AppDelegate!

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
 
    let imagePicker = UIImagePickerController()
    let defaultFontSize:CGFloat = 35.0
    var memes = [Meme]()
    var startedEditing = true
    var finishedEditing = true
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    enum ButtonType: Int { case Camera = 0, Album }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        self.navigationController?.toolbarHidden = false
        actionButton.enabled = false

        initializeTextField(topTextField)
        initializeTextField(bottomTextField)
        subscribeToKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enables cameraButoon if camera is detecd
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Initialize TextView
    func initializeTextField(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
    }
    
     // GERATE MEME
    func generateMemedImage() -> UIImage{
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
    
    // Create meme
    func createMeme(memeImage: UIImage) -> Meme{
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, origianlImage: self.memeImageView.image!, memeImage: memeImage)
        
        self.memes.append(meme)
        
        return meme
    }
    
    // Save meme
    func saveMeme(meme:Meme){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Buttons
    
    @IBAction func actionButton(sender: AnyObject) {
        let memeImage = generateMemedImage()
        let actionController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        actionController.completionWithItemsHandler = { (activity, success, items, error) in
            let meme = self.createMeme(memeImage)
            self.saveMeme(meme)
        }

        self.presentViewController(actionController, animated: true, completion:nil)
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Camera:
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            
        case .Album:
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
       memeImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    // MARK: ImagePicker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        memeImageView.image = image
        memeImageView.contentMode = .ScaleAspectFit
        print("ASDF")
        actionButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        startedEditing = true
        
        if textField == self.topTextField{
            topTextField.text = nil
            topTextField.becomeFirstResponder()
        }
        if textField == self.bottomTextField{
            bottomTextField.text = nil
            bottomTextField.becomeFirstResponder()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
  
    func textFieldDidEndEditing(textField: UITextField) {
        
        finishedEditing = true
        
        if textField == topTextField && topTextField.text!.isEmpty{
            textField.text = "TOP"
        }else if textField == bottomTextField && bottomTextField.text!.isEmpty{
            textField.text = "Bottom"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Navigation
    // view controller is signing up to be notified when keyboard will apper
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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

        if topTextField.isFirstResponder() && startedEditing == true{
            startedEditing = false
        }else if startedEditing == true{
            view.frame.origin.y -= getKeyboardHeight(notification) //origin is top of the view
            startedEditing = false
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {  //notification annouce information across class
        
        if topTextField.isFirstResponder() && finishedEditing == true{
            finishedEditing = false
        }else if finishedEditing == true{
            view.frame.origin.y += getKeyboardHeight(notification) //origin is top of the view
            print(view.frame.origin.y)
            
            finishedEditing = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //notification carries information inside userInfo dictionary
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }
}

