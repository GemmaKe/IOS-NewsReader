//
//  News.swift
//  NewsReader
//
//  Created by val on 22/04/2016.
//  Copyright © 2016 Qing. All rights reserved.
//

import UIKit

class News: NSObject {
    //New
    var title: String
    var desc: String
    var link: String
    var imageUrl: String
    
    //standard initial
    override init() {
        self.title = "no title"
        self.desc = "no desc"
        self.link = "no link"
        self.imageUrl = "no url"
    }
    
    init(newTitle:String, newDesc:String, newLink:String, newUrl:String) {
        self.title = newTitle
        self.desc = newDesc
        self.link = newLink
        self.imageUrl = newUrl
    }

}
