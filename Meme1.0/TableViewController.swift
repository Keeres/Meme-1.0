//
//  TableViewController.swift
//  Meme1.0
//
//  Created by Steven Chen on 2/27/16.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
    }
    
    func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    @IBAction func addMemeButton(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("memeView") as! ViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let rows = memes.count
        return rows
    }

   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")! as UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = meme.topText! + meme.bottomText!
        cell.textLabel?.textAlignment = .Right
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle

        return cell
    }
    
  /*  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("memeView") as! ViewController
        let meme = memes[indexPath.row]
        controller.memeImage = meme.memeImage
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
*/
}