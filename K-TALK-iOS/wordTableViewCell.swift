//
//  wordTableViewCell.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/07.
//

import UIKit

class wordTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var korean: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
