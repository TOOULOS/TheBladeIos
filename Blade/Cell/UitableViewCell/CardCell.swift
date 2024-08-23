//
//  CardCell.swift
//  Blade
//
//  Created by cqlsys on 04/12/22.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var objCard: CardModel? {
        didSet {
            labelName.text = "\(objCard?.brand ?? "") \(NSLocalizedString("card ending with", comment: "card ending with")) \(objCard?.last4 ?? "0")"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
