//
//  SaloonDashboardVC.swift
//  Blade
//
//  Created by cqlsys on 24/10/22.
//

import UIKit
import ChartProgressBar

class SaloonDashboardVC: UIViewController, ChartProgressBarDelegate {
    func ChartProgressBar(_ chartProgressBar: ChartProgressBar, didSelectRowAt rowIndex: Int) {

    }
    
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var saloonVW: UIView!
    @IBOutlet weak var labelBarber: UILabel!
    
    @IBOutlet weak var labelSubTotal: UILabel!
    @IBOutlet weak var saloonCV: UICollectionView!
    @IBOutlet weak var labelTotalEarning: UILabel!
    @IBOutlet weak var chary: ChartProgressBar!
    @IBOutlet weak var btnStylist: UIButton!
    @IBOutlet weak var btnSalon: UIButton!
    @IBOutlet weak var yearlyTxtField: UITextField!
    let picker = UIPickerView()
    let pickerArray = [NSLocalizedString("Weekly", comment: "Weekly"),
                       NSLocalizedString("Monthly", comment: "Monthly"),
                       NSLocalizedString("Yearly", comment: "Yearly")]
    
    var months = [NSLocalizedString("Jan", comment: "Jan"),
                  NSLocalizedString("Feb", comment: "Feb"),
                  NSLocalizedString("Mar", comment: "Mar"),
                  NSLocalizedString("Apr", comment: "Apr"),
                  NSLocalizedString("May", comment: "May"),
                  NSLocalizedString("Jun", comment: "Jun"),
                  NSLocalizedString("Jul", comment: "Jul"),
                  NSLocalizedString("Aug", comment: "Aug"),
                  NSLocalizedString("Sep", comment: "Sep"),
                  NSLocalizedString("Oct", comment: "Oct"),
                  NSLocalizedString("Nov", comment: "Nov"),
                  NSLocalizedString("Dec", comment: "Dec")]
    var monthsKey = [String]()
    var sales = [Double]()
    var salesAdminArray: [[String: Any]] = []
    var selectedIndexId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        yearlyTxtField.inputView = picker
        picker.selectRow(2, inComponent: 0, animated: false)
        yearlyTxtField.delegate = self
        
        yearlyTxtField.text = NSLocalizedString("Weekly", comment: "Weekly")
        onClickSalon(btnSalon)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCall(stylistId: "")
    }
    
    @IBAction func onClickStylist(_ sender: UIButton) {
        sender.isSelected = true
        btnSalon.isSelected = false
        self.apiCall(stylistId: "")
        self.chary.removeClickedBar()
        saloonVW.isHidden = false
        labelBarber.text = NSLocalizedString("All Barbers Earnings", comment: "All Barbers Earnings")
        
    }
    
    @IBAction func onClickSalon(_ sender: UIButton) {
        selectedIndexId = 0
        saloonCV.reloadData()
        saloonVW.isHidden = true
        sender.isSelected = true
        btnStylist.isSelected = false
        self.apiCall(stylistId: "")
        self.chary.removeClickedBar()
        labelBarber.text = NSLocalizedString("Shop Owner Earnings", comment: "Shop Owner Earnings")
        
    }
    
    func apiCall( stylistId: String) {
        if UserPreference.shared.data?.role == 3 {
            btnSalon.isHidden = true
            btnStylist.isHidden = true
        }
        let date = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        
        var type = "3"
        if yearlyTxtField.text! == NSLocalizedString("Weekly", comment: "Weekly") {
            type = "1"
        } else if yearlyTxtField.text! == NSLocalizedString("Monthly", comment: "Monthly") {
            type = "2"
        }
        if UserPreference.shared.data?.role == 3 {
            viewFirst.isHidden = true
            viewSecond.isHidden = true
            SignupEP.getChartDataStylistSide(type: type, year: "\(year)").request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<DashboardBodyModel> else { return }
                    if data.code == 200{
                        self.salesAdminArray.removeAll()
                        if type == "2" {
                            let count = (data.data?.chartData?.count ?? 0)
                            
                            for i in 0 ..< count {
                                if i == 0 || i == 4 || i == 8 || i == 12 || i == 16 || i == 18 || i == 20 || i == 24 || i == 28 {
                                    self.salesAdminArray.append(["val": (data.data?.chartData?[i].earning ?? 0), "key": "\(i)"])
                                }
                            }
                        } else {
                            for i in data.data?.chartData ?? [] {
                                self.salesAdminArray.append(["val": i.earning ?? 0, "key": i.date ?? ""])
                            }
                        }
                        
                        
                        self.setData(index: 6)
                    }
                }
            } error: { error in
                
            }
        } else {
            SignupEP.getChartDataSalonSide(type: type, whoseData: btnSalon.isSelected == true ? "1" : "2", stylistId: stylistId,year: "\(year)").request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<DashboardBodyModel> else { return }
                    if data.code == 200{
                        self.salesAdminArray.removeAll()
                        
                        if type == "2" {
                            let count = (data.data?.chartData?.count ?? 0)
                            
                            for i in 0 ..< count {
                                if i == 0 || i == 4 || i == 8 || i == 12 || i == 16 || i == 18 || i == 20 || i == 24 || i == 28 {
                                    self.salesAdminArray.append(["val": (data.data?.chartData?[i].earning ?? 0), "key": "\(i)"])
                                }
                            }
                        } else {
                            for i in data.data?.chartData ?? [] {
                                self.salesAdminArray.append(["val": i.earning ?? 0, "key": i.date ?? ""])
                            }
                        }
                        
                        if stylistId == "" && self.btnSalon.isSelected == true {
                            self.labelTotalEarning.text = "€ \((data.data?.salonTotalEarning ?? 0) + (data.data?.stylistsTotalEarning ?? 0))"
                            self.labelSubTotal.text = "€ \(data.data?.salonTotalEarning ?? 0)"
                        } else {
                            self.labelSubTotal.text = "€ \(data.data?.stylistsTotalEarning ?? 0)"
                            self.labelTotalEarning.text = "€ \((data.data?.salonTotalEarning ?? 0) + (data.data?.stylistsTotalEarning ?? 0))"
                            
                        }
                        //labelTotalEarning.text = "€ \(totalCount)"
                        self.setData(index: 6)
                    }
                }
            } error: { error in
                
            }
        }
        
    }
    
    func setData(index: Int) {
        var data: [BarData] = []
        var totalCount = 0.0
        for i in salesAdminArray {
            if yearlyTxtField.text == NSLocalizedString("Monthly", comment: "Monthly") {
                 
                let last4 = "\(i["key"] as? String ?? "")".suffix(2) ?? ""
                data.append(BarData.init(barTitle: "\(last4)", barValue: Float(i["val"] as? Double ?? 0), pinText: "€ \(i["val"] as? Double ?? 0)"))
            } else {
                data.append(BarData.init(barTitle: i["key"] as? String ?? "", barValue: Float(i["val"] as? Double ?? 0), pinText: "€ \(i["val"] as? Double ?? 0)"))
            }
            totalCount = totalCount + (i["val"] as? Double ?? 0)
        }

        
        if chary.data?.count ?? 0 > 0 {
            chary.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
          //  chary.removeValues()
            chary.data = data
            //chary.resetValues()
            chary.build()
        } else {
            chary.data = data
            chary.barsCanBeClick = true
            //chary.maxValue = 10.0
            chary.emptyColor = UIColor.clear
            chary.barWidth = 7
            chary.progressColor = UIColor.init(red: 255 / 255, green: 236 / 255 , blue: 183 / 255, alpha: 0.92)
            chary.progressClickColor = UIColor.init(red: 214 / 255, green: 187 / 255 , blue: 114 / 255, alpha: 1)
            chary.barHeight = Float(chary.frame.size.height) - 50.0
            chary.pinBackgroundColor = UIColor.init(red: 214 / 255, green: 187 / 255 , blue: 114 / 255, alpha: 1)
            chary.pinTxtColor = UIColor.white
            chary.barTitleColor = UIColor.white
            chary.barTitleSelectedColor = UIColor.init(red: 214 / 255, green: 187 / 255 , blue: 114 / 255, alpha: 1)
            chary.pinMarginBottom = 15
            chary.pinWidth = 70
            chary.pinHeight = 29
            chary.pinTxtSize = 17
            chary.delegate = self
            chary.build()
        }
    }
}

extension SaloonDashboardVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.apiCall(stylistId: "")
        }
        
    }
}

extension SaloonDashboardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearlyTxtField.text = pickerArray[row]
    }
}

extension SaloonDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserPreference.shared.data?.salonStylists?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
        
        let obj = UserPreference.shared.data?.salonStylists?[indexPath.row]
        if selectedIndexId == obj?.id ?? 0 {
            cell.labelName.textColor = UIColor.init(named: "Color_button")
        } else {
            cell.labelName.textColor = UIColor.white
        }
        cell.labelName.text = obj?.name ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = UserPreference.shared.data?.salonStylists?[indexPath.row]
        if selectedIndexId == obj?.id ?? 0 {
            selectedIndexId = 0
            self.apiCall(stylistId: "")
            labelBarber.text = NSLocalizedString("All Barbers Earnings", comment: "All Barbers Earnings")
        } else {
            labelBarber.text = "\(obj?.name ?? "") \(NSLocalizedString("Earnings", comment: "Earnings"))"
            selectedIndexId = obj?.id ?? 0
            self.apiCall(stylistId: "\(selectedIndexId)")
        }
        saloonCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ) - 25, height: collectionView.frame.size.height)
    }
}
