//
//  HomeViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController{
    @IBOutlet weak var movieInfoDialog: MovieInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        movieInfoDialog.ratingInfoView.ratingScore = 5
        movieInfoDialog.addTarget(self, action: #selector(HomeViewController.movieInfoDialogDidTouch(_:)), for: .TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func movieInfoDialogDidTouch(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    // MARK: - IBActions
    
    @IBAction func handGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            break
        case .Changed:
            break
        case .Ended:
            break
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetailSegue" {
            
        }
        
        if segue.identifier == "MenuSegue" {
            if let toVC = segue.destinationViewController as? MenuViewController {
                if toVC.delegate == nil {
                    toVC.delegate = self
                }
            }
        }
        
    }
}
