//
//  RewardVC.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import UIKit

class RewardVC: UIViewController {

    @IBOutlet weak var labelSubCoin: UILabel!
    @IBOutlet weak var textFieldCoins: YourTextFieldSubclass!
    @IBOutlet weak var viewConvert: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCoin: UILabel!
    @IBOutlet weak var labelWalletAmount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        SignupEP.rewardsData.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<RewardModel> else { return }
                if data.code == 200{
                    self.labelDescription.attributedText = data.data?.rewardsDescription?.htmlToAttributedString
                    self.labelDescription.backgroundColor = UIColor.clear
                    self.labelCoin.text = "\(data.data?.rewardPoints ?? 0)"
                    self.labelWalletAmount.text = "€\(data.data?.wallet ?? "")"
                }
            }
        } error: { error in
            
        }

    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickConvert(_ sender: UIButton) {
        viewConvert.isHidden = false
        labelSubCoin.text = self.labelCoin.text
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        viewConvert.isHidden = true
    }
    
    @IBAction func onClickConvertCoin(_ sender: UIButton) {
        if textFieldCoins.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Enter points value to convert")
        } else {
            let value = Int(textFieldCoins.text!) ?? 0
            if value < 99 {
                Toast.shared.showAlert(type: .validationFailure, message: "Required entered value of rewards to convert should be greater than 99.")
            } else {
                SignupEP.convertRewardPointsToMoneyIntoWallet(rewardPoints: textFieldCoins.text!).request(showSpinner: true) { response in
                    self.navigationController?.popToRootViewController(animated: true)
                } error: { error in
                    
                }

            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
 BLADE is the only barber booking app is Europe that every time you spend you get money back.

 How exciting it is to save money EVERY time you visit your barber?

 With blade's reward system, you can earn points easily and fast.

 Convert your points into money at ant time to spend on your next booking via the blade app.

 Pay through the app and earn 20 reward points from every booking you make.
 */
