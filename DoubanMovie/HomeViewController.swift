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
        print("viewDidLoad")
        movieInfoDialog.ratingInfoView.ratingScore = 5
        movieInfoDialog.addTarget(self, action: #selector(HomeViewController.movieInfoDialogDidTouch(_:)), for: .TouchUpInside)
//        DoubanService.sharedService.getInTheaterMovies(inCity: "石家庄", at: 5, resultCount: 10) { (responseJSON, error) in
//            if let error = error {
//                print(error)
//            }
//            print(responseJSON)
//        }
//        DoubanService.sharedService.searchMovies(withQuery: "周杰伦", at: 0, resultCount: 4) { (responseJSON, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            print(responseJSON)
//        }

//        DoubanService.sharedService.searchMovies(withTag: "喜剧", at: 0, resultCount: 2) { (responseJSON, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            print(responseJSON)
//        }
//        
//        DoubanService.sharedService.movie(forId: 1764796) { (responseJSON, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            print(responseJSON)
//        }
//        
//        DoubanService.sharedService.celebrity(forId: 1054395, completionHandler: { (responseJSON, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            print(responseJSON)
//        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
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
