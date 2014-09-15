//
//  MoviesViewController.swift
//  tomato
//
//  Created by Bryan Pon on 9/9/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    var refresh: UIRefreshControl!
    
    let sources: [String] = ["movies/box_office", "dvds/new_releases"]
    let tabImages: [String] = ["tab-boxoffice", "tab-dvd"]
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //Add pull to refresh
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refresh, atIndex: 0)
        
        tabBarItem!.selectedImage = UIImage(named: tabImages[tabBarController!.selectedIndex])
        loadingIndicator.startAnimating()
        loadData() {
            self.loadingIndicator.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let posters = movie["posters"] as NSDictionary
        let posterRequest = NSURLRequest(URL: NSURL(string: posters["thumbnail"] as String))
        cell.posterView.setImageWithURLRequest(posterRequest, placeholderImage: UIImage(named: "poster-placeholder"),
            success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                cell.posterView.image = image
            }, failure: nil
        )
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "details") {
            let selectedPath = tableView.indexPathForSelectedRow()!
            (segue.destinationViewController as MovieDetailsViewController).movie = movies[selectedPath.row]
            tableView.deselectRowAtIndexPath(selectedPath, animated: false)
        }
    }
    
    func loadData(onComplete: () -> Void) {
        let source = sources[tabBarController!.selectedIndex]
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/\(source).json?apikey=np4pvukhemwjzckp7geyk7k8"
        let request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error == nil) {
                let obj = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.movies = obj["movies"] as [NSDictionary]
                println("Loaded \(self.movies.count) movies")
                self.tableView.reloadData()
            } else {
                self.errorLabel.text = "Error loading content"
                self.errorLabel.hidden = false
            }
            onComplete()
        }
    }
    
    func onRefresh() {
        self.errorLabel.hidden = true
        loadData() {
            self.refresh.endRefreshing()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
