//
//  UserBookingCell.swift
//  Blade
//
//  Created by cqlsys on 19/10/22.
//

import UIKit

class UserBookingCell: UITableViewCell {

    @IBOutlet weak var btnManualReschedule: CustomButton!
    @IBOutlet weak var labelSalonTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var bottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var labelPaymentTYpe: UILabel!
    @IBOutlet weak var btnReschedule: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelImage: RoundImage!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSaloon: UILabel!
    @IBOutlet weak var labelService: UILabel!
    @IBOutlet weak var labelPaymentType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var objBooking: BookingModel? {
        didSet {
            if labelPaymentType != nil {
                labelPaymentType.textColor = UIColor.white
            }
            
            labelSaloon.text = objBooking?.salonName ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: objBooking?.bookingDate ?? "") ?? Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            labelDate.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "hh:mm a"
            let date1 = dateFormatter.date(from: objBooking?.bookingTime ?? "")
            dateFormatter.dateFormat = "HH:mm"
            
            labelTime.text = "\(dateFormatter.string(from: date1!) )"
            var str = ""
            for i in objBooking?.bookingJson?.salonServices ?? [] {
                if str == "" {
                    str = i.serviceName ?? ""
                } else {
                    str = "\(str), \(i.serviceName ?? "")"
                }
            }
            labelService.text = str
            
            if objBooking?.salonStylistId == 0 {
                labelImage.sd_setImage(with: URL(string:  objBooking?.salonImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
                labelSubTitle.text = objBooking?.salonUserName ?? ""
            } else {
                labelSubTitle.text = objBooking?.salonStylistName ?? ""
                labelImage.sd_setImage(with: URL(string:  objBooking?.salonStylistImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            }
            
            if btnManualReschedule != nil {
                btnManualReschedule.isHidden = true
                
                if objBooking?.user?.email ?? "" == "" {
                    btnManualReschedule.isHidden = false
                    imageStatus.tintColor = UIColor(red: 252 / 255, green: 252 / 255, blue: 0 / 255, alpha: 1)
                    labelPaymentType.text = NSLocalizedString("Manual Booking", comment: "Manual Booking")
                    labelPaymentType.textColor = UIColor.black
                    labelImage.image = UIImage.init(named: "ic_logo_new")
                } else {
                    btnManualReschedule.isHidden = true
                }
            }
            
        }
    }
    
    var objCompleted: BookingModel? {
        didSet {
            if labelPaymentType != nil {
                labelPaymentType.textColor = UIColor.white
            }
            
            if objCompleted?.paymentMethod ?? 0 == 2 {
                imageStatus.tintColor = UIColor(red: 31 / 255, green: 139 / 255, blue: 39 / 155, alpha: 1)
                labelPaymentType.text = NSLocalizedString("Paid Online", comment: "Paid Online")
            } else {
                imageStatus.tintColor = UIColor.red
                labelPaymentType.text = NSLocalizedString("Paid at Salon", comment: "Paid at Salon")
            }

            
            btnCancel.isHidden = true
            
            if (objCompleted?.isRatedUser ?? 0 == 0) &&  (objCompleted?.status ?? 0 == 4) {
                btnReschedule.isHidden = false
                bottomConstrant.constant = 83
                viewLine.isHidden = false
            } else {
                btnReschedule.isHidden = true
                bottomConstrant.constant = 20
                viewLine.isHidden = true
            }
            labelSaloon.text = objCompleted?.salonName ?? ""
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: objCompleted?.bookingDate ?? "") ?? Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            labelDate.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "hh:mm a"
            let date1 = dateFormatter.date(from: objCompleted?.bookingTime ?? "")
            dateFormatter.dateFormat = "HH:mm"
            labelTime.text = "\(dateFormatter.string(from: date1!) )"
            
//            labelDate.text = objCompleted?.bookingDate ?? ""
//            labelTime.text = objCompleted?.bookingTime ?? ""
            var str = ""
            for i in objCompleted?.bookingJson?.salonServices ?? [] {
                if str == "" {
                    str = i.serviceName ?? ""
                } else {
                    str = "\(str), \(i.serviceName ?? "")"
                }
            }
            labelService.text = str
            btnReschedule.setTitle("\(NSLocalizedString("Rate", comment: "Rate")) \(objCompleted?.user?.name ?? "")", for: .normal)
            labelImage.sd_setImage(with: URL(string:  objCompleted?.user?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            labelTitle.text = NSLocalizedString("Customer Name", comment: "Customer Name")
            labelSubTitle.text = objCompleted?.user?.name ?? ""
            labelStatus.text = (objCompleted?.status ?? 0) == 4 ? NSLocalizedString("Completed", comment: "Completed") : NSLocalizedString("Cancelled", comment: "Cancelled")
            
            if btnManualReschedule != nil {
               
                if objCompleted?.user?.email ?? "" == "" {
                    btnManualReschedule.isHidden = false
                    imageStatus.tintColor = UIColor(red: 252 / 255, green: 252 / 255, blue: 0 / 255, alpha: 1)
                    labelPaymentType.text = NSLocalizedString("Manual Booking", comment: "Manual Booking")
                    labelPaymentType.textColor = UIColor.black
                    labelImage.image = UIImage.init(named: "ic_logo_new")
                } else {
                    btnManualReschedule.isHidden = true
                }
            }
        }
    }
    
    
    var objUpcoming: BookingModel? {
        didSet {
            if labelPaymentType != nil {
                labelPaymentType.textColor = UIColor.white
            }
            
            if objUpcoming?.paymentMethod ?? 0 == 2 {
                imageStatus.tintColor = UIColor(red: 31 / 255, green: 139 / 255, blue: 39 / 155, alpha: 1)
                labelPaymentType.text = NSLocalizedString("Paid Online", comment: "Paid Online")
            } else {
                imageStatus.tintColor = UIColor.red
                labelPaymentType.text = NSLocalizedString("Paid at Salon", comment: "Paid at Salon")
            }

            btnCancel.isHidden = false
            btnCancel.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
            bottomConstrant.constant = 83
            viewLine.isHidden = false
            
            btnReschedule.isHidden = false
            btnReschedule.setTitle(NSLocalizedString("Complete", comment: "Complete") , for: .normal)
            
            
            
            labelSaloon.text = objUpcoming?.salonName ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: objUpcoming?.bookingDate ?? "") ?? Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            labelDate.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "hh:mm a"
            let date1 = dateFormatter.date(from: objUpcoming?.bookingTime ?? "")
            dateFormatter.dateFormat = "HH:mm"
            labelTime.text = "\(dateFormatter.string(from: date1!) )"
            
//            labelDate.text = objUpcoming?.bookingDate ?? ""
//            labelTime.text = objUpcoming?.bookingTime ?? ""
            var str = ""
            for i in objUpcoming?.bookingJson?.salonServices ?? [] {
                if str == "" {
                    str = i.serviceName ?? ""
                } else {
                    str = "\(str), \(i.serviceName ?? "")"
                }
            }
            labelService.text = str
            
            labelImage.sd_setImage(with: URL(string:  objUpcoming?.user?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            
            
            labelTitle.text = objUpcoming?.user?.name ?? ""
            labelSubTitle.text =  objUpcoming?.user?.countryCodePhone ?? ""
            
            labelStatus.text = NSLocalizedString("Accepted", comment: "Accepted")
            
            if btnManualReschedule != nil {
                if objUpcoming?.user?.email ?? "" == "" {
                    btnManualReschedule.isHidden = false
                    imageStatus.tintColor = UIColor(red: 252 / 255, green: 252 / 255, blue: 0 / 255, alpha: 1)
                    labelPaymentType.text = NSLocalizedString("Manual Booking", comment: "Manual Booking")
                    labelPaymentType.textColor = UIColor.black
                    labelImage.image = UIImage.init(named: "ic_logo_new")
                } else {
                    btnManualReschedule.isHidden = true
                }
            }
        }
    }
    
    
    var objRequest: BookingModel? {
        didSet {
            
            
            if objRequest?.paymentMethod ?? 0 == 2 {
                imageStatus.tintColor = UIColor(red: 31 / 255, green: 139 / 255, blue: 39 / 155, alpha: 1)
                labelPaymentType.text = NSLocalizedString("Paid Online", comment: "Paid Online")
            } else {
                imageStatus.tintColor = UIColor.red
                labelPaymentType.text = NSLocalizedString("Paid at Salon", comment: "Paid at Salon")
            }
            
            btnCancel.isHidden = false
            btnCancel.setTitle(NSLocalizedString("Reject", comment: "Reject"), for: .normal)
            bottomConstrant.constant = 83
            viewLine.isHidden = false
            
            btnReschedule.isHidden = false
            btnReschedule.setTitle(NSLocalizedString("Accept", comment: "Accept"), for: .normal)
            
            
            labelSaloon.text = objRequest?.salonName ?? ""
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: objRequest?.bookingDate ?? "") ?? Date()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            labelDate.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "hh:mm a"
            let date1 = dateFormatter.date(from: objRequest?.bookingTime ?? "")
            dateFormatter.dateFormat = "HH:mm"
            labelTime.text = "\(dateFormatter.string(from: date1!) )"
            
//            labelDate.text = objRequest?.bookingDate ?? ""
//            labelTime.text = objRequest?.bookingTime ?? ""
            var str = ""
            for i in objRequest?.bookingJson?.salonServices ?? [] {
                if str == "" {
                    str = i.serviceName ?? ""
                } else {
                    str = "\(str), \(i.serviceName ?? "")"
                }
            }
            labelService.text = str
            
            labelImage.sd_setImage(with: URL(string:  objRequest?.user?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            labelTitle.text = objRequest?.user?.name ?? ""
            
            var mobileNumer = objRequest?.user?.countryCodePhone ?? ""
            let intLetters = mobileNumer.prefix(2)
            let endLetters = mobileNumer.suffix(2)

            let newString = intLetters + "*******" + endLetters   //"+91*******21"
            
            labelSubTitle.text = "\(newString)"
            labelStatus.text = NSLocalizedString("Pending", comment: "Pending")
            
//            if ((objRequest?.status ?? 0) == 4) {
//                if objRequest?.paymentMethod ?? 0 == 1 {
//                    labelPaymentTYpe.text = "Paid Online"
//                } else {
//                    labelPaymentTYpe.text = "Paid at Salon"
//                }
//            } else {
//                labelPaymentTYpe.text = ""
//            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

