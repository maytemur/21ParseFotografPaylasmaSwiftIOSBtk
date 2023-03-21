//
//  FeedTableViewCell.swift
//  21ParseFotografPaylasma
//
//  Created by maytemur on 21.02.2023.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var kullaniciAdiLbl: UILabel!
    
    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
