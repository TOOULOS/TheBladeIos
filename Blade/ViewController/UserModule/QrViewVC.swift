//
//  QrViewVC.swift
//  Blade
//
//  Created by cqlsys on 22/05/24.
//

import UIKit
import MessageUI

class QrViewVC: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclickContinue(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Salon", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
        self.view.window?.rootViewController = vw
    }

    @IBAction func onClickDownlod(_ sender: UIButton) {

        UIImageWriteToSavedPhotosAlbum(UIImage.init(named: "ic_qr")!, self,nil, nil)
    }
    

    @IBAction func onClickSticker(_ sender: UIButton) {

        let recipientEmail = "Info@thebladeapp.com"
        let subject = ""
        let body = "Hello, I Want A Free Qr-Sticker\nShipping Details\nName:\(UserPreference.shared.data?.name ?? "")\nCountry:\nAddress:\(UserPreference.shared.data?.location ?? "")\nZip Code\nPhone: + (\(UserPreference.shared.data?.countryCode ?? "") (\(UserPreference.shared.data?.phone ?? ""))"

        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)

            // Show third party email composer if default Mail app is not present
        } else {


            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enable the E-mail.", comment: "Please enable the E-mail."))
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickCopy(_ sender: UIButton) {

        UIPasteboard.general.string = "goto.thebladeapp.com"
        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Link copied successfully.", comment: "Link copied successfully."))
    }


    @IBAction func onClickWebsite(_ sender: UIButton) {
//        guard let url = URL(string: "https://thebladeapp.com/") else {
//          return //be safe
//        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
    }
}

class WriteImageToFileResponder: NSObject {
    typealias WriteImageToFileResponderCompletion = ((UIImage?, Error?) -> Void)?
    var completion: WriteImageToFileResponderCompletion = nil

    override init() {
        super.init()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if (completion != nil) {
            error == nil ? completion?(image, error) : completion?(nil, error)
            completion = nil
        }
        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Sticker downloaded successfully.", comment: "Sticker downloaded successfully."))
    }
    func addCompletion(completion:WriteImageToFileResponderCompletion) {
        self.completion = completion
    }
}
