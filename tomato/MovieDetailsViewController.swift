//
//  MovieDetailsViewController.swift
//  tomato
//
//  Created by Bryan Pon on 9/13/14.
//  Copyright (c) 2014 bpon. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var placeholderView: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let posters = movie["posters"] as NSDictionary
        let rating = movie["mpaa_rating"] as String
        let runtime = movie["runtime"] as Int
        
        let placeholderUrl = posters["thumbnail"] as NSString
        let placeholderRequest = NSURLRequest(URL: NSURL(string: placeholderUrl))
        placeholderView.setImageWithURLRequest(placeholderRequest, placeholderImage: nil,
            success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                self.placeholderView.image = image
            }, failure: { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                println(error)
            }
        )
        
        let posterUrl = (posters["original"] as NSString).stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        let posterRequest = NSURLRequest(URL: NSURL(string: posterUrl))
        posterView.setImageWithURLRequest(posterRequest, placeholderImage: nil,
            success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                self.posterView.image = image
            }, failure: { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                println(error)
            }
        )
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        ratingLabel.text = "Rated \(rating)"
        runtimeLabel.text = "\(runtime) min"
        scroll.contentSize = CGSizeMake(detailsView.frame.size.width, detailsView.frame.size.height + 210)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
