//
//  LoginVC.swift
//  Blade
//
//  Created by cqlsys on 07/10/22.
//

import UIKit
import StoreKit

class LoginVC: UIViewController {

    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


//        textFieldEmail.text = "Barbershopaggelos@gmail.com"
//        textFieldPassword.text = "Barber69!"
        
  
//        textFieldEmail.text = "martin@yopmail.com"
//        textFieldPassword.text = "FiaM0Dn6"

////        

//        textFieldEmail.text = "Barbershopaggelos@gmail.com"
//        textFieldPassword.text = "Barber69!"
        //SKStoreReviewController.requestReview()


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            } else if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Notification permission was previously denied, go to settings & privacy to re-enable", comment: "Notification permission was previously denied, go to settings & privacy to re-enable"))
                }
               
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
            }
        })
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
//        let vw = self.storyboard?.instantiateViewController(withIdentifier: "QrViewVC") as! QrViewVC
//        self.navigationController?.pushViewController(vw, animated: true)

        if textFieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter email", comment: "Please enter email"))
        } else if !Utilities.sharedInstance.isValidEmail(testStr: textFieldEmail.text!) {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid email address", comment: "Please enter valid email address"))
        } else if textFieldPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter password", comment: "Please enter password"))
        } else {
            SignupEP.login(email: textFieldEmail.text!, password: textFieldPassword.text!).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SignupModel> else { return }
                    if data.code == 200{
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        UserPreference.shared.data = data.data
//                        if  data.data?.role ?? 0 == 3 {
//                            let story = UIStoryboard.init(name: "Barber", bundle: nil)
//                            let vw = story.instantiateViewController(withIdentifier: "BarberTab")
//                            self.view.window?.rootViewController = vw
//                        } else
                        if  data.data?.role ?? 0 == 2 || data.data?.role ?? 0 == 3 {
                            if data.data?.role ?? 0 == 2 {
                                if data.data?.stepsCompleted == 1 {
                                    let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonDetailVC") as! AddSaloonDetailVC
                                    self.navigationController?.pushViewController(vw, animated: true)
                                } else if data.data?.stepsCompleted == 2 {
                                    let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonTimingVC") as! AddSaloonTimingVC
                                    self.navigationController?.pushViewController(vw, animated: true)

                                } else if data.data?.stepsCompleted == 3 {
                                    let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonServiceVC") as! AddSaloonServiceVC
                                    self.navigationController?.pushViewController(vw, animated: true)

                                } else {
                                    let story = UIStoryboard.init(name: "Salon", bundle: nil)
                                    let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                                    self.view.window?.rootViewController = vw
                                }
                                
                            } else {
                                let story = UIStoryboard.init(name: "Salon", bundle: nil)
                                let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                                self.view.window?.rootViewController = vw
                            }
                            
                        } else {
                            let story = UIStoryboard.init(name: "Customer", bundle: nil)
                            let vw = story.instantiateViewController(withIdentifier: "TabbarVC")
                            self.view.window?.rootViewController = vw
                        }
                        
                    }
                }
            } error: { error in
                
            }

        }
    }
    
    @IBAction func onClickForgotPassword(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickFacebook(_ sender: UIButton) {
    }
    
    @IBAction func onClickGoogle(_ sender: Any) {
    }
    
    @IBAction func onClickEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textFieldPassword.isSecureTextEntry = !sender.isSelected
    }
    
    
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "SignupInitVC") as! SignupInitVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
}
