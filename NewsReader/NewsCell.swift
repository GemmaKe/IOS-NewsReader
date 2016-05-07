//
//  NewsCell.swift
//  NewsReader
//
//  Created by val on 22/04/2016.
//  Copyright © 2016 Qing. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    //Associate with outlet
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
