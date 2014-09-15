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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingIndicator.startAnimating()
        let posters = movie["posters"] as NSDictionary
        let posterUrl = (posters["original"] as NSString).stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        posterView.setImageWithURL(NSURL(string: posterUrl))
        loadingIndicator.stopAnimating()
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
