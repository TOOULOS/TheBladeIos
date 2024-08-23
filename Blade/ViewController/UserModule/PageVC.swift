//
//  PageVC.swift
//  Blade
//
//  Created by cqlsys on 08/10/22.
//

import UIKit

class PageVC: UIViewController {
    var type: PageType = .about
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var pageTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .about {
            labelTitle.text = NSLocalizedString("About Us", comment: "About Us")
            SignupEP.aboutUs.request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<PageModel> else { return }
                    if data.code == 200{
                        self.pageTV.attributedText = data.data?.content?.htmlToAttributedString
                        self.pageTV.textColor = UIColor.white
                    }
                }
            } error: { error in
                
            }
        } else if type == .privacy {
            labelTitle.text = NSLocalizedString("Privacy Policy", comment: "Privacy Policy")
            SignupEP.privacyPolicy.request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<PageModel> else { return }
                    if data.code == 200{
                        self.pageTV.attributedText = data.data?.content?.htmlToAttributedString
                        self.pageTV.textColor = UIColor.white
                    }
                }
            } error: { error in
                
            }

        } else if type == .term {
            labelTitle.text = NSLocalizedString("Terms & Conditions", comment: "Terms & Conditions")
            SignupEP.termsAndConditions.request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<PageModel> else { return }
                    if data.code == 200{
                        self.pageTV.attributedText = data.data?.content?.htmlToAttributedString
                        self.pageTV.textColor = UIColor.white
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

enum PageType{
    case about
    case term
    case privacy
}
