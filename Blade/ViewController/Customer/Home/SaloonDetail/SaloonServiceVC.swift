//
//  SaloonServiceVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit

class SaloonServiceVC: UIViewController {
    @IBOutlet weak var buttonAddServiceHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var btnAddService: UIButton!
    @IBOutlet weak var btnMen: UIButton!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnBoth: UIButton!
    @IBOutlet weak var serviceTB: UITableView!
    var objModle: SaloonDetailModel?
    fileprivate var arraySaollon : [SaloonStylistServiceModel] = []
    
    var onBackWithPrice: ((String, String, String, Int) -> Void)?
    var idS: [Int] = []
    var serviceName: [String] = []
    var totalPrice: Double = 0
    var totalTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onClickBoth(btnBoth)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.serviceTB.reloadData()
        if UserPreference.shared.data?.role ?? 0 == 2{
            btnBoth.isHidden = true
            btnWomen.isHidden = true
            btnMen.isHidden = true
            arraySaollon = UserPreference.shared.data?.salonServices ?? []
            buttonAddServiceHeightConstaint.constant = 48
            btnAddService.isHidden = false
        } else if UserPreference.shared.data?.role == 3 {
            btnBoth.isHidden = true
            btnWomen.isHidden = true
            btnMen.isHidden = true
            let objArray = UserPreference.shared.data?.salonServices ?? []
            arraySaollon = objArray.filter { val in
                val.status == 1
            }
        } else {
            arraySaollon = objModle?.salonServices ?? []

        }
    }
    
    @IBAction func onClickBoth(_ sender: UIButton) {
        btnBoth.isSelected = true
        btnMen.isSelected = false
        btnWomen.isSelected = false
        
        
        btnBoth.isHidden = true
        btnWomen.isHidden = true
        btnMen.isHidden = true
        
        if UserPreference.shared.data?.role ?? 0 == 2 {
            btnBoth.isHidden = true
            btnWomen.isHidden = true
            btnMen.isHidden = true
            arraySaollon = UserPreference.shared.data?.salonServices ?? []
            buttonAddServiceHeightConstaint.constant = 48
            btnAddService.isHidden = false
        } else {
//            arraySaollon = objModle?.salonServices!.filter({ val in
//                val.serviceType == 3
//            }) ?? []
        }
        
        serviceTB.reloadData()
    }
    
    @IBAction func onClickMen(_ sender: UIButton) {
        btnBoth.isSelected = false
        btnMen.isSelected = true
        btnWomen.isSelected = false
        arraySaollon = objModle?.salonServices!.filter({ val in
            val.serviceType == 1
        }) ?? []
        serviceTB.reloadData()
    }
    
    @IBAction func onClickWomen(_ sender: UIButton) {
        btnBoth.isSelected = false
        btnMen.isSelected = false
        btnWomen.isSelected = true
        arraySaollon = objModle?.salonServices!.filter({ val in
            val.serviceType == 2
        }) ?? []
        serviceTB.reloadData()
    }
    
    @IBAction func onClickAddService(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "AddSaloonServiceVC") as! AddSaloonServiceVC
        vw.type = .add
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "AddSaloonServiceVC") as! AddSaloonServiceVC
        vw.type = .edit
        vw.index = sender.tag
        vw.objService = arraySaollon[sender.tag]
        self.navigationController?.pushViewController(vw, animated: true)
    }
}

extension SaloonServiceVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySaollon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaloonServiceCell", for: indexPath) as! SaloonServiceCell
        cell.obj = arraySaollon[indexPath.row]
        if UserPreference.shared.data?.role ?? 0 == 2 {
            cell.btnWidthConstraint.constant = 0
            cell.btnHeightConstraint.constant = 0
            cell.btnEdit.isHidden = false
            cell.btnEdit.tag = indexPath.row
        }
        let obj = arraySaollon[indexPath.row]
        if UserPreference.shared.data?.role ?? 0 == 1 {
            if idS.contains(obj.id ?? 0) {
                cell.btnSelect.isSelected = true
            } else {
                cell.btnSelect.isSelected = false
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserPreference.shared.data?.role ?? 0 == 1 {
            let obj = arraySaollon[indexPath.row]
            if idS.contains(obj.id ?? 0) {
                idS.removeAll { val in
                    val == obj.id ?? 0
                }
                serviceName.removeAll { cal in
                    cal == obj.serviceName ?? ""
                }
                totalTime = totalTime - (Int(obj.timeValue ?? "0") ?? 0)
                totalPrice = totalPrice - (Double(obj.price ?? "") ?? 0)
            } else {
                idS.append(obj.id ?? 0)
                totalPrice = totalPrice + (Double(obj.price ?? "") ?? 0)
                totalTime = totalTime + (Int(obj.timeValue ?? "0") ?? 0)
                serviceName.append((obj.serviceName ?? ""))
            }
            
            let str = idS.map { String($0)}.joined(separator: ",")
            onBackWithPrice?(serviceName.joined(separator: ","), str, "\(totalPrice ?? 0)", totalTime)
            tableView.reloadData()
        }
    }
}
