//
//  SubscriptionViewVC.swift
//  Blade
//
//  Created by cqlsys on 07/07/23.
//

import UIKit
import SafariServices

class SubscriptionViewVC: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickActivate(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "QrViewVC") as! QrViewVC
        self.navigationController?.pushViewController(vw, animated: true)
//        let story = UIStoryboard.init(name: "Salon", bundle: nil)
//        let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
//        self.view.window?.rootViewController = vw
    }
    
    @IBAction func onClickLink(_ sender: UIButton) {
        if let url = URL(string: "https://thebladeapp.com/pricing.html") {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            self.present(vc, animated: true)
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
