//
//  SaloonCell.swift
//  Blade
//
//  Created by cqlsys on 09/10/22.
//

import UIKit

class SaloonCell: UICollectionViewCell {
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var labelTotalRating: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageSaloon: UIImageView!
    
    var objSallon: CustomerHomeNearByModel? {
        didSet {
            imageSaloon.sd_setImage(with: URL(string:  objSallon?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                self.imageSaloon.layer.cornerRadius = 7
                self.imageSaloon.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            })
            
            labelName.text = objSallon?.salonName ?? ""
            labelAddress.text = objSallon?.location ?? ""
            labelTotalRating.text = objSallon?.rating ?? ""
            if objSallon?.isFav ?? 0 == 1 {
                btnLike.isSelected = true
            } else {
                btnLike.isSelected = false
            }
        }
    }
    
    var objTopRated: CustomerHomeTopRatedModel? {
        didSet {
            imageSaloon.sd_setImage(with: URL(string:  objTopRated?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                self.imageSaloon.layer.cornerRadius = 7
                self.imageSaloon.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            })
            
            
            
            labelName.text = objTopRated?.name ?? ""
            labelAddress.text = objTopRated?.salonName ?? ""
            labelTotalRating.text = objTopRated?.rating ?? ""
            if objTopRated?.isFav ?? 0 == 1 {
                btnLike.isSelected = true
            } else {
                btnLike.isSelected = false
            }
        }
    }
}
