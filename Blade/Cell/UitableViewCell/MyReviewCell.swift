//
//  MyReviewCell.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import UIKit

class MyReviewCell: UITableViewCell {

    @IBOutlet weak var labelAvgRating: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var objReview: ReviewModel? {
        didSet {
            imgUser.sd_setImage(with: URL(string:  objReview?.toUser?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            labelTitle.text = objReview?.toUser?.name ?? ""
            labelSubTitle.text = objReview?.review ?? ""
            labelAvgRating.text = "\(objReview?.rating ?? 0)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let startDate = dateFormatter.string(from: Date(timeIntervalSince1970: objReview?.created ?? 0))
            labelTime.text = startDate
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
