//
//  ForgotPasswordVC.swift
//  Blade
//
//  Created by cqlsys on 08/10/22.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if textFieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter email", comment: "Please enter email"))
        } else if !Utilities.sharedInstance.isValidEmail(testStr: textFieldEmail.text!) {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid email address", comment: "Please enter valid email address"))
        } else {
            SignupEP.forgotPassword(email: textFieldEmail.text!).request(showSpinner: true) { response in
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
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
