//
//  ViewController.swift
//  LoblawSolution
//
//  Created by Chris Ta on 2019-09-12.
//  Copyright © 2019 Loblaw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var listingTable: UITableView!
    
    var reuseId = "listingCell"
    var listingArticles = [Article]()
    var apiService: NewsService = NewsService.sharedInstance
    
    var imageCache = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Swift News"
        setupTable()
        
        apiService.fetchNews { (result) in
            switch result {
            case .success(let data):
                self.listingArticles = data
                DispatchQueue.main.async {
                    self.listingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setupTable() {
        listingTable.dataSource = self
        listingTable.delegate = self
        listingTable.register(UINib(nibName: "ListingTableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        listingTable.rowHeight = UITableView.automaticDimension
        listingTable.estimatedRowHeight = 100
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! ListingTableViewCell
        
        let article = listingArticles[indexPath.row]
        
        cell.titleLabel.text = article.title
        cell.thumbnail.image = nil
        if article.thumbnail.contains("http"),
            let imgUrl = URL(string: article.thumbnail) {
            
            if let image = self.imageCache[article.thumbnail] {
                cell.thumbnail.image = image
            } else {
            
                cell.thumbnail.loadImage(from: imgUrl, contentMode: .scaleAspectFit) { (image) in
                    self.imageCache[article.thumbnail] = image
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
            
        }
        
        return cell
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = listingArticles[indexPath.row]
        
        let vc = ArticleDetailViewController()
        vc.article = article
        if let articleThumbnail = self.imageCache[article.thumbnail] {
            vc.cachedArticleImage = articleThumbnail
        }
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

