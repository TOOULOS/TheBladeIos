//
//  Utilities.swift
//  Challenge
//
//  Created by Ajay Kumar on 12/1/16.
//  Copyright © 2016 CQLsys. All rights reserved.
//

import UIKit

protocol imageDelegate:class {
    
    func getImageData(data : Data, image: UIImage, tag : Int)
}

class Utilities: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    static let sharedInstance = Utilities()
    static let appName  = "Blade"
    weak var delegate : imageDelegate?
    
    func showAlertView(_ title : String, _ message : NSString, _ viewController : UIViewController) -> Void {
        
        let alertView: UIAlertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)

        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default) { action -> Void in

        }
        alertView.addAction(cancelAction)
        viewController.present(alertView, animated: true, completion: nil)
        
    }
    
    func showAlertViewWithAction(_ title : String, _ message : NSString, _ viewController : UIViewController,completion : (@escaping () -> Void)) -> Void {
        
        let alertView: UIAlertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)

        let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default) { action -> Void in
            completion()
        }
        alertView.addAction(okAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default) { action -> Void in

        }
        alertView.addAction(cancelAction)
        viewController.present(alertView, animated: true, completion: nil)
        
    }
    
    func showAlertViewWithAction1(_ title : String, _ message : String, _ viewController : UIViewController,completion : (@escaping () -> Void)) -> Void {
        
        let alertView: UIAlertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)

        let okAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .default) { action -> Void in
            completion()
        }
        alertView.addAction(okAction)
        
       
        viewController.present(alertView, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidatedPhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidatedPhone10(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func setAutoToken(_ userID : String) -> Void {
        
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "AutoToken")
    }
    
//    func setUserModel(_ userID : UserModal) -> Void {
//
//        let defaults = UserDefaults.standard
//        defaults.set(userID, forKey: "setUserModel")
//    }
    
    func getUserModel() -> AnyObject {
        
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: "setUserModel") as AnyObject)
        
    }
    func getAutoToken() -> AnyObject {
        
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: "AutoToken") as AnyObject)
        
    }
    
    
    
    func setUserName(_ userID : NSString) -> Void {
        
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "UserName")
    }
    
    func getUserName() -> AnyObject {
        
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: "UserName") as AnyObject)
        
    }
    
    func setUserPassword(_ userID : NSString) -> Void {
        
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "Password")
    }
    
    func getUserPassword() -> AnyObject {
        
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: "Password") as AnyObject)
        
    }
    
    func setRemember(_ userID : Bool) -> Void {
        
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "REMEMBER")
    }
    
    func getREMEMBER() -> AnyObject {
        
        let defaults = UserDefaults.standard
        return (defaults.object(forKey: "REMEMBER") as AnyObject)
        
    }
    
    func imagepickerController(view : UIViewController){
        let alertView: UIAlertController = UIAlertController(title: Utilities.appName, message: "Select" as
            String, preferredStyle: .actionSheet)
        
          
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = false
            picker.view.tag = view.view.tag
            view.present(picker, animated: true, completion: nil)
        }
        
        alertView.addAction(galleryAction)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                let imag = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerController.SourceType.camera;
                imag.allowsEditing = false
                imag.view.tag = view.view.tag
                view.present(imag, animated: true, completion: nil)
                
            }
        }
        alertView.addAction(cameraAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
        }
        alertView.addAction(cancelAction)
        
        view.present(alertView, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            
                self.delegate?.getImageData(data: pickedImage.jpegData(compressionQuality: 0.1)!, image: pickedImage, tag: picker.view.tag)
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension NSDate {
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self as Date)
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String,font : CGFloat = 20) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
      //  messageLabel.font = UIFont(name: "TrebuchetMS", size: font)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

var rootController1:UIViewController?{
    if let window =  UIApplication.shared.windows.first(where: { $0.isKeyWindow}){
        return window.rootViewController
    }
    return UIViewController()
}
