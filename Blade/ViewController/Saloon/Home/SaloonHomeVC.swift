//
//  SaloonHomeVC.swift
//  Blade
//
//  Created by cqlsys on 22/10/22.
//

import UIKit
import StoreKit

class SaloonHomeVC: UIViewController, UIScrollViewDelegate {
    fileprivate var bookingArray: [BookingModel] = []
    @IBOutlet weak var bookingTB: UITableView!
    @IBOutlet weak var viewCompleted: UIView!
    @IBOutlet weak var viewUpcoming: UIView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnComing: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserPreference.shared.data?.role ?? 0 == 2 {
            SignupEP.getProfile.request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SignupModel> else { return }
                    if data.code == 200 {
                        UserPreference.shared.data = data.data
                        IAPManager.shared.startWith(arrayOfIds: Set(["3223", "3233222"]), sharedSecret: "e3b53e335a28441cb7eeb25301b4cd2b")
                        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(notification:)), name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
                    }
                }
            }
            
        }
        

    }
    func countryInformation(countryCode:String) -> String{

        var flag: String? = ""
        let flagBaseCode = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        countryCode.uppercased().unicodeScalars.forEach {
            if let scaler = UnicodeScalar(flagBaseCode + $0.value) {
                flag?.append(String(describing: scaler))
            }
        }
        if flag?.count != 1 {
            flag = nil
        }

        let countryName = Locale.current.localizedString(forRegionCode: countryCode)
        print(countryName ?? "No name")
        print(flag ?? "No flag")
        print(countryCode)
        return countryCode

    }

    override func viewDidAppear(_ animated: Bool) {
        if  needsUpdate() == true {
            Utilities.sharedInstance.showAlertViewWithAction("", "A new version of Blade App is a available on App Store. Please update the app to use latest version with new features.", self) {
                guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6445888988") else {
                    return
                }
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)

                } else {
                    UIApplication.shared.openURL(url)
                }
            }

        }
    }
    func needsUpdate() -> Bool {
        var regionCode = ""
        if #available(iOS 16, *) {
            regionCode = Locale.current.region?.identifier ?? ""
        } else {
            regionCode = "IN"
            // Fallback on earlier versions
        }
        let infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary!["CFBundleIdentifier"] as! String
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)&country=\(regionCode ?? "")")!
        guard let data = try? Data(contentsOf: url) else {
          print("There is an error!")
          return false;
        }
        let lookup = (try? JSONSerialization.jsonObject(with: data , options: [])) as? [String: Any]
        if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
            if let results = lookup!["results"] as? [[String:Any]] {
                if let appStoreVersion = results[0]["version"] as? String{
                    let currentVersion = infoDictionary!["CFBundleShortVersionString"] as? String
                    if !(appStoreVersion == currentVersion) {
                    //    print("Need to update [\(appStoreVersion) != \(currentVersion)]")
                        return true
                    }
                }
            }
        }
        return false
    }
    
    @objc func reloadTableView(notification: NSNotification) {
        let obj = UserPreference.shared.data?.timeRemainingForFirst30Days
        
        if (obj?.hours ?? 0 == 0) && (obj?.days ?? 0 == 0) && (obj?.minutes ?? 0 == 0) {
            IAPManager.shared.refreshSubscriptionsStatus {
                DispatchQueue.main.async {
                    if UserDefaults.standard.value(forKey: IS_EXPIRE) == nil {
                        self.openView()
                    }
                    
                }
            } failure: { error in
                self.openView()
                print(error.debugDescription)
            }
        }
    }
    
    func openView() {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        if let tabBarController  = rootController1 as? SaloonTB , let navController = tabBarController.selectedViewController as? UINavigationController ,  let visibleViewController = navController.visibleViewController {
            navController.pushViewController(vw, animated: true)
        } else {
            self.navigationController?.pushViewController(vw, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentPage = 1
        self.bookingArray.removeAll()
        if btnCompleted.alpha == 1 {
            self.apiCall(type: "3")
        } else if btnComing.alpha == 1 {
            self.apiCall(type: "2")
        } else {
            self.apiCall(type: "1")
        }
        SKStoreReviewController.requestReview()
        
    }
    func apiCall(type: String) {
        SignupEP.bookingListingSalonSide(type: type, page: "\(currentPage)", limit: "20").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[BookingModel]> else { return }
                if data.code == 200 {
                    
                    if data.data?.count != 0 {
                        self.isLoadingList = false
                        self.bookingArray.append(contentsOf: data.data ?? [])
                    }
                    
                    
                    self.bookingTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    func loadMoreItemsForList(){
        currentPage += 1
        if btnCompleted.alpha == 1 {
            self.apiCall(type: "3")
        } else if btnComing.alpha == 1 {
            self.apiCall(type: "2")
        } else {
            self.apiCall(type: "1")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    
    @IBAction func onClickRequest(_ sender: UIButton) {
        bookingArray.removeAll()
        self.currentPage = 1
        btnRequest.alpha = 1
        btnComing.alpha = 0.5
        btnCompleted.alpha = 0.5
        viewRequest.isHidden = false
        viewUpcoming.isHidden = true
        viewCompleted.isHidden = true
        self.apiCall(type: "1")
    }
    @IBAction func onClickUpcoming(_ sender: UIButton) {
        bookingArray.removeAll()
        self.currentPage = 1
        btnRequest.alpha = 0.5
        btnComing.alpha = 1
        btnCompleted.alpha = 0.5
        viewRequest.isHidden = true
        viewUpcoming.isHidden = false
        viewCompleted.isHidden = true
        self.apiCall(type: "2")
    }
    
    @IBAction func onClickCompleted(_ sender: UIButton) {
        bookingArray.removeAll()
        self.currentPage = 1
        btnRequest.alpha = 0.5
        btnComing.alpha = 0.5
        btnCompleted.alpha = 1
        viewRequest.isHidden = true
        viewUpcoming.isHidden = true
        viewCompleted.isHidden = false
        self.apiCall(type: "3")
    }
    
    func updateStatus(id: String, type: String, index: Int) {
        SignupEP.updateBookingStatus(id: id, status: type).request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                    self.bookingArray.remove(at: index)
                    self.bookingTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        if sender.titleLabel?.text == NSLocalizedString("Reject", comment: "Reject") {
            self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "2", index: sender.tag)
        } else if sender.titleLabel?.text == NSLocalizedString("Cancel", comment: "Cancel") {
            self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "5", index: sender.tag)
        }
    }
    
    
    @IBAction func onClickManualReschedule(_ sender: UIButton) {
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
                formato.dateFormat = "yyyy-MM-dd hh:mm a"
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
            
            formato.locale = Locale(identifier: "en_US_POSIX")
            formato.dateFormat = "MM-dd-yyyy HH:mm"
            let date1Srring = formato.string(from: dateBooking!)
            
            if dateBooking! < Date() {
                self.updateStatus(id: "\(bookingArray[sender.tag].id ?? 0)", type: "4", index: sender.tag)
            } else {
                Toast.shared.showAlert(type: .validationFailure, message: "\(NSLocalizedString("Booking start date/time is", comment: "Booking start date/time is")) \(date1Srring ?? "")\(NSLocalizedString(". Before booking date and time you cann't complete this.", comment: ". Before booking date and time you cann't complete this."))")
            }
            //
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

extension SaloonHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookingArray.count == 0 {
            tableView.setEmptyMessage(NSLocalizedString("No data found", comment: "No data found"))
        } else {
            tableView.restore()
        }
        return bookingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserBookingCell", for: indexPath) as! UserBookingCell
        cell.btnCancel.tag = indexPath.row
        cell.btnReschedule.tag = indexPath.row
        cell.btnManualReschedule.tag = indexPath.row
        cell.btnManualReschedule.isHidden = true
        if btnCompleted.alpha == 1 {
            cell.objCompleted = bookingArray[indexPath.row]
        } else if btnComing.alpha == 1 {
            cell.objUpcoming = bookingArray[indexPath.row]
        } else {
            cell.objRequest = bookingArray[indexPath.row]
        }
        
        return cell
    }
}
