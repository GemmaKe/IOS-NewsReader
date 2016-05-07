//
//  ViewNewsDetail.swift
//  NewsReader
//
//  Created by val on 22/04/2016.
//  Copyright © 2016 Qing. All rights reserved.
//

import UIKit

class ViewNewsDetail: UIViewController {
    //Associate with outlet
    @IBOutlet var webView: UIWebView!
    //New url which is set content from newstableview
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load web with certain url
        let webUrl = NSURL (string: url)
        let requestObj = NSURLRequest(URL: webUrl!)
        webView.loadRequest(requestObj)
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
