//
//  CardViewVC.swift
//  Blade
//
//  Created by cqlsys on 26/11/22.
//

import UIKit

class CardViewVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardTB: UITableView!
    @IBOutlet weak var btnDefaultCard: UIButton!
    @IBOutlet weak var btnSaveCard: UIButton!
    @IBOutlet weak var textFieldCVV: UITextField!
    @IBOutlet weak var textFieldExpireDate: UITextField!
    @IBOutlet weak var textFieldCardNumber: UITextField!
    fileprivate var cardArray: [CardModel] = []
    
    
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
    var salonId: String = ""
    var walletUse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldCVV.delegate = self
        textFieldCardNumber.delegate = self
        textFieldExpireDate.delegate = self
        SignupEP.getStripeCards.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[CardModel]> else { return }
                if data.code == 200{
                    self.cardArray = data.data ?? []
                    
                    self.cardTB.reloadData()
                }
            }
        } error: { error in
            
        }

        // Do any additional setup after loading the view.
    }
    
    let z = 4, intervalString = " "

    func canInsert(atLocation y:Int) -> Bool { return ((1 + y)%(z + 1) == 0) ? true : false }

    func canRemove(atLocation y:Int) -> Bool { return (y != 0) ? (y%(z + 1) == 0) : false }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textFieldCardNumber == textField {
            let nsText = textField.text! as NSString
            
            if range.location == 19 { return false }
            
            if range.length == 0 && canInsert(atLocation: range.location) {
                textField.text! = textField.text! + intervalString + string
                return false
            }
            
            if range.length == 1 && canRemove(atLocation: range.location) {
                textField.text! = nsText.replacingCharacters(in: NSMakeRange(range.location-1, 2), with: "")
                return false
            }
        } else if textFieldCVV == textField {
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                if updatedText.count > 3 {
                    return false
                }
            }
        } else if textFieldExpireDate == textField {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                    return true
                }
                let updatedText = oldText.replacingCharacters(in: r, with: string)

                if string == "" {
                    if updatedText.count == 2 {
                        textField.text = "\(updatedText.prefix(1))"
                        return false
                    }
                } else if updatedText.count == 1 {
                    if updatedText > "1" {
                        return false
                    }
                } else if updatedText.count == 2 {
                    if updatedText <= "12" { //Prevent user to not enter month more than 12
                        textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                    }
                    return false
                } else if updatedText.count == 7 {
                    self.expDateValidation(dateStr: updatedText)
                } else if updatedText.count > 7 {
                    return false
                }
        }
        
        
        return true
    }
    
    
    func expDateValidation(dateStr:String) {

        let currentYear = Calendar.current.component(.year, from: Date())    // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enteredYear = Int(dateStr.suffix(4)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                self.textFieldExpireDate.textColor = UIColor.white
                print("Entered Date Is Right")
            } else {
                self.textFieldExpireDate.textColor = UIColor.red
                print("Entered Date Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    self.textFieldExpireDate.textColor = UIColor.white
                   print("Entered Date Is Right")
                } else {
                    self.textFieldExpireDate.textColor = UIColor.red
                   print("Entered Date Is Wrong")
                }
            } else {
                self.textFieldExpireDate.textColor = UIColor.red
                print("Entered Date Is Wrong")
            }
        } else {
            self.textFieldExpireDate.textColor = UIColor.red
           print("Entered Date Is Wrong")
        }

    }
    
    
    @IBAction func onClickDefaultCard(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            
        } else {
            btnSaveCard.isSelected = true
            sender.isSelected = true
        }
    }
    
    @IBAction func onClickSaveCard(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            btnDefaultCard.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        Utilities.sharedInstance.showAlertViewWithAction("", NSLocalizedString("Are you sure you want to delete this card", comment: "Are you sure you want to delete this card") as NSString, self) {
            SignupEP.deleteStripeCard(id: self.cardArray[sender.tag].id ?? "").request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        self.cardArray.remove(at: sender.tag)
                        self.cardTB.reloadData()
                    }
                }
            } error: { error in
                
            }

        }
    }
    @IBAction func onClickPayNow(_ sender: UIButton) {
        if textFieldCardNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter card", comment: "Please enter card"))
        } else if textFieldCardNumber.text!.trimmingCharacters(in: .whitespaces).length < 14 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid card", comment: "Please enter valid card"))
        } else if textFieldExpireDate.text!.trimmingCharacters(in: .whitespaces).length != 7 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter expiry date", comment: "Please enter expiry date"))
        } else if textFieldCVV.text!.trimmingCharacters(in: .whitespaces).length != 3 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter cvv", comment: "Please enter cvv"))
        } else {
            apiCall()
        }
    }
    
    @IBAction func onClickPay(_ sender: UIButton) {
        apiCallSecond(id: cardArray[sender.tag].id ?? "")
    }
    
    func apiCallSecond(id: String) {
        SignupEP.addBooking(salonId: salonId, salonStylistId: "\(stylistId)", salonServiceIds: serviceSelectedId, bookingDate: dateString, bookingTime: bookingTime, amountToBePaid: price, discount: "0", totalAmount: "\((Double(price ) ?? 0) + 0.95)", paymentMethod: "2", stripeAndPaymentAmountFromWallet: walletUse == true ? "5" : "0", usePreviouslyAddedCard: "1", previouslyAddedCardId: id, cardNumber: "", cardExpMonth: "", cardExpYear: "", cardCvc: ""  , isSaveCard: "", setDefaultPaymentMethod: "").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
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
    
    func apiCall() {
        let ar = textFieldExpireDate.text!.components(separatedBy: "/")
        SignupEP.addBooking(salonId: salonId, salonStylistId: "\(stylistId)", salonServiceIds: serviceSelectedId, bookingDate: dateString, bookingTime: bookingTime, amountToBePaid: price, discount: "0", totalAmount: "\((Double(price ) ?? 0) + 0.95)", paymentMethod: "2", stripeAndPaymentAmountFromWallet: walletUse == true ? "5" : "0", usePreviouslyAddedCard: "0", previouslyAddedCardId: "", cardNumber: textFieldCardNumber.text!.trimmingCharacters(in: .whitespaces), cardExpMonth: ar.first ?? "", cardExpYear: "\(ar.last ?? "0")", cardCvc: textFieldCVV.text!  , isSaveCard: btnSaveCard.isSelected == true ? "1": "0", setDefaultPaymentMethod: btnDefaultCard.isSelected == true ? "1": "0").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
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

extension CardViewVC: UITabBarDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        cell.objCard = cardArray[indexPath.row]
        cell.btnPay.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        return cell
    }
}
