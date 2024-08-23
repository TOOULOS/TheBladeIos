//
//  SubscriptionVC.swift
//  Blade
//
//  Created by cqlsys on 13/12/22.
//

import UIKit
import StoreKit
import NVActivityIndicatorView
class SubscriptionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.startWith(arrayOfIds: Set(["3223", "3233222"]), sharedSecret: "e3b53e335a28441cb7eeb25301b4cd2b")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView(notification:)), name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadTableView(notification: NSNotification) {
        IAPManager.shared.refreshSubscriptionsStatus {
            DispatchQueue.main.async {
                
                
            }
        } failure: { error in
            
            print(error.debugDescription)
        }
    }
    @IBAction func onClickMonthly(_ sender: UIButton) {
        if IAPManager.shared.products?.count ?? 0 > 0 {
            if IAPManager.shared.products?.first?.productIdentifier == "3223" {
                self.buySub(item: (IAPManager.shared.products?.first)!)
            } else {
                self.buySub(item: (IAPManager.shared.products?.last)!)
            }
        }
        
    }
    
    func buySub(item: SKProduct) {
        let activityData = ActivityData()
       NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        IAPManager.shared.purchaseProduct(product: item) {
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.apiCall()
               // self.navigationController?.popViewController(animated: true)
            }
        } failure: { error in
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
              //  self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func apiCall() {
        SignupEP.updateIsIosSubscriptionActive(isIosSubscriptionActive: "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func onClickYearly(_ sender: UIButton) {
        if IAPManager.shared.products?.count ?? 0 > 0 {
            if IAPManager.shared.products?.first?.productIdentifier == "3233222" {
                self.buySub(item: (IAPManager.shared.products?.first)!)
            } else {
                self.buySub(item: (IAPManager.shared.products?.last)!)
            }
        }
    }
    @IBAction func onClickTerms(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
        vw.type = .term
        self.navigationController?.pushViewController(vw, animated: true)
    }
    @IBAction func onClickPrivacy(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "PageVC") as! PageVC
        vw.type = .privacy
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickRestore(_ sender: UIButton) {
        IAPManager.shared.restorePurchases {
            if UserDefaults.standard.value(forKey: IS_EXPIRE) != nil {
                self.navigationController?.popViewController(animated: true)
            }
        } failure: { error in
            Toast.shared.showAlert(type: .apiFailure, message: "No purchase found")
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
