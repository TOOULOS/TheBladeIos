//
//  AddSaloonDetailVC.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit
import CountryPickerView
import GooglePlaces
import ImageCropper

class AddSaloonDetailVC: UIViewController, imageDelegate {
    let cpv = CountryPickerView()
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldCountryCode: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var buttonFour: UIButton!
    @IBOutlet weak var buttonThird: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonFirst: UIButton!
    fileprivate var lat: String = ""
    fileprivate var lng: String = ""
    var imageArray: [Data] = [Data(), Data(), Data(), Data()]
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.delegate = self
        cpv.dataSource = self
        

        if #available(iOS 16, *) {
            if let countryCode = Locale.current.region?.identifier as? String {
                cpv.setCountryByCode(countryCode)
                textFieldCountryCode.text = cpv.selectedCountry.phoneCode
                flag.image = cpv.selectedCountry.flag
            }
        } else {
            let countryCode =  Locale.current.regionCode ?? ""
            cpv.setCountryByCode(countryCode)
            textFieldCountryCode.text = cpv.selectedCountry.phoneCode
            flag.image = cpv.selectedCountry.flag
            // Fallback on earlier versions
        }

        //textFieldCountryCode.text = "+357"
        
      //  cpv.setCountryByPhoneCode("+357")
        //flag.image = cpv.selectedCountry.flag
        
//        textFieldCountryCode.text = "+93"
//        flag.image = cpv.selectedCountry.flag
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please complete signup process to make your shop visible.", comment: "Please complete signup process to make your shop visible."))
       // self.navigationController?.popToRootViewController(animated: true)
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
            if tag == 1 {
                self.imageArray.insert(_croppedImage!.jpegData(compressionQuality: 1)!, at: 0)
                self.buttonFirst.setImage(_croppedImage, for: .normal)
            } else if tag == 2 {
                self.imageArray.insert(_croppedImage!.jpegData(compressionQuality: 1)!, at: 1)
                self.buttonSecond.setImage(_croppedImage, for: .normal)
            } else if tag == 3 {
                self.imageArray.insert(_croppedImage!.jpegData(compressionQuality: 1)!, at: 2)
                self.buttonThird.setImage(_croppedImage, for: .normal)
            } else if tag == 4 {
                self.imageArray.insert(_croppedImage!.jpegData(compressionQuality: 1)!, at: 3)
                self.buttonFour.setImage(_croppedImage, for: .normal)
            }
            
        }) {
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(cropper, animated: true)



    }
    
    @IBAction func onClickUploadImage(_ sender: UIButton) {
        Utilities.sharedInstance.delegate = self
        self.view.tag = sender.tag
        Utilities.sharedInstance.imagepickerController(view: self)
    }
    
    @IBAction func onClickCountryCode(_ sender: UIButton) {
        cpv.showCountriesList(from: self)
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
    
    
    @IBAction func onClickNext(_ sender: UIButton) {
        if imageArray[0].count == 0 && imageArray[1].count == 0 && imageArray[2].count == 0 && imageArray[3].count == 0 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select image", comment: "Please select image"))
        } else if textFieldName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter name", comment: "Please enter name"))
        } else if textFieldPhone.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter phone number", comment: "Please enter phone number"))
//        } else if textFieldLocation.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter location", comment: "Please enter location"))
        } else if textViewDescription.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter description", comment: "Please enter description"))
        } else {
            SignupEP.salonSignupStep2AddSalonDetails(salonName: textFieldName.text!, salonDescription: textViewDescription.text!, salonCountryCode: textFieldCountryCode.text!, salonPhone: textFieldPhone.text!, salonImages: imageArray).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                        let vw = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonTimingVC") as! AddSaloonTimingVC
                        self.navigationController?.pushViewController(vw, animated: true)
                    }
                }
            } error: { error in
                
            }

            
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

extension AddSaloonDetailVC: GMSAutocompleteViewControllerDelegate {

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

extension AddSaloonDetailVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhone {
            let maxLength = 15
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        return true
    }
}

extension AddSaloonDetailVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        flag.image = country.flag
        textFieldCountryCode.text =  country.phoneCode
    }
}
