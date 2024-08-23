//
//  UserRatingVC.swift
//  Blade
//
//  Created by cqlsys on 22/10/22.
//

import UIKit
import Cosmos

class UserRatingVC: UIViewController {

    var userImage: String?
    var username: String?
    var bookingId: String?
    var userId: String?
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageUser: RoundImage!
    @IBOutlet weak var rateVW: CosmosView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        // Do any additional setup after loading the view.
    }
    func setupData() {
        imageUser.sd_setImage(with: URL(string:  userImage ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
            
        })
        labelName.text = username ?? ""
        labelTitle.text = "\(NSLocalizedString("Post your review for", comment: "Post your review for")) \(username ?? "")"
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if textViewDescription.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Add your review", comment: "Add your review"))
        } else {
            SignupEP.addReview(bookingId: bookingId ?? "", toUserId: userId ?? "", rating: "\(Int(rateVW.rating) )", review: textViewDescription.text!).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } error: { errro in
                
            }

        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
