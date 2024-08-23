//
//  RescheduleVC.swift
//  Blade
//
//  Created by cqlsys on 21/12/22.
//

import UIKit
import FSCalendar

class RescheduleVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    @IBOutlet weak var btnBooking: UIButton!
    fileprivate var slotArray: [SlotTimeIntervalModel] = []
    @IBOutlet weak var slotCV: UICollectionView!
    @IBOutlet weak var calendarVW: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstant: NSLayoutConstraint!
    
    var selectedType = 0
    var selectedString: [String] = []
    var manualBookingArray: [[String]] = []
    var startIndex = -1
    var endIndex = -1
    var dateString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarVW.select(Date())
        calendarVW.locale = Locale.init(identifier: UserDefaults.standard.value(forKey: "CurrentLang1") as? String ?? "en")
        calendarVW.scope = .week
        
        self.calendarVW.accessibilityIdentifier = "calendar"
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstant?.constant = bounds.height
        self.view.layoutIfNeeded()
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
        if UserPreference.shared.data?.role == 3 {
            SignupEP.salonSlotsDayWise(salonId: "\(UserPreference.shared.data?.salonId ?? 0)", salonStylistId: "\(UserPreference.shared.data?.id ?? 0)", date: date).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SlotModel> else { return }
                    if data.code == 200{
                        self.slotArray = data.data?.timeIntervals ?? []
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
                        self.slotCV.reloadData()
                    }
                }
            } error: { error in
                
            }
        } else {
            SignupEP.salonSlotsDayWise(salonId: "\(UserPreference.shared.data?.id ?? 0)", salonStylistId: "0", date: date).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SlotModel> else { return }
                    if data.code == 200{
                        self.slotArray = data.data?.timeIntervals ?? []
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
                        self.slotCV.reloadData()
                    }
                }
            } error: { error in
                
            }
        }
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSaveManualBooking(_ sender: UIButton) {
        if (startIndex == -1 || endIndex == -1) && (selectedType == 2 || selectedType == 0) {
            Toast.shared.showAlert(type: .validationFailure, message: "Please select time")
        } else {
            if selectedType == 2 {
                if startIndex > endIndex {
                    
                    var endStringFinal = slotArray[startIndex].slotTime ?? ""
                    
                    if slotArray.indices.contains(startIndex + 1) {
                        endStringFinal = slotArray[startIndex + 1].slotTime ?? ""
                    }
                    
                    SignupEP.manualBooking(bookingDate: dateString, bookingTime: slotArray[endIndex].slotTime ?? "", bookingEndTime: endStringFinal).request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? DefaultModel else { return }
                            if data.code == 200{
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } error: { error in
                        
                    }
                } else {
                    var endStringFinal = slotArray[endIndex].slotTime ?? ""
                    
                    if slotArray.indices.contains(endIndex + 1) {
                        endStringFinal = slotArray[endIndex + 1].slotTime ?? ""
                    }
                    
                    SignupEP.manualBooking(bookingDate: dateString, bookingTime: slotArray[startIndex].slotTime ?? "", bookingEndTime: endStringFinal).request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? DefaultModel else { return }
                            if data.code == 200{
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } error: { error in
                        
                    }
                }
                
            } else {
                var selectedStrings = selectedString.last ?? ""
                
                let index = slotArray.firstIndex { val in
                    val.slotTime ?? "" == (selectedString.last ?? "")
                } ?? 0
                
                if slotArray.indices.contains(index + 1) {
                    selectedStrings = slotArray[index + 1].slotTime ?? ""
                }
                
                SignupEP.unblockManualBooking(bookingDate: dateString, bookingTime: selectedString.first ?? "", bookingEndTime: selectedStrings).request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? DefaultModel else { return }
                        if data.code == 200{
                            Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } error: { error in
                    
                }
            }
            
        }
    }
}

extension RescheduleVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.slotArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCell", for: indexPath) as! SlotCell
        cell.labelTime.text = slotArray[indexPath.row].slotTime ?? ""
        if selectedString.contains(slotArray[indexPath.row].slotTime ?? "") && selectedType == 1 {
            cell.labelTime.textColor = UIColor(named: "Color_button")
        } else if selectedType == 2 && endIndex != -1 && ((indexPath.row >= startIndex && indexPath.row <= endIndex) || (indexPath.row >= endIndex && indexPath.row <= startIndex)) {
            cell.labelTime.textColor = UIColor(named: "Color_button")
        } else if selectedType == 2 && startIndex != -1 && startIndex == indexPath.row {
            cell.labelTime.textColor = UIColor(named: "Color_button")
        } else if slotArray[indexPath.row].isManual == 1 {
            cell.labelTime.textColor = UIColor.lightGray
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
        selectedString.removeAll()
        if slotArray[indexPath.row].isManual == 1 {
            startIndex = -1
            endIndex = -1
            btnBooking.setTitle(NSLocalizedString("Remove Manual Booking", comment: "Remove Manual Booking"), for: .normal)
            for i in manualBookingArray ?? [] {
                let select = i.filter { val in
                    val == slotArray[indexPath.row].slotTime
                }
                if select.count != 0 {
                    selectedString = i
                }
            }
            selectedType = 1
            slotCV.reloadData()
        } else {
            if slotArray[indexPath.row].isAvailable == 0 {
                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Slot is not available for this booking", comment: "Slot is not available for this booking"))
                return
            }
            if selectedType == 1 {
                selectedString.removeAll()
            }
            selectedType = 2
            if startIndex == -1 {
                
                startIndex = indexPath.row
            } else {
                if endIndex == -1 {
                    endIndex = indexPath.row
                } else {
                    startIndex = indexPath.row
                    endIndex = -1
                }
            }
            btnBooking.setTitle(NSLocalizedString("Save Manual Booking", comment: "Save Manual Booking"), for: .normal)
            slotCV.reloadData()
        }
    }
}
