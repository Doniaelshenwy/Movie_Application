//
//  SingleReviewTableViewCell.swift
//  Movie_APP
//
//  Created by Donia Elshenawy on 13/08/2022.
//

import UIKit

class SingleReviewTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var nameAuthorLabel: UILabel!
    
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
