//
//  SettingVC.swift
//  Blade
//
//  Created by cqlsys on 08/10/22.
//

import UIKit
import StoreKit

class SettingVC: UIViewController {
    fileprivate var settingArray = [NSLocalizedString("Profile", comment: "Profile"),
                                    NSLocalizedString("Rewards", comment: "Rewards"),
                                    NSLocalizedString("Change Password", comment: "Change Password"),
                                    NSLocalizedString("My Reviews", comment: "My Reviews"),
                                    NSLocalizedString("Privacy Policy", comment: "Privacy Policy"),
                                    NSLocalizedString("Term of use", comment: "Term of use"),
                                    NSLocalizedString("About", comment: "About"),
                                    NSLocalizedString("Change Language", comment: "Change Language"),
                                    NSLocalizedString("Delete Account", comment: "Delete Account"),
                                    NSLocalizedString("Contact Us", comment: "Contact Us"),
                                    NSLocalizedString("Rate & Review Blade App", comment: "Rate & Review Blade App")]
    
    fileprivate var settingImageArray = ["ic_setting_profile",
                                    "ic_setting_reward",
                                    "ic_Setting_changePassword",
                                    "ic_setting_myReview",
                                    "ic_setting_privacy",
                                    "ic_setting_term" ,
                                    "ic_setting_about",
                                    "ic_change_lang",
                                    "ic_Setting_delete",
                                    "ic_setting_contact",
                                    "ic_settings_rate"]
    @IBOutlet weak var settingTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
    
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
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
        
        if indexPath.row == 0 {
            let vw = story.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 1 {
            let vw = story.instantiateViewController(withIdentifier: "RewardVC") as! RewardVC
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 2 {
            let vw = story.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 3 {
            let vw = story.instantiateViewController(withIdentifier: "MyReviewVC") as! MyReviewVC
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 4 {
            let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
            vw.type = .privacy
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 5 {
            let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
            vw.type = .term
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 6 {
            let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
            vw.type = .about
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 7 {
            let story1 = UIStoryboard.init(name: "Main", bundle: nil)
            let vw = story1.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
            vw.onSubmit = { [weak self] val in
                SignupEP.changeLanguage(languageType: "").request(showSpinner: true) { response in
                    let story = UIStoryboard.init(name: "Customer", bundle: nil)
                    let vw = story.instantiateViewController(withIdentifier: "TabbarVC")
                    self?.view.window?.rootViewController = vw
                } error: { error in
                    
                }

                
            }
            self.present(vw, animated: true, completion: nil)
        } else if indexPath.row == 8 {
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
        } else if indexPath.row == 9 {
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
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
