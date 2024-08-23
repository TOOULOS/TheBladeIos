//
//  AddManualBookingVC.swift
//  Blade
//
//  Created by cqlsys on 16/10/23.
//

import UIKit
import FSCalendar
import CountryPickerView
class AddManualBookingVC: UIViewController {
    @IBOutlet weak var calendarHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var textFieldCustomerName: YourTextFieldSubclass!
    @IBOutlet weak var textFieldPhone: YourTextFieldSubclass!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var textFieldCountryCode: YourTextFieldSubclass!
    var serviceSelectedId: String = ""
    var priceDouble: String = ""
    let cpv = CountryPickerView()
    @IBOutlet weak var labelServiceTIme: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var slotHeightConstranit: NSLayoutConstraint!
    @IBOutlet weak var labelService: UILabel!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var calendar: FSCalendar!
    var startIndex = -1
    var endIndex = -1
    var totalServiceTime: Int = 0
    var dateString: String = ""
    fileprivate var slotArray: [SlotTimeIntervalModel] = []
    var manualBookingArray: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.select(Date())
        calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar"
        calendar.locale = Locale.init(identifier: UserDefaults.standard.value(forKey: "CurrentLang1") as? String ?? "en")
        
        cpv.delegate = self
        cpv.dataSource = self
        
        textFieldCountryCode.text = "+357"
        
        cpv.setCountryByPhoneCode("+357")
        flag.image = cpv.selectedCountry.flag
        self.cv.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstrant?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if calendar.selectedDate == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.apiCall(date: dateFormatter.string(from: Date()))
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.apiCall(date: dateFormatter.string(from: calendar.selectedDate ?? Date()))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.slotHeightConstranit.constant = cv.contentSize.height
    }
    
    func apiCall(date: String) {
        startIndex = -1
        endIndex = -1
        dateString = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectDate = dateFormatter.string(from: Date())
        
        if UserPreference.shared.data?.role ?? 0 == 2 {
            SignupEP.salonSlotsDayWise(salonId: "\(UserPreference.shared.data?.id ?? 0)", salonStylistId: "0", date: date).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SlotModel> else { return }
                    if data.code == 200{
                        self.slotArray = data.data?.timeIntervals ?? []
                        if selectDate == date {
                            self.slotArray = self.slotArray.filter { val in
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.dateFormat = "h:mm a"
                                let date = dateFormatter.date(from: val.slotTime ?? "")
                                let date1 = dateFormatter.date(from: dateFormatter.string(from: Date()) ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                let lbStart = "\(dateFormatter.string(from: date!) )"
                                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                                return lbEnd <= lbStart
                            }
                        }
                        
                        
                        var staticArray: [String] = []
                        for i in self.slotArray ?? [] {
                            if i.isManual == 1 {
                                staticArray.append(i.slotTime ?? "")
                            } else {
                                if staticArray.count != 0 {
                                    self.manualBookingArray.append(staticArray)
                                    staticArray.removeAll()
                                }
                            }
                        }
                        self.cv.reloadData()
                    }
                }
            } error: { error in
                
            }
        } else {
       
            SignupEP.salonSlotsDayWise(salonId: "\(UserPreference.shared.data?.salonId ?? 0)", salonStylistId: "\(UserPreference.shared.data?.id ?? 0)", date: date).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SlotModel> else { return }
                    if data.code == 200{
                        self.slotArray = data.data?.timeIntervals ?? []
                        if selectDate == date {
                            self.slotArray = self.slotArray.filter { val in
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.dateFormat = "h:mm a"
                                let date = dateFormatter.date(from: val.slotTime ?? "")
                                let date1 = dateFormatter.date(from: dateFormatter.string(from: Date()) ?? "")
                                dateFormatter.dateFormat = "HH:mm"
                                let lbStart = "\(dateFormatter.string(from: date!) )"
                                let lbEnd = "\(dateFormatter.string(from: date1!) )"
                                return lbEnd <= lbStart
                            }
                        }
                        
                        
                        var staticArray: [String] = []
                        for i in self.slotArray ?? [] {
                            if i.isManual == 1 {
                                staticArray.append(i.slotTime ?? "")
                            } else {
                                if staticArray.count != 0 {
                                    self.manualBookingArray.append(staticArray)
                                    staticArray.removeAll()
                                }
                            }
                        }
                        self.cv.reloadData()
                    }
                }
            } error: { error in
                
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickService(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "SelectServiceVC") as! SelectServiceVC
        vw.modalPresentationStyle = .overFullScreen
        vw.type = .addBooking
        if UserPreference.shared.data?.role ?? 0 == 2 {
            vw.serviceArray = UserPreference.shared.data?.salonServices ?? []
        } else {
            vw.serviceArray = UserPreference.shared.data?.salonServices ?? []
        }
        
        vw.onBackWithPrice = { [weak self] (serviceName, serviceID, price, time) in
            self?.serviceSelectedId = serviceID
            self?.labelService.text = serviceName
            self?.labelPrice.text = "€\(price)"
            self?.priceDouble = price
            self?.totalServiceTime = time
            
            self?.labelServiceTIme.text = "\(NSLocalizedString("Service", comment: "Service")) (\(NSLocalizedString("Duration", comment: "Duration")): \(time) \(NSLocalizedString("Minutes", comment: "Minutes")))"
            
        }
        self.present(vw, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func onClickCountry(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
    }
    
    @IBAction func onClickConfirmManualBooking(_ sender: UIButton) {
        if textFieldCustomerName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please enter username")
        } else if labelService.text == NSLocalizedString("Select Service", comment: "Select Service") {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select service first", comment: "Please select service first"))
        } else if startIndex == -1 || endIndex == -1 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select slot", comment: "Please select slot"))
        } else {
            SignupEP.addManualBooking(manualCustomerName: textFieldCustomerName.text!, manualCustomerCountryCodePhone: textFieldPhone.text! == "" ? "" : "\(textFieldCountryCode.text!)\(textFieldPhone.text!)", salonServiceIds: serviceSelectedId, bookingDate: dateString, bookingTime: slotArray[startIndex].slotTime ?? "", amountToBePaid: priceDouble, discount: "0", totalAmount: priceDouble).request(showSpinner: true) { response in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
  

}

extension AddManualBookingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserPreference.shared.data?.salonServices
        return self.slotArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCell", for: indexPath) as! SlotCell
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: slotArray[indexPath.row].slotTime ?? "")
        dateFormatter.dateFormat = "HH:mm"
        cell.labelTime.text = "\(dateFormatter.string(from: date!) )"
        
        // cell.labelTime.text = slotArray[indexPath.row].slotTime ?? ""
        if (indexPath.row >= startIndex && indexPath.row <= endIndex) {
            cell.labelTime.textColor = UIColor(named: "Color_button")
        } else if slotArray[indexPath.row].isAvailable == 0 {
            cell.labelTime.textColor = UIColor.red
        } else  {
            cell.labelTime.textColor = UIColor.white
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 5, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cv {
            if labelService.text == NSLocalizedString("Select Service", comment: "Select Service") {
                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select service first", comment: "Please select service first"))
            } else {
               
                startIndex = -1
                endIndex = -1
                
                
                if slotArray[indexPath.row].isAvailable == 0 {
                    Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                    cv.reloadData()
                    return
                } else {
                    startIndex = indexPath.row
                    let nextIndex = startIndex + (totalServiceTime / 10 )
                    
                    if slotArray.indices.contains(nextIndex) {
                        for i in startIndex ..< nextIndex {
                            if slotArray[i].isAvailable == 0 {
                                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                                startIndex = -1
                                cv.reloadData()
                                return
                                
                            }
                        }
                        endIndex = nextIndex
                    } else {
                        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                        startIndex = -1
                    }
                    cv.reloadData()
                }
            }
        }
        
    }
    
    
}

extension AddManualBookingVC:  FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        apiCall(date: str)
    }
}
extension AddManualBookingVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        flag.image = country.flag
        textFieldCountryCode.text =  "\(country.phoneCode )"
    }
}
