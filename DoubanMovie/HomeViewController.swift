//
//  HomeViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var movieInfoDialog: MovieInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        movieInfoDialog.ratingInfoView.ratingScore = 5
        movieInfoDialog.addTarget(target: self, action: #selector(HomeViewController.movieInfoDialogDidTouch(sender:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    func movieInfoDialogDidTouch(sender: AnyObject) {
        print("movieInfoDialogDidTouch")
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    @IBAction func handGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            
            print("prepare")
        }
    }
}
