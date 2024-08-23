//
//  TransactionCell.swift
//  Blade
//
//  Created by cqlsys on 26/04/23.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var labelThird: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelFirst: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
