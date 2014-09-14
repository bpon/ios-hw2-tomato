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
    
    let sources: [String] = ["movies/box_office", "dvds/new_releases"]
    let tabImages: [String] = ["iconmonstr-video-icon-16", "iconmonstr-disc-14-icon-16"]
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tabBarItem!.selectedImage = UIImage(named: tabImages[tabBarController!.selectedIndex])

        let source = sources[tabBarController!.selectedIndex]
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/\(source).json?apikey=np4pvukhemwjzckp7geyk7k8"
        let request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let obj = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.movies = obj["movies"] as [NSDictionary]
            self.tableView.reloadData()
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
        cell.posterView.setImageWithURL(NSURL(string: posters["thumbnail"] as String))
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "details") {
            let selectedPath = tableView.indexPathForSelectedRow()!
            (segue.destinationViewController as MovieDetailsViewController).movie = movies[selectedPath.row]
            tableView.deselectRowAtIndexPath(selectedPath, animated: false)
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
