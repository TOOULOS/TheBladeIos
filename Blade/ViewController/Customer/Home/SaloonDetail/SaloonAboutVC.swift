//
//  SaloonAboutVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit
import CoreLocation

class SaloonAboutVC: UIViewController {
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelPhoneTitle: UILabel!
    @IBOutlet weak var labelSaloonName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    var objModle: SaloonDetailModel?
    @IBOutlet weak var labelInformation: UILabel!
    
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelOpeningTIme: UILabel!
    @IBOutlet weak var viewWednesdat: UIView!
    @IBOutlet weak var viewMondey: UIView!
    @IBOutlet weak var viewTuesday: UIView!
    @IBOutlet weak var viewSunday: UIView!
    
    @IBOutlet weak var viewSaturday: UIView!
    @IBOutlet weak var viewFriday: UIView!
    @IBOutlet weak var viewThursday: UIView!
    
    
    @IBOutlet weak var btnEditProfileHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnEditProfile: CustomButton!
    @IBOutlet weak var labelSunday: UILabel!
    @IBOutlet weak var labelSaturday: UILabel!
    @IBOutlet weak var labelFriday: UILabel!
    @IBOutlet weak var labelWednesday: UILabel!
    @IBOutlet weak var labelThursday: UILabel!
    @IBOutlet weak var labelTuesday: UILabel!
    @IBOutlet weak var labelMonday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    @IBAction func onClickEditProfile(_ sender: UIButton) {
        if UserPreference.shared.data?.role == 3 {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vw = story.instantiateViewController(withIdentifier: "AddSaloonStylistVC") as! AddSaloonStylistVC
            vw.type = .edit
            self.navigationController?.pushViewController(vw, animated: true)
        } else {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vw = story.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(vw, animated: true)
        }
        
    }
    

    func setupData() {
        if UserPreference.shared.data?.role == 3 {
            labelSaloonName.numberOfLines = 2
            labelSaloonName.text = "\(UserPreference.shared.data?.name ?? "")\n\(UserPreference.shared.data?.salonName ?? "")"
            labelAddress.text = UserPreference.shared.data?.salonLocation ?? ""
            labelDescription.text = UserPreference.shared.data?.bio ?? ""
            self.viewContact.isHidden = false
            self.viewWednesdat.isHidden = true
            self.viewMondey.isHidden = true
            self.viewTuesday.isHidden = true
            self.viewSunday.isHidden = true
            self.viewSaturday.isHidden = true
            self.viewFriday.isHidden = true
            self.viewThursday.isHidden = true
            labelInformation.text = NSLocalizedString("About", comment: "About")
            btnEditProfile.isHidden = false
            btnEditProfileHeightConstant.constant = 48
            labelOpeningTIme.text = NSLocalizedString("Contact", comment: "Contact")
            labelContact.text = UserPreference.shared.data?.phone ?? ""
        } else if UserPreference.shared.data?.role == 2 {
            labelSaloonName.text = UserPreference.shared.data?.salonName ?? ""
            labelAddress.text = UserPreference.shared.data?.location ?? ""
            labelDescription.text = UserPreference.shared.data?.salonDescription ?? ""
            btnEditProfile.isHidden = false
            btnEditProfileHeightConstant.constant = 48
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
            labelPhoneTitle.isHidden = false
            labelPhone.isHidden = false
            if (UserPreference.shared.data?.countryCode ?? "").contains("+") {
                labelPhone.text = "\(UserPreference.shared.data?.countryCode ?? "") \(UserPreference.shared.data?.phone ?? "")"
            } else {
                labelPhone.text = "+\(UserPreference.shared.data?.countryCode ?? "") \(UserPreference.shared.data?.phone ?? "")"
            }
            
            
            for i in UserPreference.shared.data?.salonTimings ?? [] {
                if i.day == "Monday" {
                    if i.isClosed == 1 {
                        labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "mon" {
                    if i.isClosed == 1 {
                        labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "tue" {
                    if i.isClosed == 1 {
                        labelTuesday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "wed" {
                    if i.isClosed == 1 {
                        labelWednesday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "thu" {
                    if i.isClosed == 1 {
                        labelThursday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "fri" {
                    if i.isClosed == 1 {
                        labelFriday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "sat" {
                    if i.isClosed == 1 {
                        labelSaturday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
                
                if i.day == "sun" {
                    if i.isClosed == 1 {
                        labelSunday.text = NSLocalizedString("Closed", comment: "Closed")
                    } else {
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: i.startTime ?? "")
                        let date1 = dateFormatter.date(from: i.endTime ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        if i.breakStartTime1 == "" {
                            labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                        } else if i.breakStartTime2 == "" {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                            let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                            let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                            let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                        }
                        
                    }
                }
            }
        } else {
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            labelAddress.text = objModle?.location ?? ""
            if objModle?.salonDescription ?? "" == "" {
                
                let attrs1 = [NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue-Medium", size: 20), NSAttributedString.Key.foregroundColor : UIColor.white]
                
                let attrs2 = [NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue-Medium", size: 20), NSAttributedString.Key.foregroundColor : UIColor.init(named: "Color_button")]
                
                let attributedString1 = NSMutableAttributedString(string:"\(objModle?.name ?? "")\n\n", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:"\(objModle?.salonName ?? "")", attributes:attrs2)
                
                attributedString1.append(attributedString2)
                self.labelSaloonName.attributedText = attributedString1
                
              //  labelSaloonName.text = "\(objModle?.name ?? "")\n\(objModle?.salonName ?? "")"
                labelDescription.text = objModle?.bio ?? ""
                for i in objModle!.salon?.salonTimings ?? [] {
                    if i.day == "Monday" {
                        if i.isClosed == 1 {
                            labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "mon" {
                        if i.isClosed == 1 {
                            labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "tue" {
                        if i.isClosed == 1 {
                            labelTuesday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "wed" {
                        if i.isClosed == 1 {
                            labelWednesday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "thu" {
                        if i.isClosed == 1 {
                            labelThursday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "fri" {
                        if i.isClosed == 1 {
                            labelFriday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "sat" {
                        if i.isClosed == 1 {
                            labelSaturday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "sun" {
                        if i.isClosed == 1 {
                            labelSunday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                }
            } else {
                let dateFormatter = DateFormatter()
                
                labelPhoneTitle.isHidden = false
                labelPhone.isHidden = false
                if (objModle?.countryCode ?? "").contains("+") {
                    labelPhone.text = "\(objModle?.countryCode ?? "") \(objModle?.phone ?? "")"
                } else {
                    labelPhone.text = "+\(objModle?.countryCode ?? "") \(objModle?.phone ?? "")"
                }
                
                
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                labelSaloonName.text = objModle?.salonName ?? ""
                labelDescription.text = objModle?.salonDescription ?? ""
                for i in objModle!.salonTimings ?? [] {
                    if i.day == "Monday" {
                        if i.isClosed == 1 {
                            labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "mon" {
                        if i.isClosed == 1 {
                            labelMonday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelMonday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "tue" {
                        if i.isClosed == 1 {
                            labelTuesday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelTuesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "wed" {
                        if i.isClosed == 1 {
                            labelWednesday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelWednesday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "thu" {
                        if i.isClosed == 1 {
                            labelThursday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelThursday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "fri" {
                        if i.isClosed == 1 {
                            labelFriday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelFriday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "sat" {
                        if i.isClosed == 1 {
                            labelSaturday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSaturday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                    
                    if i.day == "sun" {
                        if i.isClosed == 1 {
                            labelSunday.text = NSLocalizedString("Closed", comment: "Closed")
                        } else {
                            dateFormatter.dateFormat = "h:mm a"
                            let date = dateFormatter.date(from: i.startTime ?? "")
                            let date1 = dateFormatter.date(from: i.endTime ?? "")
                            dateFormatter.dateFormat = "HH:mm"
                            if i.breakStartTime1 == "" {
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date1!) )"
                            } else if i.breakStartTime2 == "" {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date1!))"
                            } else {
                                dateFormatter.dateFormat = "h:mm a"
                                let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                                let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                                let date4 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                                let date5 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                labelSunday.text = "\(dateFormatter.string(from: date!) ) - \(dateFormatter.string(from: date2!)) / \(dateFormatter.string(from: date3!) ) - \(dateFormatter.string(from: date4!)) / \(dateFormatter.string(from: date5!) ) - \(dateFormatter.string(from: date1!))"
                            }
                            
                        }
                    }
                }
            }
            
            
            
        }
        
    }
    
    @IBAction func onClickLocation(_ sender: UIButton) {
        
        let geocoder = CLGeocoder()
        var str = labelAddress.text!
        geocoder.geocodeAddressString(str) { (placemarksOptional, error) -> Void in
            if let placemarks = placemarksOptional {
                print("placemark| \(placemarks.first)")
                if let location = placemarks.first?.location {
                    let query = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    let path = "http://maps.apple.com/?daddr=" + query
                    if let url = NSURL(string: path) {
                        UIApplication.shared.openURL(url as URL)
                    } else {
                        // Could not construct url. Handle error.
                    }
                } else {
                    // Could not get a location from the geocode request. Handle error.
                }
            } else {
                let path = "http://maps.apple.com/?daddr=" + "\(str.addingPercentEncodingForQueryParameter()!)"
                let postString = "Message=\(str.addingPercentEncodingForQueryParameter()!)"

                if let url = NSURL(string: path) {
                    UIApplication.shared.openURL(url as URL)
                } else {
                    // Could not construct url. Handle error.
                }
                // Didn't get any placemarks. Handle error.
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    public func addingPercentEncodingForQueryParameter() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()
}
