//
//  SaloonReviewCell.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit

class SaloonReviewCell: UITableViewCell {

    @IBOutlet weak var labelRatinh: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var obj: SaloonReviewModel? {
        didSet {
            labelDescription.text = obj?.review ?? ""
            labelName.text = obj?.user?.name ?? ""
            img.sd_setImage(with: URL(string:  obj?.user?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = .current
            let startDate = dateFormatter.string(from: Date(timeIntervalSince1970: obj?.created ?? 0))
            labelTime.text = startDate
            
            labelRatinh.text = "\(obj?.rating ?? 0)"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
