//
//  EditProfileVC.swift
//  Blade
//
//  Created by cqlsys on 08/10/22.
//

import UIKit
import CountryPickerView
import GooglePlaces
import SDWebImage
import ImageCropper

class EditProfileVC: UIViewController, imageDelegate {
    let cpv = CountryPickerView()
    @IBOutlet weak var textFieldCountryCode: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    
    fileprivate var imageData: Data?
    fileprivate var lat: String = ""
    fileprivate var lng: String = ""
    
    
    @IBOutlet weak var viewBarber: UIView!
    @IBOutlet weak var enterBarberName: YourTextFieldSubclass!
    
    
    @IBOutlet weak var viewShopOwnerNumber: UIView!
    @IBOutlet weak var textFieldShopOwnerPhoneNumber: YourTextFieldSubclass!
    @IBOutlet weak var textFieldShopOwnerCountryCode: YourTextFieldSubclass!
    
    
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var textViewDescription: YourTextViewSubclass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.delegate = self
        cpv.dataSource = self
        self.setUpData()
        // Do any additional setup after loading the view.
    }
    
    func setUpData() {
        textFieldName.text = UserPreference.shared.data?.name ?? ""
        textFieldEmail.text = UserPreference.shared.data?.email ?? ""
        textFieldLocation.text = UserPreference.shared.data?.location ?? ""
        textFieldPhoneNumber.text = UserPreference.shared.data?.phone ?? ""
        textFieldCountryCode.text = UserPreference.shared.data?.countryCode ?? ""
        lat = UserPreference.shared.data?.latitude ?? ""
        lng = UserPreference.shared.data?.longitude ?? ""
        imageProfile.sd_setImage(with: URL(string:  UserPreference.shared.data?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
            
        })
        
        if UserPreference.shared.data?.role == 2 {
            viewDescription.isHidden = false
            viewShopOwnerNumber.isHidden = false
            viewBarber.isHidden = false
            enterBarberName.text = UserPreference.shared.data?.salonName ?? ""
            textFieldShopOwnerPhoneNumber.text = UserPreference.shared.data?.salonPhone ?? ""
            textFieldShopOwnerCountryCode.text = UserPreference.shared.data?.salonCountryCode ?? ""
            textViewDescription.text = UserPreference.shared.data?.salonDescription ?? ""
        }
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
        cpv.tag = sender.tag
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
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickUpdateProfile(_ sender: UIButton) {
        if textFieldName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter name", comment: "Please enter name"))
        } else if textFieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter email", comment: "Please enter email"))
        } else if !Utilities.sharedInstance.isValidEmail(testStr: textFieldEmail.text!) {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid email address", comment: "Please enter valid email address"))
        } else if textFieldPhoneNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter phone number", comment: "Please enter phone number"))
        } else if textFieldPhoneNumber.text!.count < 7 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid phone number", comment: "Please enter valid phone number"))
        } else if textFieldLocation.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select location", comment: "Please select location"))
        } else {
            if UserPreference.shared.data?.role == 2 {
                if enterBarberName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    Toast.shared.showAlert(type: .validationFailure, message: "Enter Salon Name")
                } else if textFieldShopOwnerPhoneNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    Toast.shared.showAlert(type: .validationFailure, message: "Enter Shop phone number")
                } else {
                    SignupEP.editProfile(name: textFieldName.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!, latitude: lat, longitude: lng, location: textFieldLocation.text!, image: imageData ?? Data(), salonCountryCode: textFieldShopOwnerCountryCode.text!, salonPhone: textFieldShopOwnerPhoneNumber.text!, salonName: enterBarberName.text!, salonDescription: textViewDescription.text!).request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? ObjectData<SignupModel> else { return }
                            if data.code == 200{
                                UserPreference.shared.data = data.data
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    } error: { error in
                        
                    }
                }
                

            } else {
                SignupEP.editProfile(name: textFieldName.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!,latitude: lat,longitude: lng,location: textFieldLocation.text!, image: imageData ?? Data(),salonCountryCode: "", salonPhone: "", salonName: "", salonDescription: "").request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SignupModel> else { return }
                        if data.code == 200{
                            if UserPreference.shared.data?.role ?? 0 == 1 {
                                if UserPreference.shared.data?.location ?? "" != self.textFieldLocation.text! {
                                    UserPreference.shared.data = nil
                                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                    let story = UIStoryboard.init(name: "Main", bundle: nil)
                                    let vw = story.instantiateViewController(withIdentifier: "InitVC")
                                    self.view.window?.rootViewController = vw
                                } else {
                                    UserPreference.shared.data = data.data
                                    Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                
                            } else {
                                UserPreference.shared.data = data.data
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                } error: { error in
                    
                }
            }
            

        }
    }
    
}

extension EditProfileVC: UITextFieldDelegate {
    
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

extension EditProfileVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        if cpv.tag == 2 {
            textFieldShopOwnerCountryCode.text =  country.phoneCode
        } else {
            textFieldCountryCode.text =  country.phoneCode
        }
        
    }
}



extension EditProfileVC: GMSAutocompleteViewControllerDelegate {

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
