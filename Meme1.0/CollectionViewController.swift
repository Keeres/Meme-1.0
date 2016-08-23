//
//  CollectionViewController.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/29/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
  

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 4.0
        print(view.frame.size.width)
        print(dimension)

        flowLayout.minimumInteritemSpacing = space
       // flowLayout.itemSize = CGSizeMake(dimension, dimension)

        self.navigationController?.toolbarHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
    }
    
  
    func loadList(notification: NSNotification){
        //load data here
        self.memeCollectionView.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectonViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.image?.image = meme.memeImage
        cell.image.contentMode = .ScaleAspectFit;

       // cell.label.text = meme.topText! + meme.bottomText!
     //   cell.label.textAlignment = .Right
       // cell.label.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        
        return cell

    }
    @IBAction func addMemeButton(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("memeView") as! ViewController
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
 /*   override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("memeView") as! ViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
*/
}