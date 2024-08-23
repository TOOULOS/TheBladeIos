//
//  StripeConnectVC.swift
//  Blade
//
//  Created by cqlsys on 10/12/22.
//

import UIKit
import WebKit


class StripeConnectVC: UIViewController, WKNavigationDelegate {
//https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_MTwFLTieDnPbcOoDGBqdz8yxBMCyOh9g&scope=read_write&state=

    //https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_MTwFKrVlL2bFCSgAyKsekGh9XZkvmttn&scope=read_write&state=
    @IBOutlet weak var wkView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let link = URL(string:"https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_MTwFLTieDnPbcOoDGBqdz8yxBMCyOh9g&scope=read_write&state=\(UserPreference.shared.data?.id ?? 0)")!
        let request = URLRequest(url: link)
        wkView.load(request)
        wkView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { result, error in
            
            if let html = result as? String {
                if html.contains("222222222") {
                    self.navigationController?.popViewController(animated: true)
                }
                print(html)
            }
        })
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
