//
//  WalletDetailVC.swift
//  Blade
//
//  Created by cqlsys on 23/10/22.
//

import UIKit

class WalletDetailVC: UIViewController {

    @IBOutlet weak var labelPendingBalance: UILabel!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var labelWalletAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserPreference.shared.data?.stripeId ?? "" != "" {
         //   btnConnect.isHidden = true
            viewText.isHidden = false
          //  labelDesc.text = NSLocalizedString("TEST", comment: "TEST")
            btnConnect.setTitle(NSLocalizedString("Withdraw", comment: "Withdraw"), for: .normal)
        } else {
            labelDesc.text = ""
            btnConnect.setTitle(NSLocalizedString("Conncet Stripe to withdraw", comment: "Conncet Stripe to withdraw"), for: .normal)
        }
        
        SignupEP.getProfile.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<SignupModel> else { return }
                if data.code == 200{
                    UserPreference.shared.data = data.data
                }
            }
        } error: { error in
            
        }
    }
    
    func apiCall() {
        SignupEP.stripeBalanceTransactionsListing(limit: "10", page: "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<TransactionModel> else { return }
                if data.code == 200{
                    self.labelWalletAmount.text = "€\(data.data?.balanceAvailableToWithdraw ?? "")"
                    self.labelPendingBalance.text = "€\(data.data?.balancePendingOnStripeEnd ?? "")"
                }
            }
        }
//        SignupEP.walletDetail.request(showSpinner: true) { response in
//            if response != nil{
//                guard let data = response as? ObjectData<WalletAmount> else { return }
//                if data.code == 200{
//                    self.labelWalletAmount.text = "€\(data.data?.wallet ?? "")"
//                }
//            }
//        } error: { error in
//
//        }

    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func onClickConnect(_ sender: UIButton) {
        if UserPreference.shared.data?.stripeId ?? "" != "" {
            if textFieldAmount.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Enter amount to withdraw.", comment: "Enter amount to withdraw."))
            } else if Int(textFieldAmount.text!) ?? 0 <= 1  {
                Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Requried entered amount to withdraw should be greater than €1.", comment: "Requried entered amount to withdraw should be greater than €1."))
            }else {
                SignupEP.withdrawAmountFromWallet(amount: textFieldAmount.text!).request(showSpinner: true) { response in
                    self.apiCall()
                } error: { error in
                    
                }

            }
        } else {
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "StripeConnectVC") as! StripeConnectVC
            self.navigationController?.pushViewController(vw, animated: true)
        }
    }
}
