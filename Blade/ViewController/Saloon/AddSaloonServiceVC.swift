//
//  AddSaloonServiceVC.swift
//  Blade
//
//  Created by cqlsys on 12/10/22.
//

import UIKit

class AddSaloonServiceVC: UIViewController {
    @IBOutlet weak var btnAddMore: CustomButton!
    
    @IBOutlet weak var btnSwitchFive: UISwitch!
    @IBOutlet weak var btnSwitchFour: UISwitch!
    @IBOutlet weak var btnSwitchThird: UISwitch!
    @IBOutlet weak var btnSwitchSecond: UISwitch!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var textFieldDescription: YourTextFieldSubclass!
    
    
    
    @IBOutlet weak var textFieldFivePrice: YourTextFieldSubclass!
    @IBOutlet weak var textFieldFourPrice: YourTextFieldSubclass!
    @IBOutlet weak var textFieldThirdPrice: YourTextFieldSubclass!
    @IBOutlet weak var textFieldSecondPrice: YourTextFieldSubclass!
    @IBOutlet weak var textFieldPrice: YourTextFieldSubclass!
    
    
    
    
    
    @IBOutlet weak var textFieldTimeTwo: YourTextFieldSubclass!
    @IBOutlet weak var textFieldTImeThree: YourTextFieldSubclass!
    @IBOutlet weak var textFieldTimeFour: YourTextFieldSubclass!
    @IBOutlet weak var textFieldTimeFive: YourTextFieldSubclass!
    @IBOutlet weak var textFIeldTIme: YourTextFieldSubclass!
    @IBOutlet weak var labelTItle: UILabel!
    
    @IBOutlet weak var textFieldTwoServiceName: YourTextFieldSubclass!
    @IBOutlet weak var textFieldThreeServiceName: YourTextFieldSubclass!
    @IBOutlet weak var textFieldFourServiceName: YourTextFieldSubclass!
    @IBOutlet weak var textFieldFiveServiceName: YourTextFieldSubclass!
    @IBOutlet weak var textFieldServiceName: YourTextFieldSubclass!
    var type: AddSaloonServiceVCType = .signup
    var objService: SaloonStylistServiceModel?
    var index: Int = 0
    
    
    
    @IBOutlet weak var stackSecond: UIStackView!
    @IBOutlet weak var stackFive: UIStackView!
    @IBOutlet weak var stackFour: UIStackView!
    @IBOutlet weak var stackThird: UIStackView!
    
    
    
    fileprivate var saloonTimeArray: [String] = ["",NSLocalizedString("10 minutes", comment: "10 minutes"),
                                                 NSLocalizedString("20 minutes", comment: "20 minutes"),
                                                 NSLocalizedString("30 minutes", comment: "30 minutes"),
                                                 NSLocalizedString("40 minutes", comment: "40 minutes"),
                                                 NSLocalizedString("50 minutes", comment: "50 minutes"),
                                                 NSLocalizedString("60 minutes", comment: "60 minutes"),
                                                 NSLocalizedString("70 minutes", comment: "70 minutes"),
                                                 NSLocalizedString("80 minutes", comment: "80 minutes"),
                                                 NSLocalizedString("90 minutes", comment: "90 minutes"),
                                                 NSLocalizedString("100 minutes", comment: "100 minutes"),
                                                 NSLocalizedString("110 minutes", comment: "110 minutes"),
                                                 NSLocalizedString("120 minutes", comment: "120 minutes"),
                                                 NSLocalizedString("130 minutes", comment: "130 minutes"),
                                                 NSLocalizedString("140 minutes", comment: "140 minutes"),
                                                 NSLocalizedString("150 minutes", comment: "150 minutes"),
                                                 NSLocalizedString("160 minutes", comment: "160 minutes"),
                                                 NSLocalizedString("170 minutes", comment: "170 minutes"),
                                                 NSLocalizedString("180 minutes", comment: "180 minutes")]
    fileprivate var saloonTimeStringArray: [String] = ["","10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "110", "120", "130", "140", "150", "160", "170", "180"]
    fileprivate var timeString = ""
    fileprivate var timeSecondString = ""
    fileprivate var timeThirdString = ""
    fileprivate var timeFourString = ""
    fileprivate var timeFiveString = ""
    
    fileprivate var timePicker = UIPickerView()
    fileprivate var timePicker2 = UIPickerView()
    fileprivate var timePicker3 = UIPickerView()
    fileprivate var timePicker4 = UIPickerView()
    fileprivate var timePicker5 = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        timePicker.tag = 1
        textFIeldTIme.inputView = timePicker
        
        timePicker2.delegate = self
        timePicker2.tag = 2
        textFieldTimeTwo.inputView = timePicker2
        
        timePicker3.delegate = self
        timePicker3.tag = 3
        textFieldTImeThree.inputView = timePicker3
        
        timePicker4.delegate = self
        timePicker4.tag = 4
        textFieldTimeFour.inputView = timePicker4
        
        timePicker5.delegate = self
        timePicker5.tag = 5
        textFieldTimeFive.inputView = timePicker5
        
        if type ==   .edit {
            textFieldDescription.text = objService?.serviceDescription ?? ""
            textFieldServiceName.text = objService?.serviceName ?? ""
            textFIeldTIme.text = objService?.time ?? ""
            textFieldPrice.text = objService?.price ?? ""
            labelTItle.text = NSLocalizedString("Edit Salon Services", comment: "Edit Salon Services")
            if objService?.status ?? 0 == 0 {
                btnSwitch.isOn = false
            } else {
                btnSwitch.isOn = true
            }
            btnAdd.setTitle("Edit Service", for: .normal)
            btnAddMore.isHidden = true
            timeString = objService?.timeValue ?? ""
        } else if type == .signup {
            btnAddMore.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        if type == .edit {
            self.navigationController?.popViewController(animated: true)
        } else if type == .signup{
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please complete signup process to make your shop visible.", comment: "Please complete signup process to make your shop visible."))
        } else {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    @IBAction func onClickAddService(_ sender: UIButton) {
        if textFieldServiceName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter service name", comment: "Please enter service name"))
        } else if textFieldPrice.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter price", comment: "Please enter price"))
        } else if textFIeldTIme.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select time", comment: "Please select time"))
        }
//        else if textFieldDescription.text!.trimmingCharacters(in: .whitespaces).isEmpty {
//            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please enter description", comment: "Please enter description"))
//        }
        else {
            if type ==   .edit {
                SignupEP.editSalonService(id: "\(objService?.id ?? 0)", serviceType: "\(objService?.serviceType ?? 0)", serviceName: textFieldServiceName.text!, serviceDescription: "test", price: textFieldPrice.text!, time: textFIeldTIme.text!, timeValue: timeString, status: btnSwitch.isOn == true ? "1" : "0").request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SaloonStylistServiceModel> else { return }
                        if data.code == 200{
                            Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                            var obj = UserPreference.shared.data
                            var arr = UserPreference.shared.data?.salonServices ?? []
                            arr[self.index] = data.data!
                            obj?.salonServices = arr
                            UserPreference.shared.data = obj
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } error: { error in
                    
                }

            } else if type == .add {
                SignupEP.addSalonService(serviceType: "1", serviceName: textFieldServiceName.text!, serviceDescription: "test", price: textFieldPrice.text!, time: textFIeldTIme.text!, timeValue: timeString).request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SaloonStylistServiceModel> else { return }
                        if data.code == 200{
                            Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                            
                            var obj = UserPreference.shared.data
                            var arr = UserPreference.shared.data?.salonServices ?? []
                            arr.append(data.data!)
                            obj?.salonServices = arr
                            UserPreference.shared.data = obj
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } error: { error in
                    
                }
            } else if type == .signup {
                var objArray: [[String: String]] = []
                objArray.append(["serviceName": textFieldServiceName.text!,
                                 "serviceType": "1",
                                 "serviceDescription": "test",
                                 "price": textFieldPrice.text!,
                                 "time": textFIeldTIme.text!,
                                 "timeValue": timeString])
                if stackSecond.isHidden == false {
                    if textFieldTwoServiceName.text! == "" || textFieldSecondPrice.text! == "" || textFieldTimeTwo.text! == "" {
                        return
                    } else {
                        objArray.append(["serviceName": textFieldTwoServiceName.text!,
                                         "serviceType": "1",
                                         "serviceDescription": "test",
                                         "price": textFieldSecondPrice.text!,
                                         "time": textFieldTimeTwo.text!,
                                         "timeValue": timeSecondString])
                    }
                }
                
                if stackThird.isHidden == false {
                    if textFieldThreeServiceName.text! == "" || textFieldThirdPrice.text! == "" || textFieldTImeThree.text! == "" {
                        return
                    } else {
                        objArray.append(["serviceName": textFieldThreeServiceName.text!,
                                         "serviceType": "1",
                                         "serviceDescription": "test",
                                         "price": textFieldThirdPrice.text!,
                                         "time": textFieldTImeThree.text!,
                                         "timeValue": timeThirdString])
                    }
                }
                
                if stackFour.isHidden == false {
                    if textFieldFourServiceName.text! == "" || textFieldFourPrice.text! == "" || textFieldTimeFour.text! == "" {
                        return
                    } else {
                        objArray.append(["serviceName": textFieldFourServiceName.text!,
                                         "serviceType": "1",
                                         "serviceDescription": "test",
                                         "price": textFieldFourPrice.text!,
                                         "time": textFieldTimeFour.text!,
                                         "timeValue": timeFourString])
                    }
                }
                
                if stackFive.isHidden == false {
                    if textFieldFiveServiceName.text! == "" || textFieldFivePrice.text! == "" || textFieldTimeFive.text! == "" {
                        return
                    } else {
                        objArray.append(["serviceName": textFieldFiveServiceName.text!,
                                         "serviceType": "1",
                                         "serviceDescription": "test",
                                         "price": textFieldFivePrice.text!,
                                         "time": textFieldTimeFive.text!,
                                         "timeValue": timeFiveString])
                    }
                }
                
                SignupEP.salonSignupStep4AddSalonServices(salonServices: objArray).request(showSpinner: true) { response in
                    if response != nil{
                        guard let data = response as? ObjectData<SignupModel> else { return }
                        if data.code == 200{
                            Toast.shared.showAlert(type: .success, message: data.msg ?? "")
                            UserPreference.shared.data = data.data
                            let vwc = self.storyboard?.instantiateViewController(withIdentifier: "AddSaloonStylistVC") as! AddSaloonStylistVC
                            vwc.type = .signup
                            self.navigationController?.pushViewController(vwc, animated: true)
                        }
                    }
                } error: { error in
                    
                }

            }
        }
    }
    
    @IBAction func onClickRemove(_ sender: UIButton) {
        if stackFive.isHidden == false {
            stackFive.isHidden = true
        } else if stackFour.isHidden == false {
            stackFour.isHidden = true
        } else if stackThird.isHidden == false {
            stackThird.isHidden = true
        } else if stackSecond.isHidden == false {
            stackSecond.isHidden = true
        }
    }
    
    @IBAction func onClickAddMore(_ sender: UIButton) {
        if stackSecond.isHidden == true {
            stackSecond.isHidden = false
        } else if stackThird.isHidden == true {
            stackThird.isHidden = false
        } else if stackFour.isHidden == true {
            stackFour.isHidden = false
        } else if stackFive.isHidden == true {
            stackFive.isHidden = false
        }
    }
    
    
}

extension AddSaloonServiceVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return saloonTimeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return saloonTimeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            textFIeldTIme.text = saloonTimeArray[row]
            timeString = saloonTimeStringArray[row]
        } else if pickerView.tag == 2 {
            textFieldTimeTwo.text = saloonTimeArray[row]
            timeSecondString = saloonTimeStringArray[row]
        } else if pickerView.tag == 3 {
            textFieldTImeThree.text = saloonTimeArray[row]
            timeThirdString = saloonTimeStringArray[row]
        } else if pickerView.tag == 4 {
            textFieldTimeFour.text = saloonTimeArray[row]
            timeFourString = saloonTimeStringArray[row]
        } else if pickerView.tag == 5 {
            textFieldTimeFive.text = saloonTimeArray[row]
            timeFiveString = saloonTimeStringArray[row]
        }
        
    }
}

enum AddSaloonServiceVCType {
    case signup
    case add
    case edit
}
