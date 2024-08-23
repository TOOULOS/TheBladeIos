//
//  NotificationCell.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var objNotify: NotificationModel? {
        didSet {
            labelTitle.text = objNotify?.text ?? ""
            let type = objNotify?.type ?? 0
            
            if objNotify?.type ?? 0 == 7 || objNotify?.type ?? 0 == 8 {
                imgUser.image = UIImage.init(named: "rewardsicon")
            } else if objNotify?.type ?? 0 == 4 {
                imgUser.image = UIImage.init(named: "completebookingicon")
            } else if objNotify?.type ?? 0 == 1 {
                imgUser.sd_setImage(with: URL(string:  objNotify?.notificationData?.booking?.salonImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            } else if objNotify?.type ?? 0 == 2 {
                imgUser.image = UIImage.init(named: "rejectedbooking")
            } else if objNotify?.type ?? 0 == 27 || objNotify?.type ?? 0 == 28 {
                imgUser.image = UIImage.init(named: "cancelbookingicon")
            } else if objNotify?.type ?? 0 == 27 || objNotify?.type ?? 0 == 28 {
                imgUser.image = UIImage.init(named: "cancelbookingicon")
            } else if (type==15 || type == 16||type==17 || type == 18 || type == 25 || type == 26) {
                imgUser.image = UIImage.init(named: "refundmoneyicon")
            } else if (type==29 || type == 30||type==31 || type == 32) {
                imgUser.image = UIImage.init(named: "reminderbookingicon")
            } else if (type==11 || type == 10 || type == 12) {
                imgUser.image = UIImage.init(named: "ratingreviewicon")
            } else if (type==5 || type == 6) {
                imgUser.image = UIImage.init(named: "cancelbookingicon")
            } else if (type == 13 || type == 14) {
                imgUser.image = UIImage.init(named: "newbooking")
            } else if (type == 23 || type == 24) {
                imgUser.image = UIImage.init(named: "rescheduleicon")
            } else if (type == 33 || type == 34 || type == 35) {
                imgUser.image = UIImage.init(named: "newbookingicon")
            } else if (type == 9 ) {
                imgUser.image = UIImage.init(named: "ratingreviewicon")
            } else{
                imgUser.sd_setImage(with: URL(string:  objNotify?.notificationData?.booking?.salonImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
                // holder.mIvImage.loadUserImage(notificationData.booking!!.salonImage)
            }
            
            
            let date = Date(timeIntervalSince1970: Double(objNotify?.created ?? "") ?? 0)

            let formatter = RelativeDateTimeFormatter()
        
            formatter.locale = Locale.init(identifier: UserDefaults.standard.value(forKey: "CurrentLang1") as? String ?? "en")
            formatter.unitsStyle = .full
            

            let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
            labelTime.text = relativeDate
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



