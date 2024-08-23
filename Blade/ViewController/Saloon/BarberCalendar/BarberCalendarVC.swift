//
//  BarberCalendarVC.swift
//  Blade
//
//  Created by cqlsys on 13/11/22.
//

import UIKit
import FSCalendar

class BarberCalendarVC: UIViewController {
    fileprivate var bookingArray: [BookingModel] = []
    @IBOutlet weak var calendarVW: FSCalendar!
    @IBOutlet weak var calendarTB: UITableView!
    @IBOutlet weak var calendarHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarVW.select(Date())
        calendarVW.scope = .week
        self.calendarVW.accessibilityIdentifier = "calendar"
        calendarVW.locale = Locale.init(identifier: UserDefaults.standard.value(forKey: "CurrentLang1") as? String ?? "en")
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
        SignupEP.calendarBasedBookingListingSalonSide(bookingDate: date).request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[BookingModel]> else { return }
                if data.code == 200{
                    self.bookingArray = data.data ?? []
                    self.calendarTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    func updateStatus(id: String, type: String, index: Int) {
        SignupEP.updateBookingStatus(id: id, status: type).request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                    self.bookingArray.remove(at: index)
                    self.calendarTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    @IBAction func onClickAddManualBooking(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "BarberManualBookingVC") as! BarberManualBookingVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        if sender.titleLabel?.text == NSLocalizedString("Reject", comment: "Reject") {
            self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "2", index: sender.tag)
        } else if sender.titleLabel?.text == NSLocalizedString("Cancel", comment: "Cancel") {
            self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "5", index: sender.tag)
        }
    }
    
    @IBAction func onClickRescheduleManual(_ sender: UIButton) {
        self.schedule(index: sender.tag)
    }
    
    func schedule(index: Int) {
        let obj = bookingArray[index]
        let story = UIStoryboard.init(name: "Customer", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "BookSlotVC") as! BookSlotVC
        if obj.salonStylistId == 0 {
            vw.type = .sallon
        } else {
            vw.type = .stylist
        }
        vw.bookingObj = obj
        vw.subType = .rescheduleManual
        var labelService = ""
        var serviceSelectedId = ""
        var totalServiceTime = 0
        for i in obj.bookingJson?.salonServices ?? [] {
            if labelService == "" {
                serviceSelectedId = "\(i.id ?? 0)"
                labelService = "\(i.serviceName ?? "")"
                totalServiceTime = i.timeValue ?? 0
            } else {
                labelService = "\(labelService), \(i.serviceName ?? "")"
                serviceSelectedId = "\(serviceSelectedId), \(i.id ?? 0)"
                totalServiceTime = totalServiceTime + (i.timeValue ?? 0)
            }
        }
        
        vw.priceDouble = obj.amountToBePaid ?? ""
        vw.serviceSelectedId = serviceSelectedId
        vw.serviceNameString = labelService
        
        
        vw.totalServiceTime = totalServiceTime
        //
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let date = dateFormatter.date(from: "\(obj.bookingDate ?? "") \(obj.bookingTime ?? "")" ) ?? Date()
        if date <= Date() {
            Toast.shared.showAlert(type: .validationFailure, message: "Booking is in process you cannot reschedule it.")
        } else {
            self.navigationController?.pushViewController(vw, animated: true)
        }
    }
    
    @IBAction func onClickReschedule(_ sender: CustomButton) {
        if sender.titleLabel?.text == NSLocalizedString("Accept", comment: "Accept") {
            self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "1", index: sender.tag)
        } else if sender.titleLabel?.text == NSLocalizedString("Complete", comment: "Complete") {
            let obj = "\(bookingArray[sender.tag].bookingDate ?? "") \(bookingArray[sender.tag].bookingTime ?? "")"
            let formato = DateFormatter()
            formato.locale = Locale(identifier: "en_US_POSIX")
            formato.dateFormat = "yyyy-MM-dd hh:mm a"
            var dateBooking = formato.date(from: obj)
            if dateBooking == nil {
                formato.dateFormat = "yyyy-MM-dd HH:mm a"
                dateBooking = formato.date(from: obj)
            }
            
            if dateBooking == nil {
                formato.dateFormat = "yyyy-MM-dd HH:mm"
                dateBooking = formato.date(from: obj)
            }
            
            if dateBooking == nil {
                formato.dateFormat = "dd-MM-yyyy HH:mm"
                dateBooking = formato.date(from: obj)
            }
            
            if dateBooking == nil {
                formato.dateFormat = "dd-MM-yyyy hh:mm a"
                dateBooking = formato.date(from: obj)
            }
            
            if dateBooking == nil {
                formato.dateFormat = "dd/MM/yyyy hh:mm a"
                dateBooking = formato.date(from: obj)
            }
            
            if dateBooking == nil {
                formato.dateFormat = "yyyy-MM-dd hh:mm a"
                dateBooking = formato.date(from: obj)
            }
            
            formato.locale = Locale(identifier: "en_US_POSIX")
            formato.dateFormat = "MM-dd-yyyy HH:mm"
            let date1Srring = formato.string(from: dateBooking!)
            
            if dateBooking! < Date() {
                self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "4", index: sender.tag)
            } else  {
                Toast.shared.showAlert(type: .validationFailure, message: "\(NSLocalizedString("Booking start date/time is", comment: "Booking start date/time is")) \(date1Srring ?? "")\(NSLocalizedString(". Before booking date and time you cann't complete this.", comment: ". Before booking date and time you cann't complete this."))")
            }
            
        } else {
            if bookingArray[sender.tag].status == 4 && bookingArray[sender.tag].isRatedUser == 0 {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "UserRatingVC") as! UserRatingVC
                vw.username = bookingArray[sender.tag].user?.name ?? ""
                vw.userImage = bookingArray[sender.tag].user?.image ?? ""
                vw.bookingId = "\(bookingArray[sender.tag].id ?? 0)"
                vw.userId = "\(bookingArray[sender.tag].user?.id ?? 0)"
                self.navigationController?.pushViewController(vw, animated: true)
            }
        }
    }
    
}

extension BarberCalendarVC: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        apiCall(date: str)
    }
}

extension BarberCalendarVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookingArray.count == 0 {
            tableView.setEmptyMessage(NSLocalizedString("No appointments available", comment: "No appointments available"))
        } else {
            tableView.restore()
        }
        return bookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBookingCell", for: indexPath) as! UserBookingCell
        let obj = bookingArray[indexPath.row]
        cell.btnCancel.tag = indexPath.row
        cell.btnReschedule.tag = indexPath.row
        cell.btnManualReschedule.tag = indexPath.row
        if obj.status == 4 || obj.status == 5 || obj.status == 2 {
            cell.objCompleted = bookingArray[indexPath.row]
            if bookingArray[indexPath.row].salonStylistName == "" {
                cell.labelSaloon.text = bookingArray[indexPath.row].salonUserName
                cell.labelSalonTitle.text = NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name")
                cell.labelSaloon.textColor = UIColor.white
            } else {
                cell.labelSaloon.textColor = UIColor.blue
                cell.labelSalonTitle.text = NSLocalizedString("Stylist Name", comment: "Stylist Name")
                cell.labelSaloon.text = bookingArray[indexPath.row].salonStylistName
            }

        } else if obj.status == 0 {
            cell.objRequest = bookingArray[indexPath.row]
            if bookingArray[indexPath.row].salonStylistName == "" {
                cell.labelSaloon.text = bookingArray[indexPath.row].salonUserName
                cell.labelSalonTitle.text = NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name")
                cell.labelSaloon.textColor = UIColor.white
            } else {
                cell.labelSaloon.textColor = UIColor.blue
                cell.labelSalonTitle.text = NSLocalizedString("Stylist Name", comment: "Stylist Name")
                cell.labelSaloon.text = bookingArray[indexPath.row].salonStylistName
            }
        } else {
            cell.objUpcoming = bookingArray[indexPath.row]
            if bookingArray[indexPath.row].salonStylistName == "" {
                cell.labelSaloon.text = bookingArray[indexPath.row].salonUserName
                cell.labelSalonTitle.text = NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name")
                cell.labelSaloon.textColor = UIColor.white
            } else {
                cell.labelSaloon.textColor = UIColor.blue
                cell.labelSalonTitle.text = NSLocalizedString("Stylist Name", comment: "Stylist Name")
                cell.labelSaloon.text = bookingArray[indexPath.row].salonStylistName
            }

        }
        return cell
    }
}
