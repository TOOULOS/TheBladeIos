//
//  BookSlotVC.swift
//  Blade
//
//  Created by cqlsys on 04/12/22.
//

import UIKit
import FSCalendar

class BookSlotVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var labelServiceTime: UILabel!
    @IBOutlet weak var labelSelcteBarber: UILabel!
    @IBOutlet weak var stylistCVHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var slotHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var slotzcv: UICollectionView!
    @IBOutlet weak var calendarHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var calendarVW: FSCalendar!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelService: UILabel!
    @IBOutlet weak var btnSaloon: UIButton!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageSaloon: RoundImage!
    @IBOutlet weak var viewSaloon: UIView!
    var objModle: SaloonDetailModel?
    var type: CustomerSaloonDetailType = .sallon
    var subType: CustomerSaloonDetailType = .normal
    
    var selectedIndez: Int = -1
    @IBOutlet weak var stylistCV: UICollectionView!
    var serviceSelectedId: String = ""
    
    
    var selectedType = 0
    var selectedString: [String] = []
    var manualBookingArray: [[String]] = []
    var startIndex = -1
    var endIndex = -1
    var dateString: String = ""
    var totalServiceTime: Int = 0
    var priceDouble: String = ""
    var serviceNameString = ""
    fileprivate var slotArray: [SlotTimeIntervalModel] = []
    var bookingObj: BookingModel?
    
    override func viewDidLoad() {
        self.slotzcv.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        super.viewDidLoad()
        calendarVW.locale = Locale.init(identifier: UserDefaults.standard.value(forKey: "CurrentLang1") as? String ?? "en")
        if serviceNameString != "" {
            labelService.text = serviceNameString
            labelPrice.text = "€\(priceDouble)"
            //
            labelServiceTime.text = "\(NSLocalizedString("Service", comment: "Service")) (\(NSLocalizedString("Duration", comment: "Duration")): \(totalServiceTime) \(NSLocalizedString("Minutes", comment: "Minutes")))"
        } else {
            labelServiceTime.text = "\(NSLocalizedString("Service", comment: "Service")) "
        }
        
        
        self.calendarVW.select(Date())
        calendarVW.scope = .week
        self.calendarVW.accessibilityIdentifier = "calendar"
        if type == .stylist {
            viewSaloon.isHidden = true
        } else {
            labelSubTitle.text = objModle?.name  ?? ""
            btnSaloon.isSelected = true
            imageSaloon.sd_setImage(with: URL(string:  objModle?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
        }
        
        if subType == .reschedule || subType == .rescheduleManual {
            if type == .sallon {
                stylistCVHeightConstant.constant = 0
                stylistCV.isHidden = true
                labelSelcteBarber.text = ""
                
                labelSubTitle.text = bookingObj?.salonUserName  ?? ""
                btnSaloon.isSelected = true
                imageSaloon.sd_setImage(with: URL(string:  bookingObj?.salonImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
                
            } else {
                viewSaloon.isHidden = true
            }
            
        } else if subType == .rescheduleManual {
            viewSaloon.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.slotHeightConstant.constant = slotzcv.contentSize.height
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    @IBAction func onClickConfirm(_ sender: Any) {
        if labelService.text == NSLocalizedString("Select Service", comment: "Select Service") {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select service first", comment: "Please select service first"))
        } else if startIndex == -1 || endIndex == -1 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select slot", comment: "Please select slot"))
        } else {
            if subType == .reschedule {
                SignupEP.rescheduleBooking(id: "\(bookingObj?.id ?? 0)", bookingDate: dateString, bookingTime: slotArray[startIndex].slotTime ?? "").request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? DefaultModel else { return }
                        if data.code == 200{
                            let story = UIStoryboard.init(name: "Customer", bundle: nil)
                            let vw = story.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                            vw.selectedIndex = 2
                            self.view.window?.rootViewController = vw
                            // self.tabBarController?.selectedIndex = 2
                        }
                    }
                } error: { error in
                    
                }

            } else if subType == .rescheduleManual {
                SignupEP.rescheduleBookingSalonSide(id: "\(bookingObj?.id ?? 0)", bookingDate: dateString, bookingTime: slotArray[startIndex].slotTime ?? "").request { response in
                    if response != nil{
                        guard let data = response as? DefaultModel else { return }
                        if data.code == 200 {
                            let story = UIStoryboard.init(name: "Salon", bundle: nil)
                            let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                            self.view.window?.rootViewController = vw
                            
                            // self.tabBarController?.selectedIndex = 2
                        }
                    }
                }
            } else {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "BookSlotConfirmVC") as! BookSlotConfirmVC
                vw.dateString = dateString
                vw.bookingTime = slotArray[startIndex].slotTime ?? ""
                vw.serviceString = labelService.text!
                vw.objModle = objModle
                vw.price = priceDouble
                vw.serviceSelectedId = serviceSelectedId
                if type == .stylist {
                    vw.type = 1
                    vw.stylistId = objModle?.id ?? 0
                } else {
                    if selectedIndez == -1 {
                        vw.type = 2
                        vw.stylistId = 0
                    } else {
                        vw.selectedIndex = selectedIndez
                        vw.type = 1
                        vw.stylistId = objModle?.salonStylists?[selectedIndez].id ?? 0
                    }
                    
                }
                
                self.navigationController?.pushViewController(vw, animated: true)
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if calendarVW.selectedDate == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.apiCall(date: dateFormatter.string(from: Date()))
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.apiCall(date: dateFormatter.string(from: calendarVW.selectedDate ?? Date()))
        }
    }
    
    func apiCall(date: String) {
        startIndex = -1
        endIndex = -1
        dateString = date
        self.selectedString.removeAll()
        selectedType = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectDate = dateFormatter.string(from: Date())
        
        if subType == .reschedule || subType == .rescheduleManual{
            if type == .sallon {
                SignupEP.salonSlotsDayWise(salonId: "\(bookingObj?.salonId ?? 0)", salonStylistId: "0", date: date).request(showSpinner: true) { response in
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
                            self.slotzcv.reloadData()
                        }
                    }
                } error: { error in
                    
                }
            } else {
                SignupEP.salonSlotsDayWise(salonId: "\(bookingObj?.salonId ?? 0)", salonStylistId: "\(bookingObj?.salonStylistId ?? 0)", date: date).request(showSpinner: true) { response in
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
                            self.slotzcv.reloadData()
                        }
                    }
                } error: { error in
                    
                }
            }
            
        } else if type == .stylist {
            
            SignupEP.salonSlotsDayWise(salonId: "\(objModle?.salon?.id ?? 0)", salonStylistId: "\(objModle?.id ?? 0)", date: date).request(showSpinner: true) { response in
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
                        self.slotzcv.reloadData()
                    }
                }
            } error: { error in
                
            }
        } else {
            SignupEP.salonSlotsDayWise(salonId: "\(objModle?.id ?? 0)", salonStylistId: selectedIndez == -1 ? "0" : "\(objModle?.salonStylists?[selectedIndez].id ?? 0)", date: date).request(showSpinner: true) { response in
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
                        self.slotzcv.reloadData()
                    }
                }
            } error: { error in
                
            }
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstant?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       /// calendarVW.setScope(.week, animated: false)
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCheckBox(_ sender: UIButton) {
    }
    
    @IBAction func onClickSaloon(_ sender: UIButton) {
        if sender.isSelected != true {
            sender.isSelected = true
            selectedIndez = -1
            stylistCV.reloadData()
            labelPrice.text = "€0"
            labelService.text = "Select Service"
            labelServiceTime.text = "\(NSLocalizedString("Service", comment: "Service"))"
            
            self.apiCall(date: dateString)
        }
        
    }
    
    @IBAction func onClickService(_ sender: UIButton) {
        if subType == .normal {
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vw = story.instantiateViewController(withIdentifier: "SelectServiceVC") as! SelectServiceVC
            vw.modalPresentationStyle = .overFullScreen
            vw.type = .addBooking
            if type == .stylist {
                
                vw.serviceArray = objModle?.salonServices ?? []
            } else {
                if selectedIndez == -1 {
                    vw.serviceArray = objModle?.salonServices ?? []
                } else {
                    vw.serviceArray = objModle?.salonStylists?[selectedIndez].salonServices ?? []
                }
                
            }
           
            vw.onBackWithPrice = { [weak self] (serviceName, serviceID, price, time) in
                self?.serviceSelectedId = serviceID
                self?.labelService.text = serviceName
                self?.labelPrice.text = "€\(price)"
                self?.priceDouble = price
                self?.totalServiceTime = time
                
                self?.labelServiceTime.text = "\(NSLocalizedString("Service", comment: "Service")) (\(NSLocalizedString("Duration", comment: "Duration")): \(time) \(NSLocalizedString("Minutes", comment: "Minutes")))"
           
            }
            self.present(vw, animated: true, completion: nil)
        }
        
    }
    
}

extension BookSlotVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == slotzcv {
            return self.slotArray.count
        } else {
            if type == .stylist {
                return 1
            } else {
                return objModle?.salonStylists?.count ?? 0
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == slotzcv {
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
        } else {
            if type == .stylist {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
                // cell.objTopRated = arrayTopRatedSallon[indexPath.row]
                cell.btnLike.tag = indexPath.row
                if subType == .reschedule || subType == .rescheduleManual{
                    cell.imageSaloon.sd_setImage(with: URL(string:  bookingObj?.salonStylistImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in

                    })
                    cell.btnLike.isSelected = true
                    cell.labelName.text = bookingObj?.salonStylistName ?? ""
                    //  cell.labelTotalRating.text = objModle?.rating ?? ""
                } else {
                    cell.imageSaloon.sd_setImage(with: URL(string:  objModle?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in

                    })
                    cell.btnLike.isSelected = true
                    cell.labelName.text = objModle?.name ?? ""
                    cell.labelTotalRating.text = objModle?.rating ?? ""
                }

                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
                let obj = objModle?.salonStylists?[indexPath.row]
                cell.imageSaloon.sd_setImage(with: URL(string:  obj?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in

                })
                cell.labelName.text = obj?.name ?? ""
                cell.labelTotalRating.text = obj?.rating ?? ""
                if selectedIndez == indexPath.row {
                    cell.btnLike.isSelected = true
                } else {
                    cell.btnLike.isSelected = false
                }

                // cell.objSallon = arrayNearBySallon[indexPath.row]
                cell.btnLike.tag = indexPath.row
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == slotzcv {
            return CGSize(width: collectionView.frame.size.width / 3 - 5, height: 50)
        } else {
            if type == .stylist {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            } else {
                return CGSize(width: 228, height: collectionView.frame.size.height)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == slotzcv {
            if labelService.text == NSLocalizedString("Select Service", comment: "Select Service") {
                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select service first", comment: "Please select service first"))
            } else {
                selectedString.removeAll()
                startIndex = -1
                endIndex = -1

                var nextIndexs = indexPath.row

                if slotArray.indices.contains(indexPath.row + 1) {
                    nextIndexs = nextIndexs + 1
                }

                if ((slotArray[indexPath.row].isAvailable == 1) && totalServiceTime == 10) {
                    startIndex = indexPath.row
                    let nextIndex = startIndex + (totalServiceTime / 10 )

                    if slotArray.indices.contains(nextIndex) {
                        for i in startIndex ..< nextIndex {
                            if slotArray[i].isAvailable == 0 {
                                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                                startIndex = -1
                                slotzcv.reloadData()
                                return
                            }
                            if nextIndex > 1 {

                            }

                        }
                        endIndex = nextIndex
                    } else {
                        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                        startIndex = -1
                    }
                    slotzcv.reloadData()
                } else if (slotArray[nextIndexs].isAvailable == 0) {
                    Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                    slotzcv.reloadData()
                    return
                } else {
                    startIndex = indexPath.row
                    let nextIndex = startIndex + (totalServiceTime / 10 )
                    // -1
                    if slotArray.indices.contains(nextIndex) {
                        for i in startIndex ..< nextIndex {
                            //                            if i == startIndex {
                            //                                if slotArray[i].isAvailable == 0 && slotArray[nextIndexs].isAvailable == 1{
                            //                                } else {
                            //                                    if slotArray[i].isAvailable == 0 {
                            //                                        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                            //                                        startIndex = -1
                            //                                        slotzcv.reloadData()
                            //                                        return
                            //                                    }
                            //
                            //                                }
                            //                            } else {
                            //                                if slotArray[i].isAvailable == 0 {
                            //                                    Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                            //                                    startIndex = -1
                            //                                    slotzcv.reloadData()
                            //                                    return
                            //                                }
                            //
                            //                            }

                            if slotArray[i].isAvailable == 0 {
                                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                                startIndex = -1
                                slotzcv.reloadData()
                                return
                            }
                            if nextIndex > 1 {

                            }

                        }
                        endIndex = nextIndex
                    } else {
                        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                        startIndex = -1
                    }
                    slotzcv.reloadData()
                }
            }
        } else {
            if type == .sallon {
                if selectedIndez != indexPath.row {
                    selectedIndez = indexPath.row
                    collectionView.reloadData()
                    btnSaloon.isSelected = false
                    labelPrice.text = "€0"
                    labelService.text = NSLocalizedString("Select Service", comment: "Select Service")

                    labelServiceTime.text = "\(NSLocalizedString("Service", comment: "Service")) "

                    self.apiCall(date: dateString)
                }
                
            }
        }
    }
}



extension BookSlotVC:  FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        apiCall(date: str)
    }
}
