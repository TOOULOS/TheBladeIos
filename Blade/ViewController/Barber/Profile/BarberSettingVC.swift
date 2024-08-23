//
//  BarberSettingVC.swift
//  Blade
//
//  Created by cqlsys on 18/10/22.
//

import UIKit

class BarberSettingVC: UIViewController {
    fileprivate var settingArray = ["Profile", "Change Password", "Privacy Policy", "About Us", "Delete Account"]
    fileprivate var settingImageArray = ["ic_setting_profile", "ic_Setting_changePassword", "ic_setting_privacy", "ic_setting_about", "ic_Setting_delete"]
    @IBOutlet weak var settingTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickLogout(_ sender: UIButton) {
        Utilities.sharedInstance.showAlertViewWithAction("", "Are you sure, you want to logout?", self, completion: {
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

extension BarberSettingVC: UITableViewDelegate, UITableViewDataSource {
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
            let vw = story.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 2 {
            let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
            vw.type = .privacy
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 3 {
            let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
            vw.type = .about
            self.navigationController?.pushViewController(vw, animated: true)
        } else if indexPath.row == 4 {
            Utilities.sharedInstance.showAlertViewWithAction("", "Are you sure, you want to delete this account?", self, completion: {
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
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
