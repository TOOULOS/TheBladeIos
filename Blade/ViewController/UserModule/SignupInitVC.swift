//
//  SignupInitVC.swift
//  Blade
//
//  Created by cqlsys on 12/02/24.
//

import UIKit

class SignupInitVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCustomer(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickBarber(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vw.type = 1
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
}
