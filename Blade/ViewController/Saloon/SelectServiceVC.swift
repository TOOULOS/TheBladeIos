//
//  SelectServiceVC.swift
//  Blade
//
//  Created by cqlsys on 20/11/22.
//

import UIKit

class SelectServiceVC: UIViewController {
    var obj: SaloonStylistDetailModel?
    @IBOutlet weak var serviceTB: UITableView!
    var idS: [Int] = []
    var serviceName: [String] = []
    var onBack: ((String, String) -> Void)?
    var onBackEdit: ((String, String, String) -> Void)?
    var onBackWithPrice: ((String, String, String, Int) -> Void)?
    var serviceArray: [SaloonStylistServiceModel] = []
    var type: SelectServiceType = .stylist
    var totalPrice: Double = 0
    var totalTime: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .stylist || type == .editStylist{
            if obj != nil {
                for i in obj?.salonServices ?? [] {
                    idS.append(i.id ?? 0)
                    serviceName.append(i.serviceName ?? "")
                }
                self.serviceTB.reloadData()
            }
        }

        
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickSelect(_ sender: UIButton) {
        if idS.count == 0 {
            Toast.shared.showAlert(type: .validationFailure, message: NSLocalizedString("Please select any service", comment: "Please select any service"))
        } else {
            let str = idS.map { String($0)}.joined(separator: ",")
            if type == .editStylist {
                let obj = UserPreference.shared.data?.salonServices ?? []
                var removeIds: [Int] = []
                for i in obj {
                    if !idS.contains(i.id ?? 0) {
                        removeIds.append(i.id ?? 0)
                    }
                }
                let strDelete = removeIds.map { String($0)}.joined(separator: ",")
                onBackEdit?(serviceName.joined(separator: ","), str, strDelete)
            } else if type == .stylist {
                onBack?(serviceName.joined(separator: ","), str)
            } else {
                onBackWithPrice?(serviceName.joined(separator: ","), str, "\(totalPrice ?? 0)", totalTime)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func onClickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectServiceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .stylist || type == .editStylist {
            return UserPreference.shared.data?.salonServices?.count ?? 0
        } else {
            return serviceArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectServiceCell", for: indexPath) as! SelectServiceCell
        var obj: SaloonStylistServiceModel?
        if type == .stylist || type == .editStylist{
            obj = UserPreference.shared.data?.salonServices?[indexPath.row]
        } else {
            obj = serviceArray[indexPath.row]
        }
     //   "\(NSLocalizedString("Service", comment: "Service")) (\(NSLocalizedString("Duration", comment: "Duration")): \(time) \(NSLocalizedString("Minutes", comment: "Minutes")))"
        
        cell.imageService.text = "\(obj?.serviceName ?? "")\n\(NSLocalizedString("Duration", comment: "Duration")): \(obj?.time ?? "") Price:- €\(obj?.price ?? "")"
        if idS.contains(obj?.id ?? 0) {
            cell.imageCheck.image = UIImage.init(systemName: "checkmark.square.fill")
        } else {
            cell.imageCheck.image = UIImage.init(systemName: "square")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj: SaloonStylistServiceModel?
        if type == .stylist || type == .editStylist{
            obj = UserPreference.shared.data?.salonServices?[indexPath.row]
        } else {
            obj = serviceArray[indexPath.row]
        }
        if idS.contains(obj?.id ?? 0) {
            idS.removeAll { val in
                val == obj?.id ?? 0
            }
            serviceName.removeAll { cal in
                cal == obj?.serviceName ?? ""
            }
            totalTime = totalTime - (Int(obj?.timeValue ?? "0") ?? 0)
            totalPrice = totalPrice - (Double(obj?.price ?? "") ?? 0)
        } else {
            idS.append(obj?.id ?? 0)
            totalPrice = totalPrice + (Double(obj?.price ?? "") ?? 0)
            totalTime = totalTime + (Int(obj?.timeValue ?? "0") ?? 0)
            serviceName.append((obj?.serviceName ?? ""))
        }
        serviceTB.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

enum SelectServiceType {
    case stylist
    case addBooking
    case editStylist
}
