//
//  ViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController {
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
//        self.dismiss(animated: true, completion: nil)
    }
}

