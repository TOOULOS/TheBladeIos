//
//  AddSaloonTimingVC.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit

class AddSaloonTimingVC: UIViewController {
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var textFieldWednesday: UITextField!
    @IBOutlet weak var textFieldWednesdayBreakOne: UITextField!
    @IBOutlet weak var textFieldWednesdayBreakTwo: UITextField!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var textFieldSunday: UITextField!
    @IBOutlet weak var textFieldSundayBreakTwo: UITextField!
    @IBOutlet weak var textFieldSundayBreakOne: YourTextFieldSubclass!
    
    @IBOutlet weak var textFieldSaturday: UITextField!
    @IBOutlet weak var textFieldSaturdayBreakOne: UITextField!
    @IBOutlet weak var textFieldSaturdayBreakTwo: UITextField!
    
    
    
    @IBOutlet weak var textFieldFriday: UITextField!
    @IBOutlet weak var textFieldFridayBreakOne: UITextField!
    @IBOutlet weak var textFieldFridayBreakTwo: UITextField!
    
    @IBOutlet weak var textFIeldThursday: UITextField!
    @IBOutlet weak var textFieldThursdayBreakOne: UITextField!
    @IBOutlet weak var textFieldThursdayBreakTwo: UITextField!
    
    @IBOutlet weak var textFieldTuesday: UITextField!
    @IBOutlet weak var textFieldTuesdayBreakOne: UITextField!
    @IBOutlet weak var textFieldTuesdayBreakTwo: UITextField!
    
    @IBOutlet weak var textFieldMonday: UITextField!
    @IBOutlet weak var textFieldMondayBreakOne: YourTextFieldSubclass!
    @IBOutlet weak var textFieldMondayBreakTwo: UITextField!
    var type: TimingType = .signup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .editProfile {
            self.setUpData()
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        
        labelTitle.text = NSLocalizedString("Update Salon Timings", comment: "Update Salon Timings")
        btnNext.isHidden = true
        btnRepeat.isHidden = false

        for i in UserPreference.shared.data?.salonTimings ?? [] {
            if i.dayId ?? 0 == 1 {
                if i.isClosed == 1 {
                    textFieldSunday.text = NSLocalizedString("Closed", comment: "Closed")
                    textFieldSundayBreakOne.text = NSLocalizedString("Closed", comment: "Closed")
                    textFieldSundayBreakTwo.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldSundayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldSundayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    textFieldSunday.text = "\(lbStart ) - \(lbEnd)"
                }
            }
            
            if i.dayId ?? 0 == 2 {
                if i.isClosed == 1 {
                    textFieldMonday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldMondayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldMondayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    textFieldMonday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
            
            if i.dayId ?? 0 == 3 {
                if i.isClosed == 1 {
                    textFieldTuesday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldTuesdayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldTuesdayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    textFieldTuesday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
            
            if i.dayId ?? 0 == 4 {
                if i.isClosed == 1 {
                    textFieldWednesday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldWednesdayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldWednesdayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    
                    textFieldWednesday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
            
            if i.dayId ?? 0 == 5 {
                if i.isClosed == 1 {
                    textFIeldThursday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldThursdayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldThursdayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    
                    textFIeldThursday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
            
            if i.dayId ?? 0 == 6 {
                if i.isClosed == 1 {
                    textFieldFriday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldFridayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldFridayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    
                    textFieldFriday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
            
            if i.dayId ?? 0 == 7 {
                if i.isClosed == 1 {
                    textFieldSaturday.text = NSLocalizedString("Closed", comment: "Closed")
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                    let date = dateFormatter.date(from: i.startTime ?? "")
                    let date1 = dateFormatter.date(from: i.endTime ?? "")
                    
                    if i.breakStartTime1 ?? "" != "" {
                        let date2 = dateFormatter.date(from: i.breakStartTime1 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime1 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldSaturdayBreakOne.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    if i.breakStartTime2 ?? "" != "" {
                        dateFormatter.dateFormat = "h:mm a"
                        let date2 = dateFormatter.date(from: i.breakStartTime2 ?? "")
                        let date3 = dateFormatter.date(from: i.breakEndTime2 ?? "")
                        dateFormatter.dateFormat = "HH:mm"
                        let lbStart = "\(dateFormatter.string(from: date2!) )"
                        let lbEnd = "\(dateFormatter.string(from: date3!) )"
                        textFieldSaturdayBreakTwo.text = "\(lbStart ) - \(lbEnd)"
                    }
                    
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let lbStart = "\(dateFormatter.string(from: date!) )"
                    let lbEnd = "\(dateFormatter.string(from: date1!) )"
                    
                    textFieldSaturday.text = "\(lbStart ?? "") - \(lbEnd ?? "")"
                }
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        if type == .editProfile {
            self.navigationController?.popViewController(animated: true)
        } else {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please complete signup process to make your shop visible.", comment: "Please complete signup process to make your shop visible."))
          //  self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    @IBAction func onClickRepeat(_ sender: UIButton) {

        textFieldTuesday.text = textFieldMonday.text!
        textFieldTuesdayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldTuesdayBreakTwo.text = textFieldMondayBreakTwo.text!
        
        textFieldWednesday.text = textFieldMonday.text!
        textFieldWednesdayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldWednesdayBreakTwo.text = textFieldMondayBreakTwo.text!
        
        textFIeldThursday.text = textFieldMonday.text!
        textFieldThursdayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldThursdayBreakTwo.text = textFieldMondayBreakTwo.text!
        
        textFieldFriday.text = textFieldMonday.text!
        textFieldFridayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldFridayBreakTwo.text = textFieldMondayBreakTwo.text!
        
        textFieldSaturday.text = textFieldMonday.text!
        textFieldSaturdayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldSaturdayBreakTwo.text = textFieldMondayBreakTwo.text!
        
        textFieldSunday.text = textFieldMonday.text!
        textFieldSundayBreakOne.text = textFieldMondayBreakOne.text!
        textFieldSundayBreakTwo.text = textFieldMondayBreakTwo.text!
        if type == .editProfile {
            let obj = (UserPreference.shared.data?.salonTimings ?? []).filter { val in
                val.day == "mon"
            }

            let nonMondayArray = (UserPreference.shared.data?.salonTimings ?? []).filter { val in
                val.day != "mon"
            }

            for i in nonMondayArray {
                SignupEP.updateSalonTimings(id: "\(i.id ?? 0)", startTime: obj.first?.startTime ?? "", endTime: obj.first?.endTime ?? "", isClosed: obj.first?.isClosed ?? 0 ,breakStartTime1: obj.first?.breakStartTime1 ?? "" ,breakEndTime1: obj.first?.breakEndTime1 ?? "" ,breakStartTime2: obj.first?.breakStartTime2 ?? "" ,breakEndTime2: obj.first?.breakEndTime2 ?? "").request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SignupModel> else { return }
                        if data.code == 200{
                            UserPreference.shared.data = data.data
                        }
                    }
                } error: { error in

                }
            }
        }
    }
    
    
    @IBAction func onClickNext(_ sender: UIButton) {
        if textFieldMonday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter monday timing", comment: "Please enter monday timing"))
        } else if textFieldTuesday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter tuesday timing", comment: "Please enter tuesday timing"))
        } else if textFieldWednesday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter wednesday timing", comment: "Please enter wednesday timing"))
        } else if textFIeldThursday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter thursday timing", comment: "Please enter thursday timing"))
        } else if textFieldFriday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter friday timing", comment: "Please enter friday timing"))
        } else if textFieldSaturday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter saturday timing", comment: "Please enter saturday timing"))
        } else if textFieldSunday.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter sunday timing", comment: "Please enter sunday timing"))
        } else {
            
            var sunday: [String: String] = [:]
            var mon: [String: String] = [:]
            var tues: [String: String] = [:]
            var wed: [String: String] = [:]
            var thur: [String: String] = [:]
            var frid: [String: String] = [:]
            var sat: [String: String] = [:]
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            
            
            if textFieldSunday.text! == NSLocalizedString("Closed", comment: "Closed") {
                sunday = ["dayId": "1", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldSunday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldSunday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldSundayBreakOne.text == "") && (textFieldSundayBreakTwo.text == "") {
                    sunday = ["dayId": "1", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldSundayBreakOne.text != "") && (textFieldSundayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldSundayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldSundayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldSundayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldSundayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    sunday = ["dayId": "1", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldSundayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldSundayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldSundayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    sunday = ["dayId": "1", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldSundayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldSundayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldSundayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    sunday = ["dayId": "1", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            if textFieldMonday.text! == NSLocalizedString("Closed", comment: "Closed") {
                mon = ["dayId": "2", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldMonday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldMonday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldMondayBreakOne.text == "") && (textFieldMondayBreakTwo.text == "") {
                    mon = ["dayId": "2", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldMondayBreakOne.text != "" ) && (textFieldMondayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldMondayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldMondayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldMondayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldMondayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    mon = ["dayId": "2", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldMondayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldMondayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldMondayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    mon = ["dayId": "2", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldMondayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldMondayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldMondayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    mon = ["dayId": "2", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
            }
            
            
            if textFieldTuesday.text! == NSLocalizedString("Closed", comment: "Closed") {
                tues = ["dayId": "3", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldTuesday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldTuesday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldTuesdayBreakOne.text == "") && (textFieldTuesdayBreakTwo.text == "") {
                    tues = ["dayId": "3", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldTuesdayBreakOne.text != "" ) && (textFieldTuesdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldTuesdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldTuesdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    tues = ["dayId": "3", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldTuesdayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldTuesdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldTuesdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    tues = ["dayId": "3", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldTuesdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    tues = ["dayId": "3", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            
            if textFieldWednesday.text! == NSLocalizedString("Closed", comment: "Closed") {
                wed = ["dayId": "4", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldWednesday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldWednesday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldWednesdayBreakOne.text == "") && (textFieldWednesdayBreakTwo.text == "") {
                    wed = ["dayId": "4", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldWednesdayBreakOne.text != "") && (textFieldWednesdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    wed = ["dayId": "4", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldWednesdayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    wed = ["dayId": "4", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldWednesdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    wed = ["dayId": "4", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            if textFIeldThursday.text! == NSLocalizedString("Closed", comment: "Closed") {
                thur = ["dayId": "5", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFIeldThursday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFIeldThursday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldThursdayBreakOne.text == "") && (textFieldThursdayBreakTwo.text == "") {
                    thur = ["dayId": "5", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldThursdayBreakOne.text != "") && (textFieldThursdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldThursdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldThursdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    thur = ["dayId": "5", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldThursdayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldThursdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldThursdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    thur = ["dayId": "5", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldThursdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    thur = ["dayId": "5", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            if textFieldFriday.text! == NSLocalizedString("Closed", comment: "Closed") {
                frid = ["dayId": "6", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldFriday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldFriday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldFridayBreakOne.text == "") && (textFieldFridayBreakTwo.text == "") {
                    frid = ["dayId": "6", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldFridayBreakOne.text != "") && (textFieldFridayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldFridayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldFridayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldFridayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldFridayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    frid = ["dayId": "6", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldFridayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldFridayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldFridayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    frid = ["dayId": "6", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldFridayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldFridayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldFridayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    frid = ["dayId": "6", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            if textFieldSaturday.text! == NSLocalizedString("Closed", comment: "Closed") {
                sat = ["dayId": "7", "startTime": "", "endTime": "", "isClosed": "1"]
            } else {
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: textFieldSaturday.text!.components(separatedBy: " - ").first ?? "")
                let date1 = dateFormatter.date(from: textFieldSaturday.text!.components(separatedBy: " - ").last ?? "")
                dateFormatter.dateFormat = "h:mm a"
                let lbStart = "\(dateFormatter.string(from: date!) )"
                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                
                if (textFieldSaturdayBreakOne.text == "") && (textFieldSaturdayBreakTwo.text == "") {
                    sat = ["dayId": "7", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0"]
                } else if (textFieldSaturdayBreakOne.text != "") && (textFieldSaturdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    let date2 = dateFormatter.date(from: textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    sat = ["dayId": "7", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne, "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                } else if (textFieldSaturdayBreakOne.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date = dateFormatter.date(from: textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").first ?? "")
                    let date1 = dateFormatter.date(from: textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").last ?? "")
                    
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    
                    
                    sat = ["dayId": "7", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime1": lbStartOne, "breakEndTime1": lbEndOne]
                } else if (textFieldSaturdayBreakTwo.text != "") {
                    
                    dateFormatter.dateFormat = "HH:mm"
                    let date2 = dateFormatter.date(from: textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").first ?? "")
                    let date3 = dateFormatter.date(from: textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").last ?? "")
                    dateFormatter.dateFormat = "h:mm a"
                    let lbStartOne = "\(dateFormatter.string(from: date!) )"
                    let lbEndOne = "\(dateFormatter.string(from: date1!) )"
                    let lbStarttwo = "\(dateFormatter.string(from: date2!) )"
                    let lbEndTwo = "\(dateFormatter.string(from: date3!) )"
                    
                    sat = ["dayId": "7", "startTime": lbStart, "endTime": lbEnd, "isClosed": "0", "breakStartTime2": lbStarttwo, "breakEndTime2": lbEndTwo]
                }
                
            }
            
            
            let string = [sunday,
                          mon,
                          tues,
                          wed,
                          thur,
                          frid,
                          sat]
            SignupEP.salonSignupStep3AddSalonTimings(salonTimings: string).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonServiceVC") as! AddSaloonServiceVC
                        self.navigationController?.pushViewController(vw, animated: true)
                    }
                }
            } error: { error in
                
            }

        }
    }
    
    @IBAction func onClickDate(_ sender: UIButton) {
        let obj = (UserPreference.shared.data?.salonTimings ?? []).filter { val in
            val.dayId == (sender.tag.digits.first ?? 0)
        }
        
        
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonTImePopupVC") as! AddSaloonTImePopupVC
        vw.index = sender.tag
        if sender.tag.digits.count != 1 {
            if sender.tag.digits.count == 2 {
                if sender.tag == 11 {
                    vw.startTime = textFieldSunday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldSunday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldSundayBreakOne.text! != "" {
                        vw.start1Time = textFieldSundayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldSundayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 22 {
                    vw.startTime = textFieldMonday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldMonday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldMondayBreakOne.text! != "" {
                        vw.start1Time = textFieldMondayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldMondayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 33 {
                    vw.startTime = textFieldTuesday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldTuesday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldThursdayBreakOne.text! != "" {
                        vw.start1Time = textFieldThursdayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldThursdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 44 {
                    vw.startTime = textFieldWednesday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldWednesday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldWednesdayBreakOne.text! != "" {
                        vw.start1Time = textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 55 {
                    vw.startTime = textFIeldThursday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFIeldThursday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldThursdayBreakOne.text! != "" {
                        vw.start1Time = textFieldThursdayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldThursdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 66 {
                    vw.startTime = textFieldFriday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldFriday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldFridayBreakOne.text! != "" {
                        vw.start1Time = textFieldFridayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldFridayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 77 {
                    vw.startTime = textFieldSaturday.text!.components(separatedBy: " - ").first ?? ""
                    vw.endTime = textFieldSaturday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldSaturdayBreakOne.text! != "" {
                        vw.start1Time = textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
            } else if sender.tag.digits.count == 3 {
                if sender.tag == 111 {
                    vw.startTime = textFieldSundayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldSunday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldSundayBreakTwo.text! != "" {
                        vw.start1Time = textFieldSundayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldSundayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 222 {
                    vw.startTime = textFieldMondayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldMonday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldMondayBreakTwo.text! != "" {
                        vw.start1Time = textFieldMondayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldMondayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 333 {
                    vw.startTime = textFieldTuesdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldTuesday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldTuesdayBreakTwo.text! != "" {
                        vw.start1Time = textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldTuesdayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 444 {
                    vw.startTime = textFieldWednesdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldWednesday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldWednesdayBreakTwo.text! != "" {
                        vw.start1Time = textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldWednesdayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 555 {
                    vw.startTime = textFieldThursdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFIeldThursday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldThursdayBreakTwo.text! != "" {
                        vw.start1Time = textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldThursdayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 666 {
                    vw.startTime = textFieldFridayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldFriday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldFridayBreakTwo.text! != "" {
                        vw.start1Time = textFieldFridayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldFridayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
                if sender.tag == 777 {
                    vw.startTime = textFieldSaturdayBreakOne.text!.components(separatedBy: " - ").last ?? ""
                    vw.endTime = textFieldSaturday.text!.components(separatedBy: " - ").last ?? ""
                    
                    if textFieldSaturdayBreakTwo.text! != "" {
                        vw.start1Time = textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").first ?? ""
                        vw.end1Time = textFieldSaturdayBreakTwo.text!.components(separatedBy: " - ").last ?? ""
                    }
                }
                
            }
        } else {
            
            if sender.tag == 1 {
                if textFieldSunday.text! != "" {
                    vw.start1Time = textFieldSunday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldSunday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 2 {
                if textFieldMonday.text! != "" {
                    vw.start1Time = textFieldMonday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldMonday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 3 {
                if textFieldTuesday.text! != "" {
                    vw.start1Time = textFieldTuesday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldTuesday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 4 {
                if textFieldWednesday.text! != "" {
                    vw.start1Time = textFieldWednesday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldWednesday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 5 {
                if textFIeldThursday.text! != "" {
                    vw.start1Time = textFIeldThursday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFIeldThursday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 6 {
                if textFieldFriday.text! != "" {
                    vw.start1Time = textFieldFriday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldFriday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            if sender.tag == 7 {
                if textFieldSaturday.text! != "" {
                    vw.start1Time = textFieldSaturday.text!.components(separatedBy: " - ").first ?? ""
                    vw.end1Time = textFieldSaturday.text!.components(separatedBy: " - ").last ?? ""
                }
            }
            
            
        }
        if type == .editProfile {
            vw.selectedType = (obj.first?.isClosed ?? 0) == 1 ? false :  true
//            vw.startTime = obj.first?.startTime ?? ""
//            vw.endTime = obj.first?.endTime ?? ""
        }
        if (sender.tag == 11 || sender.tag == 111) && (textFieldSunday.text == "" || textFieldSunday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 22 || sender.tag == 222) && (textFieldMonday.text == "" || textFieldMonday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 33 || sender.tag == 333) && (textFieldTuesday.text == "" || textFieldTuesday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 44 || sender.tag == 444) && (textFieldWednesday.text == "" || textFieldWednesday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 55 || sender.tag == 555) && (textFIeldThursday.text == "" || textFIeldThursday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 66 || sender.tag == 666) && (textFieldFriday.text == "" || textFieldFriday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        } else if  (sender.tag == 77 || sender.tag == 777) && (textFieldSaturday.text == "" || textFieldSaturday.text == NSLocalizedString("Closed", comment: "Closed")) {
            return
        }
        vw.onSubmit = { [weak self] (start, end, index, type) in
            if type == true {
               
                if self?.type == .editProfile {
                    if sender.tag.digits.count == 1 {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: start, endTime: end, isClosed: 0,breakStartTime1: "",breakEndTime1: "",breakStartTime2: "",breakEndTime2: "").request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    } else if sender.tag.digits.count == 2 {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: "\(obj.first?.startTime ?? "")", endTime: "\(obj.first?.endTime ?? "")", isClosed: 0,breakStartTime1: start,breakEndTime1: end,breakStartTime2: "",breakEndTime2: "").request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    } else if sender.tag.digits.count == 3 {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: "\(obj.first?.startTime ?? "")", endTime: "\(obj.first?.endTime ?? "")", isClosed: 0,breakStartTime1: "\(obj.first?.breakStartTime1 ?? "")",breakEndTime1: "\(obj.first?.breakEndTime1 ?? "")",breakStartTime2: start,breakEndTime2: end).request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    }
                    
                }

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "h:mm a"
                let date = dateFormatter.date(from: start ?? "") ?? Date()
                let date1 = dateFormatter.date(from: end ?? "") ?? Date()
                dateFormatter.dateFormat = "HH:mm"
                let lbStart = "\(dateFormatter.string(from: date) )"
                let lbEnd = "\(dateFormatter.string(from: date1) )"
                
                
                if index == 2 {
                    self?.textFieldMonday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldMondayBreakOne.text = ""
                    self?.textFieldMondayBreakTwo.text = ""
                } else if index == 22 {
                    self?.textFieldMondayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldMondayBreakTwo.text = ""
                } else if index == 222 {
                    self?.textFieldMondayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 3 {
                    self?.textFieldTuesday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldTuesdayBreakTwo.text = ""
                    self?.textFieldTuesdayBreakOne.text = ""
                } else if index == 33 {
                    self?.textFieldTuesdayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldTuesdayBreakTwo.text = ""
                } else if index == 333 {
                    self?.textFieldTuesdayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 4 {
                    self?.textFieldWednesday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldWednesdayBreakOne.text = ""
                    self?.textFieldWednesdayBreakTwo.text = ""
                } else if index == 44 {
                    self?.textFieldWednesdayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldWednesdayBreakTwo.text = ""
                } else if index == 444 {
                    self?.textFieldWednesdayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 5 {
                    self?.textFIeldThursday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldThursdayBreakOne.text = ""
                    self?.textFieldThursdayBreakTwo.text = ""
                } else if index == 55 {
                    self?.textFieldThursdayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldThursdayBreakTwo.text = ""
                } else if index == 555 {
                    self?.textFieldThursdayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 6 {
                    self?.textFieldFriday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldFridayBreakTwo.text = ""
                    self?.textFieldFridayBreakOne.text = ""
                } else if index == 66 {
                    self?.textFieldFridayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldFridayBreakTwo.text = ""
                } else if index == 666 {
                    self?.textFieldFridayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 7 {
                    self?.textFieldSaturday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldSaturdayBreakOne.text = ""
                    self?.textFieldSaturdayBreakTwo.text = ""
                } else if index == 77 {
                    self?.textFieldSaturdayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldSaturdayBreakTwo.text = ""
                } else if index == 777 {
                    self?.textFieldSaturdayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                } else if index == 1 {
                    self?.textFieldSunday.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldSundayBreakOne.text = ""
                    self?.textFieldSundayBreakTwo.text = ""
                } else if index == 11 {
                    self?.textFieldSundayBreakOne.text = "\(lbStart) - \(lbEnd)"
                    self?.textFieldSundayBreakTwo.text = ""
                } else if index == 111 {
                    self?.textFieldSundayBreakTwo.text = "\(lbStart) - \(lbEnd)"
                }
            } else {
                if self?.type == .editProfile {
                    if index <  9 {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: "", endTime: "", isClosed: 1,breakStartTime1: "",breakEndTime1: "",breakStartTime2: "",breakEndTime2: "").request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    } else if index >  20 {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: "", endTime: "", isClosed: 2,breakStartTime1: "",breakEndTime1: "",breakStartTime2: "",breakEndTime2: "").request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    }else {
                        SignupEP.updateSalonTimings(id: "\(obj.first?.id ?? 0)", startTime: "", endTime: "", isClosed: 0,breakStartTime1: "",breakEndTime1: "",breakStartTime2: "",breakEndTime2: "").request(showSpinner: true) { response in
                            if response != nil{
                                guard let data = response as? ObjectData<SignupModel> else { return }
                                if data.code == 200{
                                    UserPreference.shared.data = data.data
                                }
                            }
                        } error: { error in
                            
                        }
                    }
                    
                }
                if index == 2 {
                    self?.textFieldMonday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldMondayBreakOne.text = ""
                    self?.textFieldMondayBreakTwo.text = ""
                } else if index == 22 {
                    self?.textFieldMondayBreakOne.text = ""
                } else if index == 222 {
                    self?.textFieldMondayBreakTwo.text = ""
                } else if index == 3 {
                    self?.textFieldTuesday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldTuesdayBreakOne.text = ""
                    self?.textFieldTuesdayBreakTwo.text = ""
                } else if index == 33 {
                    self?.textFieldTuesdayBreakOne.text = ""
                } else if index == 333 {
                    self?.textFieldTuesdayBreakTwo.text = ""
                } else if index == 4 {
                    self?.textFieldWednesday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldWednesdayBreakOne.text = ""
                    self?.textFieldWednesdayBreakTwo.text = ""
                } else if index == 44 {
                    self?.textFieldWednesdayBreakOne.text = ""
                } else if index == 444 {
                    self?.textFieldWednesdayBreakTwo.text = ""
                } else if index == 5 {
                    self?.textFIeldThursday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldThursdayBreakOne.text = ""
                    self?.textFieldThursdayBreakTwo.text = ""
                } else if index == 55 {
                    self?.textFieldThursdayBreakOne.text = ""
                } else if index == 555 {
                    self?.textFieldThursdayBreakTwo.text = ""
                } else if index == 6 {
                    self?.textFieldFriday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldFridayBreakOne.text = ""
                    self?.textFieldFridayBreakTwo.text = ""
                } else if index == 66 {
                    self?.textFieldFridayBreakOne.text = ""
                } else if index == 666 {
                    self?.textFieldFridayBreakTwo.text = ""
                } else if index == 7 {
                    self?.textFieldSaturday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldSaturdayBreakOne.text = ""
                    self?.textFieldSaturdayBreakTwo.text = ""
                } else if index == 77 {
                    self?.textFieldSaturdayBreakOne.text = ""
                } else if index == 777 {
                    self?.textFieldSaturdayBreakTwo.text = ""
                } else if index == 1 {
                    self?.textFieldSunday.text = NSLocalizedString("Closed", comment: "Closed")
                    self?.textFieldSundayBreakOne.text = ""
                    self?.textFieldSundayBreakTwo.text = ""
                } else if index == 11 {
                    self?.textFieldSundayBreakOne.text = ""
                } else if index == 111 {
                    self?.textFieldSundayBreakTwo.text = ""
                }
            }
        }
        self.present(vw, animated: true, completion: nil)
     }
}

enum TimingType {
    case signup
    case editProfile
}
