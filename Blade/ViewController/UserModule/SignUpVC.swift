//
//  SignUpVC.swift
//  Blade
//
//  Created by cqlsys on 07/10/22.
//

import UIKit
import CountryPickerView
import GooglePlaces
import ImageCropper

class SignUpVC: UIViewController,imageDelegate {
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var flagING: UIImageView!
    let cpv = CountryPickerView()
    @IBOutlet weak var textFieldCountryCode: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var btnShopOwner: UIButton!
    @IBOutlet weak var btnCustomer: UIButton!
    fileprivate var imageData: Data?
    fileprivate var lat: String = ""
    fileprivate var lng: String = ""
    var type: Int = 0
    
    @IBOutlet weak var btnTerms: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.delegate = self
        cpv.dataSource = self
        
        if #available(iOS 16, *) {
            if let countryCode = Locale.current.region?.identifier as? String {
                cpv.setCountryByCode(countryCode)
                textFieldCountryCode.text = cpv.selectedCountry.phoneCode
                flagING.image = cpv.selectedCountry.flag
            }
        } else {
            let countryCode =  Locale.current.regionCode ?? ""
            cpv.setCountryByCode(countryCode)
            textFieldCountryCode.text = cpv.selectedCountry.phoneCode
            flagING.image = cpv.selectedCountry.flag
            // Fallback on earlier versions
        }
        
        if type == 0 {
            self.onClickCustomer(btnCustomer)
        } else {
            self.onClickShopOwner(btnShopOwner)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type != 0 {
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
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickShopOwner(_ sender: UIButton) {
        labelName.text = NSLocalizedString("Shop Owner Name", comment: "Shop Owner Name")
        labelLocation.text = NSLocalizedString("Location Address", comment: "Location Address") 
        btnShopOwner.isSelected = true
        btnCustomer.isSelected = false
    }
    
    @IBAction func onClickCustomer(_ sender: UIButton) {
        btnCustomer.isSelected = true
        btnShopOwner.isSelected = false
      //  labelName.text = NSLocalizedString("Please select image", comment: "Please select image")
    }
    
    @IBAction func onClickLocation(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        if #available(iOS 13.0, *) {
            autocompleteController.tableCellBackgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func onClickUploadImage(_ sender: UIButton) {
        Utilities.sharedInstance.delegate = self
        Utilities.sharedInstance.imagepickerController(view: self)
    }
    
    @IBAction func onClickCountruCode(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
    }
    
    func getImageData(data: Data, image: UIImage, tag: Int) {

        var config = ImageCropperConfiguration(with: image, and: .customRect)
        config.customRatio = CGSize(width: 1, height: 1)
        config.maskFillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.75)
        config.borderColor = UIColor.black

        config.showGrid = true
        config.gridColor = UIColor.white
        config.doneTitle = "CROP"
        config.cancelTitle = "Back"

        let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
            self.imageProfile.image = _croppedImage
            self.imageData = _croppedImage?.jpegData(compressionQuality: 1) ?? Data()

        }) {
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(cropper, animated: true)


    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAccept(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "PageVC") as! PageVC
        vw.type = .term
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickTerms(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        if imageData?.count ?? 0 == 0 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select image", comment: "Please select image"))
        } else if textFieldName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter name", comment: "Please enter name"))
        } else if textFieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter email", comment: "Please enter email"))
        } else if !Utilities.sharedInstance.isValidEmail(testStr: textFieldEmail.text!) {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid email address", comment: "Please enter valid email address"))
        } else if textFieldPhoneNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter phone number", comment: "Please enter phone number"))
        } else if textFieldCountryCode.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please select country code.")
        } else if textFieldPhoneNumber.text!.count < 7 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid phone number", comment: "Please enter valid phone number"))
        } else if textFieldLocation.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select location", comment: "Please select location"))
        } else if textFieldPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter password", comment: "Please enter password"))
        } else if btnTerms.isSelected == false {
            
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select terms", comment: "Please select terms"))
        } else {
            SignupEP.signup(role: btnCustomer.isSelected == true ? "1" : "2", name: textFieldName.text!, email: textFieldEmail.text!, password: textFieldPassword.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!, latitude: lat, longitude: lng, location: textFieldLocation.text!, image: imageData!).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SignupModel> else { return }
                    if data.code == 200{
                        
                        if self.btnShopOwner.isSelected == true {
                            UserPreference.shared.data = data.data
                            let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonDetailVC") as! AddSaloonDetailVC
                            self.navigationController?.pushViewController(vw, animated: true)
                            
                        } else {
                            Utilities.sharedInstance.showAlertViewWithAction1("", (data.msg ?? "") , self) {
                                let vw = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                                self.view.window?.rootViewController = vw
                            }
                        }
                    }
                }
            } error: { error in
                
            }

        }
    }
    
    @IBAction func onClickEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        textFieldPassword.isSecureTextEntry = !sender.isSelected
    }
    
}

extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhoneNumber {
            let maxLength = 15
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        return true
    }
}

extension SignUpVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        flagING.image = country.flag
        textFieldCountryCode.text =  "\(country.phoneCode )"
    }
}



extension SignUpVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    textFieldLocation.text = place.name
      lat = "\(place.coordinate.latitude ?? 0)"
      lng = "\(place.coordinate.longitude ?? 0)"
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
