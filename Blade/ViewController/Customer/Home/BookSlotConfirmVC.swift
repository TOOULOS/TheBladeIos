//
//  BookSlotConfirmVC.swift
//  Blade
//
//  Created by cqlsys on 08/12/22.
//

import UIKit

class BookSlotConfirmVC: UIViewController {

    @IBOutlet weak var viewSubView: UIView!
    @IBOutlet weak var labelWalletInfo: UILabel!
    @IBOutlet weak var viewWalletInfo: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var labelTotalAmiybt: UILabel!
    @IBOutlet weak var viewPlatform: UIView!
    @IBOutlet weak var imageUser: RoundImage!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSalon: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var btnSalon: UIButton!
    @IBOutlet weak var labelServiceName: UILabel!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var labelAmount: UILabel!
    
    var dateString: String = ""
    var bookingTime: String = ""
    var serviceString: String = ""
    var objModle: SaloonDetailModel?
    var type: Int = 0
    
    var selectedIndex: Int = -1
    var price: String = ""
    var walletAmount: Double = 0
    var stylistId: Int = 0
    var serviceSelectedId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelServiceName.text = serviceString
        labelSalon.text = objModle?.salonName ?? ""
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter1.date(from: dateString ?? "") ?? Date()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        labelDate.text = dateFormatter1.string(from: date1)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: bookingTime ?? "")
        dateFormatter.dateFormat = "HH:mm"
        labelTime.text = "\(dateFormatter.string(from: date!) )"
        
       // labelTime.text = bookingTime
        labelAmount.text = "€\(price)"
        labelTotalAmiybt.text = "€\((Double(price ) ?? 0) + 0.95)"
        SignupEP.getProfile.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<SignupModel> else { return }
                if data.code == 200{
                     
                    self.walletAmount = Double(data.data?.wallet ?? "") ?? 0
                    if self.walletAmount >= 5 {
                        self.viewWallet.isHidden = false
                    } else {
                        self.viewWallet.isHidden = true
                    }
                }
            }
        } error: { error in
            
        }

        btnPayNow.isSelected = true
        if type == 1 {
            labelTitle.text = NSLocalizedString("Stylist Name", comment: "Stylist Name")
            
            if selectedIndex == -1{
                labelName.text = objModle?.name ?? ""
                imageUser.sd_setImage(with: URL(string:  objModle?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            } else {
                labelName.text = objModle?.salonStylists?[selectedIndex].name ?? ""
                imageUser.sd_setImage(with: URL(string:  objModle?.salonStylists?[selectedIndex].image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            }
            
        } else {
            labelName.text = objModle?.name  ?? ""
            labelTitle.text = NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name")
            imageUser.sd_setImage(with: URL(string:  objModle?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickPayAtSaloon(_ sender: UIButton) {
        viewPlatform.isHidden = true
        sender.isSelected = true
        btnPayNow.isSelected = false
        labelTotalAmiybt.text = "€\((Double(price ?? "") ?? 0))"
        viewWallet.isHidden = true
        viewInfo.isHidden = true
        viewWalletInfo.isHidden = true

    }
    
    @IBAction func onClickPayNow(_ sender: UIButton) {
        viewPlatform.isHidden = false
        sender.isSelected = true
        btnSalon.isSelected = false
        labelTotalAmiybt.text = "€\((Double(price ?? "") ?? 0) + 0.95)"
        viewWallet.isHidden = false
        viewInfo.isHidden = false
    }
    
    @IBAction func onClickWallet(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        labelWalletInfo.text = "\(NSLocalizedString("You have", comment: "You have")) €\(walletAmount) \(NSLocalizedString("balance in your wallet. You can use €5 in one online paid booking only when you have balance", comment: "balance in your wallet. You can use €5 in one online paid booking only when you have balance"))"
        if sender.isSelected == true {
            viewWalletInfo.isHidden = false
        } else {
            viewWalletInfo.isHidden = true
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPayment(_ sender: UIButton) {
        if btnPayNow.isSelected == true {
            viewSubView.isHidden = true
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "CardViewVC") as! CardViewVC
            vw.dateString = dateString
            vw.bookingTime = bookingTime
            vw.serviceString = serviceString
            vw.salonId = labelTitle.text == NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name") ? "\(objModle?.id ?? 0)" :
            ((objModle?.salon == nil) ? "\(objModle?.id ?? 0)" : "\(objModle?.salon?.id ?? 0)")
            vw.objModle = objModle
            vw.price = price
            vw.serviceSelectedId = serviceSelectedId
            vw.stylistId = stylistId
            vw.type = type
            vw.walletUse = btnWallet.isSelected
            self.navigationController?.pushViewController(vw, animated: true)
        } else {
            viewSubView.isHidden = true
            self.apiCall()
          //  viewSubView.isHidden = false
        }
    }
    
    @IBAction func onClickDismiss(_ sender: UIButton) {
        viewSubView.isHidden = true
    }
    
    @IBAction func onCliclkPayNow(_ sender: UIButton) {
        viewSubView.isHidden = true
        self.apiCall()
    }
    
    @IBAction func onClickBlade(_ sender: UIButton) {
        viewSubView.isHidden = true
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "CardViewVC") as! CardViewVC
        vw.dateString = dateString
        vw.bookingTime = bookingTime
        vw.serviceString = serviceString
        vw.salonId = labelTitle.text == NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name") ? "\(objModle?.id ?? 0)" : "\(objModle?.salon?.id ?? 0)"
        vw.objModle = objModle
        vw.price = price
        vw.serviceSelectedId = serviceSelectedId
        vw.stylistId = stylistId
        vw.type = type
        vw.walletUse = btnWallet.isSelected
       // self.navigationController?.pushViewController(vw, animated: true)
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    func apiCall() {
        let val = labelTitle.text == NSLocalizedString("Salon Owner Name", comment: "Salon Owner Name") ? "\(objModle?.id ?? 0)" :
        ((objModle?.salon == nil) ? "\(objModle?.id ?? 0)" : "\(objModle?.salon?.id ?? 0)")
        
        SignupEP.addBooking(salonId: val, salonStylistId: "\(stylistId)", salonServiceIds: serviceSelectedId, bookingDate: dateString, bookingTime: bookingTime, amountToBePaid: price, discount: "0", totalAmount: price, paymentMethod: "1", stripeAndPaymentAmountFromWallet: "", usePreviouslyAddedCard: "", previouslyAddedCardId: "", cardNumber: "", cardExpMonth: "", cardExpYear: "", cardCvc: "", isSaveCard: "", setDefaultPaymentMethod: "").request(showSpinner: true) { response in
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

    }
    
}
