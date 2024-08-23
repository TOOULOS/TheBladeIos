//
//  InitVC.swift
//  Blade
//
//  Created by cqlsys on 07/10/22.
//

import UIKit

class InitVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserPreference.shared.data != nil {
            if  UserPreference.shared.data?.role ?? 0 == 2 || UserPreference.shared.data?.role ?? 0 == 3 {
                if UserPreference.shared.data?.role ?? 0 == 2
                {
                    if UserPreference.shared.data?.stepsCompleted != 1 && UserPreference.shared.data?.stepsCompleted != 2 && UserPreference.shared.data?.stepsCompleted != 3 {
                        let story = UIStoryboard.init(name: "Salon", bundle: nil)
                        let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                        UIApplication.shared.keyWindow?.rootViewController = vw
                    }
                } else {
                    let story = UIStoryboard.init(name: "Salon", bundle: nil)
                    let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
                    UIApplication.shared.keyWindow?.rootViewController = vw
                }
            } else {
                let story = UIStoryboard.init(name: "Customer", bundle: nil)
                let vw = story.instantiateViewController(withIdentifier: "TabbarVC")
                UIApplication.shared.keyWindow?.rootViewController = vw
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickGetStarted(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
        vw.onSubmit = { [weak self] val in
            let vw = self?.storyboard?.instantiateViewController(withIdentifier: "SignupInitVC") as! SignupInitVC
            
            self?.navigationController?.pushViewController(vw, animated: true)
        }
        self.present(vw, animated: true, completion: nil)
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
        vw.onSubmit = { [weak self] val in
            let vw = self?.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self?.view.window?.rootViewController = vw
        }
        self.present(vw, animated: true, completion: nil)
        
    }
}
