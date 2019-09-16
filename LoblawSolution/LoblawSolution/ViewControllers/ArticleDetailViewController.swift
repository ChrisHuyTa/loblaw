//
//  ArticleDetailViewController.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-13.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    var thumbnail: UIImageView?
    var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    var article: Article?
    var cachedArticleImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = cachedArticleImage {
            setupThumbnail()
            thumbnail!.image = img
        }
        
        if let article = article {
            self.title = article.title
            setupTextView()
            print(article.selftext)
            self.textView.text = article.selftext
        }
        
        
        // Do any additional setup after loading the view.
    }

    func setupThumbnail() {
        thumbnail = UIImageView()
        thumbnail?.contentMode = .scaleAspectFit
        self.view.addSubview(thumbnail!)
        thumbnail!.translatesAutoresizingMaskIntoConstraints = false
        thumbnail!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        thumbnail!.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thumbnail!.heightAnchor.constraint(equalToConstant: 120).isActive = true
        thumbnail!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setupTextView() {
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        if thumbnail != nil {
            textView.topAnchor.constraint(equalTo: thumbnail!.bottomAnchor, constant: 10).isActive = true
        } else {
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        }
    }
}
