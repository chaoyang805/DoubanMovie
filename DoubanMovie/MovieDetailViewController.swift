//
//  MovieDetailViewController.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/7/18.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Properties
    var movieSubject: [String: AnyObject] {
        guard let subjects = data["subjects"] as? [AnyObject] else {
            print("can't read subjects.")
            return [:]
        }
        guard let firstItem = subjects[0] as? [String: AnyObject] else {
            print("can't red subjects array.")
            return [:]
        }
        return firstItem
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var artistsScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieSummaryText: UITextView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieCastsLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieCollectCountLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        if movieSubject.isEmpty {
            print("movieSubject is empty, can't configure view.")
            return
        }
        
        if let artists = movieSubject["casts"] as? [[String: AnyObject]], let directors = movieSubject["directors"] as? [[String: AnyObject]] {
            
            let artistCount = artists.count + directors.count
            let vSpacing: CGFloat = 20
            let width: CGFloat = 60
            
            artistsScrollView.contentSize = CGSize(width: CGFloat(artistCount) * (60 + 20), height: artistsScrollView.frame.height)
            artistsScrollView.showsVerticalScrollIndicator = false
            artistsScrollView.showsHorizontalScrollIndicator = false
            artistsScrollView.bounces = false
            
            for (index, artist) in (directors + artists).enumerated() {
                guard let avatars = artist["avatars"] as? [String: String] else {
                    continue
                }
                let mediumAvatarURL = avatars["medium"] ?? ""
                let name = artist["name"] as? String ?? ""
                let avatar = Avatar(name: name, avatarURL: mediumAvatarURL)
                let position = CGPoint(x: CGFloat(index) * (width + vSpacing), y: 0)
                let avatarView = AvatarView(frame: CGRect(origin: position, size: CGSize(width: width, height: 90)), avatar: avatar)
                avatarView.frame.origin = position
                artistsScrollView.addSubview(avatarView)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}
