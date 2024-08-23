//
//  SaloonServiceCell.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit

class SaloonServiceCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var obj: SaloonStylistServiceModel? {
        didSet {
            labelName.text = obj?.serviceName ?? ""
            labelTime.text = "\(obj?.timeValue ?? "") \(NSLocalizedString("Minutes", comment: "Minutes"))"
            labelAmount.text = "€ \(obj?.price ?? "")"
            labelSubTitle.text = ""
          //  labelSubTitle.text = obj?.serviceDescription ?? ""
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
