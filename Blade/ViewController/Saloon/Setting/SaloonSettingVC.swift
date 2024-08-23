//
//  SaloonSettingVC.swift
//  Blade
//
//  Created by cqlsys on 22/10/22.
//

import UIKit
import StoreKit
import SafariServices

class SaloonSettingVC: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var btnSwitch: UISwitch!
    fileprivate var settingArray = [NSLocalizedString("Profile", comment: "Profile"),
                                    NSLocalizedString("Wallet", comment: "Wallet"),
                                    NSLocalizedString("Change wallet card", comment: "Change wallet card"),
                                    NSLocalizedString("Transactions History", comment: "Transactions History"),
                                    NSLocalizedString("Withdrawal History", comment: "Withdrawal History"),
                                    NSLocalizedString("Salon Hours", comment: "Salon Hours"),
                                    NSLocalizedString("My Stylist", comment: "My Stylist"),
                                    NSLocalizedString("Change Password", comment: "Change Password"),
                                    NSLocalizedString("Privacy Policy", comment: "Privacy Policy"),
                                    NSLocalizedString("Term of use", comment: "Term of use"),
                                    NSLocalizedString("About Us", comment: "About Us"),
                                    NSLocalizedString("Change Language", comment: "Change Language"),
                                    NSLocalizedString("Delete Account", comment: "Delete Account"),
                                    NSLocalizedString("Contact Us", comment: "Contact Us"),
                                    NSLocalizedString("Rate & Review Blade App", comment: "Rate & Review Blade App")]
    
    
    fileprivate var settingImageArray = ["ic_setting_profile",
                                    "ic_setting_wallet",
                                    "ic_transaction_history",
                                    "ic_withdraw_history",
                                    "ic_barbar_hour",
                                    "ic_setting_barbar",
                                         "ic_setting_barbar",
                                         "ic_Setting_changePassword",
                                         "ic_setting_privacy",
                                         "ic_setting_term",
                                         "ic_setting_about",
                                         "ic_change_lang",
                                         "ic_Setting_delete",
                                         "ic_setting_contact",
                                         "ic_settings_rate"]
    @IBOutlet weak var settingTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSwitch.isOn = UserPreference.shared.data?.isAutoAcceptBooking == 1 ? true : false
        if UserPreference.shared.data?.role == 3 {
            settingArray = [NSLocalizedString("Profile", comment: "Profile"),
                            NSLocalizedString("Change Password", comment: "Change Password"),
                            NSLocalizedString("Privacy Policy", comment: "Privacy Policy"),
                            NSLocalizedString("Term of use", comment: "Term of use"),
                            NSLocalizedString("About Us", comment: "About Us"),
                            NSLocalizedString("Change Language", comment: "Change Language"),
                            NSLocalizedString("Contact Us", comment: "Contact Us"),
                            NSLocalizedString("Rate & Review Blade App", comment: "Rate & Review Blade App")]
            
            settingImageArray = ["ic_setting_profile",
                                 "ic_Setting_changePassword",
                                 "ic_setting_privacy",
                                 "ic_setting_term",
                                 "ic_setting_about",
                                 "ic_change_lang",
                                 "ic_setting_contact",
                                 "ic_settings_rate"]
        }
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SignupEP.getProfile.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<SignupModel> else { return }
                if data.code == 200{
                    UserPreference.shared.data = data.data
                }
            }
        } error: { error in
            
        }
        
        if UserPreference.shared.data?.role != 3 {
            if UserPreference.shared.data?.stripeId ?? "" != "" {
                settingArray = [NSLocalizedString("Profile", comment: "Profile"),
                                NSLocalizedString("Wallet", comment: "Wallet"),
                                NSLocalizedString("Change wallet card", comment: "Change wallet card"),
                                NSLocalizedString("Transactions History", comment: "Transactions History"),
                                NSLocalizedString("Withdrawal History", comment: "Withdrawal History"),
                                NSLocalizedString("Salon Hours", comment: "Salon Hours"),
                                NSLocalizedString("My Stylist", comment: "My Stylist"),
                                NSLocalizedString("Change Password", comment: "Change Password"),
                                NSLocalizedString("Privacy Policy", comment: "Privacy Policy"),
                                NSLocalizedString("Term of use", comment: "Term of use"),
                                NSLocalizedString("About Us", comment: "About Us"),
                                NSLocalizedString("Change Language", comment: "Change Language"),
                                NSLocalizedString("Delete Account", comment: "Delete Account"),
                                NSLocalizedString("Contact Us", comment: "Contact Us"),
                                NSLocalizedString("Rate & Review Blade App", comment: "Rate & Review Blade App")]
            } else {
                settingArray = [NSLocalizedString("Profile", comment: "Profile"),
                                NSLocalizedString("Wallet", comment: "Wallet"),
                                NSLocalizedString("Transactions History", comment: "Transactions History"),
                                NSLocalizedString("Withdrawal History", comment: "Withdrawal History"),
                                NSLocalizedString("Salon Hours", comment: "Salon Hours"),
                                NSLocalizedString("My Stylist", comment: "My Stylist"),
                                NSLocalizedString("Change Password", comment: "Change Password"),
                                NSLocalizedString("Privacy Policy", comment: "Privacy Policy"),
                                NSLocalizedString("Term of use", comment: "Term of use"),
                                NSLocalizedString("About Us", comment: "About Us"),
                                NSLocalizedString("Change Language", comment: "Change Language"),
                                NSLocalizedString("Delete Account", comment: "Delete Account"),
                                NSLocalizedString("Contact Us", comment: "Contact Us"),
                                NSLocalizedString("Rate & Review Blade App", comment: "Rate & Review Blade App")]
            }
        }
    }
    
    @IBAction func onClickLogout(_ sender: UIButton) {
        Utilities.sharedInstance.showAlertViewWithAction("", NSLocalizedString("Are you sure, you want to logout?", comment: "Are you sure, you want to logout?") as NSString, self, completion: {
            SignupEP.logout.request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        UserPreference.shared.data = nil
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        let story = UIStoryboard.init(name: "Main", bundle: nil)
                        let vw = story.instantiateViewController(withIdentifier: "InitVC")
                        self.view.window?.rootViewController = vw
                    }
                }
            } error: { error in
                
            }
        })
    }
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        SignupEP.upDateAutoAccept(isAutoAcceptBooking: sender.isOn == true ? "1" : "0").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<SignupModel> else { return }
                if data.code == 200{
                    UserPreference.shared.data = data.data
                }
            }
        } error: { error in
            
        }
        
    }
    
}

extension SaloonSettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.labelTitle.text = settingArray[indexPath.row]
        cell.img.image = UIImage.init(named: settingImageArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let custoer = UIStoryboard.init(name: "Customer", bundle: nil)
        if UserPreference.shared.data?.role == 3 {
            if indexPath.row == 0 {
                let vw = custoer.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 1 {
                let vw = story.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 2 {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .privacy
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 3 {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .term
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 4 {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .about
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 5 {
                let story1 = UIStoryboard.init(name: "Main", bundle: nil)
                let vw = story1.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
                vw.onSubmit = { [weak self] val in
                    SignupEP.changeLanguage(languageType: "").request(showSpinner: true) { response in
                        let story = UIStoryboard.init(name: "Salon", bundle: nil)
                        let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                        UIApplication.shared.keyWindow?.rootViewController = vw
                        
                    } error: { error in
                        
                    }
                    
                }
                self.present(vw, animated: true, completion: nil)
            } else if indexPath.row == 6 {
                let email = "Info@thebladeapp.com"
                if let url = URL(string: "mailto:\(email)") {
                  if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                  } else {
                    UIApplication.shared.openURL(url)
                  }
                }
            } else {
                if #available(iOS 10.3, *) {
                        SKStoreReviewController.requestReview()

                    } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)

                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
            }
        } else {
            if indexPath.row == 0 {
                let vw = custoer.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if indexPath.row == 1 {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "WalletDetailVC") as! WalletDetailVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("Change wallet card", comment: "Change wallet card") {
                if let url = URL(string: "https://dashboard.stripe.com/login") {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            } else if settingArray[indexPath.row] == NSLocalizedString("Transactions History", comment: "Transactions History") {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryVC") as! TransactionHistoryVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("Withdrawal History", comment: "Withdrawal History") {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawHistoryVC") as! WithdrawHistoryVC
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("Salon Hours", comment: "Salon Hours") {
                let vw = story.instantiateViewController(withIdentifier: "AddSaloonTimingVC") as! AddSaloonTimingVC
                vw.type = .editProfile
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("My Stylist", comment: "My Stylist") {
                let vw = self.storyboard?.instantiateViewController(withIdentifier: "SaloonStylistListVC") as! SaloonStylistListVC
                self.navigationController?.pushViewController(vw, animated: true)
            }  else if settingArray[indexPath.row] == NSLocalizedString("Change Password", comment: "Change Password") {
                let vw = story.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                self.navigationController?.pushViewController(vw, animated: true)
            }  else if settingArray[indexPath.row] == NSLocalizedString("Privacy Policy", comment: "Privacy Policy") {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .privacy
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("Term of use", comment: "Term of use") {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .term
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("About Us", comment: "About Us") {
                let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
                vw.type = .about
                self.navigationController?.pushViewController(vw, animated: true)
            } else if settingArray[indexPath.row] == NSLocalizedString("Change Language", comment: "Change Language") {
                let story1 = UIStoryboard.init(name: "Main", bundle: nil)
                let vw = story1.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
                vw.onSubmit = { [weak self] val in
                    SignupEP.changeLanguage(languageType: "").request(showSpinner: true) { response in
                        let story = UIStoryboard.init(name: "Salon", bundle: nil)
                        let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                        self?.view.window?.rootViewController = vw
                        
                    } error: { error in
                        
                    }
                }
                self.present(vw, animated: true, completion: nil)
            }  else if settingArray[indexPath.row] == NSLocalizedString("Delete Account", comment: "Delete Account") {
                Utilities.sharedInstance.showAlertViewWithAction("", NSLocalizedString("Are you sure, you want to delete this account?", comment: "Are you sure, you want to delete this account?") as NSString, self, completion: {
                    SignupEP.deleteAccount.request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? DefaultModel else { return }
                            if data.code == 200{
                                UserPreference.shared.data = nil
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                let vw = story.instantiateViewController(withIdentifier: "InitVC")
                                self.view.window?.rootViewController = vw
                            }
                        }
                    } error: { error in
                        
                    }

                })
            } else if  settingArray[indexPath.row] == NSLocalizedString("Contact Us", comment: "Contact Us") {
                let email = "Info@thebladeapp.com"
                if let url = URL(string: "mailto:\(email)") {
                  if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                  } else {
                    UIApplication.shared.openURL(url)
                  }
                }
            } else {
                if #available(iOS 10.3, *) {
                        SKStoreReviewController.requestReview()

                    } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)

                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
