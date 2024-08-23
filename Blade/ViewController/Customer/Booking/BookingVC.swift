//
//  BookingVC.swift
//  Blade
//
//  Created by cqlsys on 19/10/22.
//

import UIKit

class BookingVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var bookTB: UITableView!
    @IBOutlet weak var viewUpcoming: UIView!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    fileprivate var bookingArray: [BookingModel] = []
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bookingArray.removeAll()
        currentPage = 1
        if btnUpcoming.alpha == 1 {
            self.apiCall(type: "1")
        } else {
            self.apiCall(type: "2")
        }
    }
    
    func apiCall(type: String) {
        SignupEP.bookingListing(type: type, page: "\(currentPage)", limit: "10").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[BookingModel]> else { return }
                if data.code == 200 {
                    if data.data?.count != 0 {
                        self.isLoadingList = false
                        self.bookingArray.append(contentsOf: data.data ?? [])
                    }
                    self.isLoadingList = false
                    
                    self.bookTB.reloadData()
                }
            }
        } error: { error in
            
        }
        
    }
    
    func loadMoreItemsForList() {
        currentPage += 1
        if btnUpcoming.alpha == 1 {
            self.apiCall(type: "1")
        } else {
            self.apiCall(type: "2")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    @IBAction func onClickUpcoming(_ sender: UIButton) {
        btnUpcoming.alpha = 1
        btnCompleted.alpha = 0.5
        viewUpcoming.isHidden = false
        viewCompleted.isHidden = true
        self.bookingArray.removeAll()
        currentPage = 1
        self.apiCall(type: "1")
    }
    
    @IBAction func onClickSaloon(_ sender: UIButton) {
        btnUpcoming.alpha = 0.5
        btnCompleted.alpha = 1
        viewUpcoming.isHidden = true
        viewCompleted.isHidden = false
        self.bookingArray.removeAll()
        currentPage = 1
        self.apiCall(type: "2")
    }
    
    @IBAction func onClickReschedule(_ sender: UIButton) {
        let obj = bookingArray[sender.tag]
        
        self.schedule(index: sender.tag)
        
    }
    
    func schedule(index: Int) {
        let obj = bookingArray[index]
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "BookSlotVC") as! BookSlotVC
        if obj.salonStylistId == 0 {
            vw.type = .sallon
        } else {
            vw.type = .stylist
        }
        vw.bookingObj = obj
        vw.subType = .reschedule
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
    
    func cancelApiCall(index: Int) {
        SignupEP.cancelBookingUserSide(id: "\(self.bookingArray[index].id ?? 0)").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                    self.bookingArray.remove(at: index)
                    self.bookTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        let obj = bookingArray[sender.tag]

        if sender.titleLabel?.text == NSLocalizedString("Cancel", comment: "Cancel") {
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
            let date = dateFormatter.date(from: "\(obj.bookingDate ?? "") \(obj.bookingTime ?? "")" ) ?? Date()
            
            if date <= Date() {
                Toast.shared.showAlert(type: .validationFailure, message: "Booking is in process you cannot cancel it.")
            } else {
                
                let diffComponents = Calendar.current.dateComponents([.hour], from: Date(), to: date)
                let hours = diffComponents.hour ?? 0
                if hours > 24 || obj.paymentMethod == 1 {
                    
                    Utilities.sharedInstance.showAlertViewWithAction("", NSLocalizedString("Are you sure, you want to cancel your booking?", comment: "Are you sure, you want to cancel your booking?") as NSString, self, completion: {
                        self.cancelApiCall(index: sender.tag)
                    })
                } else if hours <= 24 && hours > 12 {
                    
                    
                    let alertView: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to cancel your booking?\nYour appointment is in less than 24hrs.\n\nIf you wish to cancel your appointment you will receive 50% of your payment back.\n( Do you wish to cancel your appointment or reschedule?)", comment: "Are you sure you want to cancel your booking?\nYour appointment is in less than 24hrs.\n\nIf you wish to cancel your appointment you will receive 50% of your payment back.\n( Do you wish to cancel your appointment or reschedule?)"), preferredStyle: .alert)
                    
                    let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default) { action -> Void in
                        self.cancelApiCall(index: sender.tag)
                    }
                    alertView.addAction(okAction)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Reschedule", comment: "Reschedule"), style: .default) { action -> Void in
                        self.schedule(index: sender.tag)
                    }
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                    
                    
                } else {
                    //
                    let alertView: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to cancel your booking?\nYour appointment is in less than 12hrs.\n\nIf you wish to cancel your appointment you will not receive a refund.\n\n( Do you wish to cancel your appointment or reschedule?)", comment: "Are you sure you want to cancel your booking?\nYour appointment is in less than 12hrs.\n\nIf you wish to cancel your appointment you will not receive a refund.\n\n( Do you wish to cancel your appointment or reschedule?)"), preferredStyle: .alert)
                    
                    let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default) { action -> Void in
                        self.cancelApiCall(index: sender.tag)
                    }
                    alertView.addAction(okAction)
                    
                    let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Reschedule", comment: "Reschedule"), style: .default) { action -> Void in
                        self.schedule(index: sender.tag)
                    }
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        } else if sender.titleLabel?.text == NSLocalizedString("Rate & Review", comment: "Rate & Review") {
            let objBooking = bookingArray[sender.tag]
            
            
            let story = UIStoryboard.init(name: "Salon", bundle: nil)
            let vw = story.instantiateViewController(withIdentifier: "UserRatingVC") as! UserRatingVC
            
            if objBooking.salonStylistId == 0 {
                vw.username = objBooking.salonUserName
                vw.userImage = objBooking.salonImage ?? ""
                vw.userId = "\(objBooking.salonId ?? 0)"
            } else {
                vw.username = objBooking.salonStylistName ?? ""
                vw.userImage = objBooking.salonStylistImage ?? ""
                vw.userId = "\(objBooking.salonStylistId ?? 0)"
            }
            vw.bookingId = "\(bookingArray[sender.tag].id ?? 0)"
            self.navigationController?.pushViewController(vw, animated: true)
        }
    }
    
}

extension BookingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBookingCell", for: indexPath) as! UserBookingCell
        cell.btnCancel.isHidden = false
        cell.btnReschedule.isHidden = false
        cell.objBooking = bookingArray[indexPath.row]
        cell.btnCancel.tag = indexPath.row
        cell.btnReschedule.tag = indexPath.row
        cell.labelPaymentTYpe.isHidden = true
        cell.imageStatus.isHidden = true
        if btnUpcoming.alpha == 1 {
            cell.viewStatus.isHidden = true
            cell.btnReschedule.isHidden = false
            if bookingArray[indexPath.row].status == 0 {
                cell.labelPaymentTYpe.text = NSLocalizedString("Booking sent", comment: "Booking sent")
            } else {
                cell.labelPaymentTYpe.text = NSLocalizedString("Booking accepted", comment: "Booking accepted")
            }
            
            cell.labelPaymentTYpe.isHidden = false
            cell.imageStatus.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
            let date = dateFormatter.date(from: "\(bookingArray[indexPath.row].bookingDate ?? "") \(bookingArray[indexPath.row].bookingTime ?? "")" ) ?? Date()
            if date <= Date() {
                cell.btnCancel.isHidden = true
                cell.btnReschedule.isHidden = true
            } else {
                cell.btnCancel.isHidden = false
                cell.btnReschedule.isHidden = false
            }
            cell.btnCancel.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
            cell.btnReschedule.setTitle(NSLocalizedString("Reschedule", comment: "Reschedule"), for: .normal)
        } else {
            if bookingArray[indexPath.row].cancelledBy == 1 {
                cell.btnCancel.setTitle(NSLocalizedString("Cancelled by you", comment: "Cancelled by you"), for: .normal)
            } else if bookingArray[indexPath.row].cancelledBy == 2 {
                cell.btnCancel.setTitle(NSLocalizedString("Cancelled by salon", comment: "Cancelled by salon"), for: .normal)
            } else if bookingArray[indexPath.row].cancelledBy == 3 {
                cell.btnCancel.setTitle(NSLocalizedString("Cancelled by stylist", comment: "Cancelled by stylist"), for: .normal)
            } else if (bookingArray[indexPath.row].isRatedSalonStylist == 0) && (bookingArray[indexPath.row].isRatedSalon == 0) {
                cell.btnCancel.setTitle(NSLocalizedString("Rate & Review", comment: "Rate & Review"), for: .normal)
                cell.labelPaymentTYpe.isHidden = false
                cell.imageStatus.isHidden = false
                cell.labelPaymentTYpe.text = NSLocalizedString("Booking Completed", comment: "Booking Completed")
            } else {
                cell.btnCancel.setTitle(NSLocalizedString("Reviewd", comment: "Reviewd"), for: .normal)
                cell.labelPaymentTYpe.isHidden = false
                cell.imageStatus.isHidden = false
                
                cell.labelPaymentTYpe.text = NSLocalizedString("Booking Completed", comment: "Booking Completed")
            }
            cell.viewStatus.isHidden = true
            cell.btnReschedule.isHidden = true
            
            cell.btnReschedule.setTitle(NSLocalizedString("Review", comment: "Review"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
