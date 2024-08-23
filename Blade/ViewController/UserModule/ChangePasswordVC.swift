//
//  ChangePasswordVC.swift
//  Blade
//
//  Created by cqlsys on 08/10/22.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldOldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if textFieldOldPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter old password", comment: "Please enter old password"))
        } else if textFieldNewPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter new password", comment: "Please enter new password"))
        } else if textFieldConfirmPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter confirm password", comment: "Please enter confirm password"))
        } else if textFieldNewPassword.text! != textFieldConfirmPassword.text! {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("New and confirm password not match", comment: "New and confirm password not match"))
        } else {
            SignupEP.changePassword(oldPassword: textFieldOldPassword.text!, newPassword: textFieldNewPassword.text!).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } error: { error in
                
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
