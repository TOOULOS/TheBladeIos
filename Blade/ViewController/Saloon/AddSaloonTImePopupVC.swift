//
//  AddSaloonTImePopupVC.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit

extension Numeric where Self: LosslessStringConvertible {
    var digits: [Int] { string.digits }
}

extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

class AddSaloonTImePopupVC: UIViewController {
//
    @IBOutlet weak var labelWorking: UILabel!
    fileprivate var arr = [NSLocalizedString("Sunday", comment: "Sunday"),
                           NSLocalizedString("Monday", comment: "Monday"),
                           NSLocalizedString("Tuesday", comment: "Tuesday"),
                           NSLocalizedString("Wednesday", comment: "Wednesday"),
                           NSLocalizedString("Thursday", comment: "Thursday"),
                           NSLocalizedString("Friday", comment: "Friday"),
                           NSLocalizedString("Saturday", comment: "Saturday")]
    @IBOutlet weak var pickerEnd: UIDatePicker!
    @IBOutlet weak var pickerStart: UIDatePicker!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    var onSubmit: ((String, String, Int, Bool) -> (Void))?
    var index: Int = 0
    var selectedType: Bool = true
    var startTime: String = ""
    var endTime: String = ""
    
    var start1Time: String = ""
    var end1Time: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDay.text = arr[(index.digits.first ?? 0) - 1]
        
        pickerEnd.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        pickerStart.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        if start1Time != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            dateFormatter.dateFormat = "HH:mm"
            let start1 = dateFormatter.date(from: start1Time) ?? Date()
            pickerStart.date = start1
            
            
            let start2 = dateFormatter.date(from: end1Time) ?? Date()
            pickerEnd.date = start2
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            dateFormatter.dateFormat = "HH:mm"
            let start1 = dateFormatter.date(from: "00:00") ?? Date()
            pickerStart.date = start1
            
            
            let start2 = dateFormatter.date(from: "00:00") ?? Date()
            pickerEnd.date = start2
        }
        if index.digits.count == 2 || index.digits.count == 3 {
            btnSwitch.isHidden = false
            labelWorking.text = NSLocalizedString("Break", comment: "Break")
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.dateFormat = "yyyy-dd-MM HH:mm"
//            let date = dateFormatter.date(from: "2023-23-01 \(startTime ?? "")") ?? Date()
//            let date1 = dateFormatter.date(from: "2023-23-01 \(endTime ?? "")") ?? Date()
//            pickerStart.minimumDate = date
//            pickerEnd.maximumDate = date1
        } else {
            btnSwitch.isHidden = false
        }
        
                                        
        
        btnSwitch.isOn = selectedType
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickSave(_ sender: UIButton) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter1.dateFormat = "HH:mm"
        let start1 = dateFormatter1.date(from: startTime) ?? Date()
        let end1 = dateFormatter1.date(from: endTime) ?? Date()
        
        let start = dateFormatter1.string(for: pickerStart.date) ?? ""
        let end = dateFormatter1.string(for: pickerEnd.date) ?? ""
        
        let start2 = dateFormatter1.date(from: start) ?? Date()
        let end2 = dateFormatter1.date(from: end) ?? Date()
        
        if btnSwitch.isOn == false {
            onSubmit?("", "", index, btnSwitch.isOn)
            self.dismiss(animated: true, completion: nil)
        } else if pickerStart.date >= pickerEnd.date {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter accurate date", comment: "Please enter accurate date"))
        } else if startTime != "" && start1 > start2 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter accurate date", comment: "Please enter accurate date"))
        } else if endTime != "" && end1 < end2 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter accurate date", comment: "Please enter accurate date"))
        } else {
            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm"
//            let start1 = dateFormatter.string(for: pickerStart.date) ?? ""
//            let end = dateFormatter.string(for: pickerEnd.date) ?? ""
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            dateFormatter.dateFormat = "hh:mm a"
            let start = dateFormatter.string(for: pickerStart.date) ?? ""
            let end = dateFormatter.string(for: pickerEnd.date) ?? ""
            
            onSubmit?(start, end, index, btnSwitch.isOn)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
