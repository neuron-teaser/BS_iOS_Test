//
//  MovieListTVCell.swift
//  BS-iOS-Test
//
//  Created by Jamil Bin Hossain on 6/5/21.
//

import UIKit

class MovieListTVCell: UITableViewCell {

    @IBOutlet weak var movieThumbImage: UIImageView!
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetails: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
