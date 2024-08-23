//
//  AddSaloonStylistVC.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit
import CountryPickerView
import SDWebImage
import ImageCropper


class AddSaloonStylistVC: UIViewController, imageDelegate {
   
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var labelHe: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    @IBOutlet weak var textViewBio: UITextView!
    let cpv = CountryPickerView()
    @IBOutlet weak var textFieldCountryCode: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textFieldSaloonService: UITextField!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    var type: AddStylistType = .add
    var obj: SaloonStylistDetailModel?
    fileprivate var imageData: Data?
    var idStr = ""
    var idDelete = ""
    var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        cpv.delegate = self
        cpv.dataSource = self

        if type  == .signup {
            self.apiCallSet()
        }
        if type == .edit {
            self.setUpData()
            labelHe.text = ""
        } else {
            labelHe.text = NSLocalizedString("Employees will receive  their login details and they must login as clients.", comment: "Employees will receive  their login details and they must login as clients.")
            labelTitle.text = NSLocalizedString("Add barber", comment: "Add barber")
            
            textFieldCountryCode.text = "+357"
            
            cpv.setCountryByPhoneCode("+357")
            flag.image = cpv.selectedCountry.flag
            
            
//            cpv.setCountryByPhoneCode("+93")
//            textFieldCountryCode.text = "+93"
//            flag.image = cpv.selectedCountry.flag
            if type == .signup {
                
                btnSkip.isHidden = false
            }
            textFieldEmail.isUserInteractionEnabled = true
        }
        
        // Do any additional setup after loading the view.
    }

    func apiCallSet() {
        SignupEP.upDateAutoAccept(isAutoAcceptBooking: "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<SignupModel> else { return }
                if data.code == 200{
                    UserPreference.shared.data = data.data
                }
            }
        } error: { error in

        }
    }
    
    func setUpData() {
        if UserPreference.shared.data?.role ?? 0 == 3 {
            textFieldName.text = UserPreference.shared.data?.name ?? ""
            textFieldEmail.text = UserPreference.shared.data?.email ?? ""
            textFieldPhoneNumber.text = UserPreference.shared.data?.phone ?? ""
            textFieldCountryCode.text = UserPreference.shared.data?.countryCode ?? ""
            textViewBio.text = UserPreference.shared.data?.bio ?? ""
            
            
            cpv.setCountryByPhoneCode(UserPreference.shared.data?.countryCode ?? "")
            
            flag.image = cpv.selectedCountry.flag
            
            imageProfile.sd_setImage(with: URL(string:  UserPreference.shared.data?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            
            var serviceStr = ""
            
            for i in UserPreference.shared.data?.salonServices ?? [] {
                if serviceStr == "" {
                    serviceStr = i.serviceName ?? ""
                    idStr = "\(i.id ?? 0)"
                } else {
                    serviceStr = "\(serviceStr), \(i.serviceName ?? "")"
                    idStr = "\(idStr), \(i.id ?? 0)"
                }
            }
            
            textFieldSaloonService.text = serviceStr
            
        } else {
            if obj?.status == 0 {
                btnSwitch.isOn = false
            } else {
                btnSwitch.isOn = true
            }
            btnSwitch.isHidden = false
            textFieldName.text = obj?.name ?? ""
            textFieldEmail.text = obj?.email ?? ""
            textFieldPhoneNumber.text = obj?.phone ?? ""
            textFieldCountryCode.text = obj?.countryCode ?? ""
            textViewBio.text = obj?.bio ?? ""
            imageProfile.sd_setImage(with: URL(string:  obj?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            
            
            var serviceStr = ""
            
            for i in obj?.salonServices ?? [] {
                if serviceStr == "" {
                    serviceStr = i.serviceName ?? ""
                    idStr = "\(i.id ?? 0)"
                } else {
                    serviceStr = "\(serviceStr), \(i.serviceName ?? "")"
                    idStr = "\(idStr), \(i.id ?? 0)"
                }
            }
            
            textFieldSaloonService.text = serviceStr
        }
        
    }
    
    
   
    
    @IBAction func onClickSelectStylist(_ sender: UIButton) {
        if UserPreference.shared.data?.role ?? 0 == 3 {
            
        } else {
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceVC") as! SelectServiceVC
            vw.modalPresentationStyle = .overFullScreen
            vw.obj = obj
            vw.type = .editStylist
            vw.onBackEdit = { [weak self] (serviceName, serviceID, serviceDeleted) in
                self?.idStr = serviceID
                self?.idDelete = serviceDeleted
                self?.textFieldSaloonService.text = serviceName
            }
            self.present(vw, animated: true, completion: nil)
        }
        
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

//        imageProfile.image = image
//        imageData = data
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        if type == .signup {
            
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewVC") as! SubscriptionViewVC
            self.navigationController?.pushViewController(vw, animated: true)
            
//            let story = UIStoryboard.init(name: "Salon", bundle: nil)
//            let vw = story.instantiateViewController(withIdentifier: "SaloonTB")
//            self.view.window?.rootViewController = vw
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func onClickUpdateProfile(_ sender: UIButton) {
        if type == .add && imageData?.count ?? 0 == 0 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select image", comment: "Please select image"))
        } else if textFieldName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter saloon name", comment: "Please enter saloon name"))
        } else if textFieldEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter email", comment: "Please enter email"))
        } else if !Utilities.sharedInstance.isValidEmail(testStr: textFieldEmail.text!) {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter valid email address", comment: "Please enter valid email address"))
        } else if textFieldSaloonService.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select saloon service", comment: "Please select saloon service"))
        } else if textFieldPhoneNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter phone number", comment: "Please enter phone number"))
        } else if textFieldPhoneNumber.text!.count < 7 {
            Toast.shared.showAlert(type: .validationFailure, message:  NSLocalizedString("Please enter valid phone number", comment: "Please enter valid phone number"))
        } else if textViewBio.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter bio", comment: "Please enter bio"))
        } else {
            if type == .edit {
                if UserPreference.shared.data?.role ?? 0 == 3 {
                    SignupEP.editStylistProfile(name: textFieldName.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!, bio: textViewBio.text!, image: imageData ?? Data()).request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? ObjectData<SignupModel> else { return }
                            if data.code == 200{
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                                UserPreference.shared.data = data.data
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } error: { error in
                        
                    }
                } else {
                    SignupEP.editSalonStylist(id: "\(obj?.id ?? 0)", name: textFieldName.text!, email: textFieldEmail.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!, bio: textViewBio.text!, salonServiceIds: idStr, status: btnSwitch.isOn == true ? "1": "0",deleteSalonServiceIds: idDelete, image: imageData ?? Data()).request(showSpinner: true) { response in
                        if response != nil{
                            guard let data = response as? ObjectData<SaloonStylistDetailModel> else { return }
                            if data.code == 200{
                                Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                               
                                var obj = UserPreference.shared.data
                                var arr = UserPreference.shared.data?.salonStylists ?? []
                                arr[self.index] = data.data!
                                obj?.salonStylists = arr
                                UserPreference.shared.data = obj
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } error: { error in
                        
                    }
                }
                
            } else {
                SignupEP.addSalonStylist(name: textFieldName.text!, email: textFieldEmail.text!, countryCode: textFieldCountryCode.text!, phone: textFieldPhoneNumber.text!, salonServiceIds: idStr, bio: textViewBio.text!, image: imageData ?? Data()).request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SaloonStylistDetailModel> else { return }
                        if data.code == 200{
                            Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                            var obj = UserPreference.shared.data
                            var arr = UserPreference.shared.data?.salonStylists ?? []
                            arr.append(data.data!)
                            obj?.salonStylists = arr
                            UserPreference.shared.data = obj
                            
                            if self.type == .signup {
                                let vw = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewVC") as! SubscriptionViewVC
                                self.navigationController?.pushViewController(vw, animated: true)
                                
                                
                            } else {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                } error: { error in
                    
                }

            }
        }
    }
    
}

extension AddSaloonStylistVC: UITextFieldDelegate {
    
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

extension AddSaloonStylistVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        flag.image = country.flag
        textFieldCountryCode.text =  country.phoneCode
    }
}



enum AddStylistType {
    case add
    case edit
    case signup
}
