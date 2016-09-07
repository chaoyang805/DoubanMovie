//
//  SnackbarView.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/9/6.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class SnackbarView: UIView {
    
    var messageView: UILabel!
    
    var actionButton: UIButton!
    var actionBlock: ((sender: AnyObject) -> Void)?
    
    var snackbar: Snackbar?
    
    convenience init() {

        let x: CGFloat = 0
        let y = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        self.init(frame: CGRect(x: x, y: y, width: width, height: 40))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        
        messageView = UILabel()
        messageView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        messageView.backgroundColor = UIColor.clearColor()
        messageView.font = UIFont(name: "PingFang SC", size: 14)
        messageView.text = "Placeholder text"
        messageView.sizeToFit()
        messageView.textColor = UIColor.whiteColor()
        self.addSubview(messageView)
        
        actionButton = UIButton(type: .System)
        actionButton.setTitle("OK", forState: .Normal)
        actionButton.tintColor = UIColor(red: 0.188, green: 0.688, blue: 0.296, alpha: 1)
        actionButton.sizeToFit()
    }
    
    func setAction(title: String, block: (sender: AnyObject) -> Void) {
        self.actionBlock = block
        
        actionButton.setTitle(title, forState: .Normal)
        if actionButton.superview == nil {
            self.addSubview(actionButton)
        }
        self.actionButton.addTarget(self, action: #selector(SnackbarView.actionSelector(_:)), forControlEvents: .TouchUpInside)
    }
    
    func actionSelector(sender: AnyObject) {
        self.actionBlock?(sender: sender)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 8
        var y = self.bounds.height / 2 - self.messageView.bounds.height / 2
        
        messageView.frame.origin = CGPoint(x: x, y: y)
        
        x = self.bounds.width - actionButton.bounds.width - 8
        y = self.bounds.height / 2 - actionButton.bounds.height / 2
        actionButton.frame.origin = CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
