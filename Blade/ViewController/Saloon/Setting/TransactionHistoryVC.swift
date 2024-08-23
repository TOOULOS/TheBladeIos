//
//  TransactionHistoryVC.swift
//  Blade
//
//  Created by cqlsys on 25/04/23.
//

import UIKit

class TransactionHistoryVC: UIViewController {

    fileprivate var arrTranscation: [TransactionBodyModel] = []
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        SignupEP.stripeBalanceTransactionsListing(limit: "1000", page: "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<TransactionModel> else { return }
                if data.code == 200{
                    self.arrTranscation = data.data?.stripeBalanceTransactions ?? []
                    self.tb.reloadData()
                }
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TransactionHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTranscation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let obj = self.arrTranscation[indexPath.row]
        
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: Double(obj.available_on ?? "0") ?? 0) ?? Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: date)
        
        if obj.calculatedBalance == "0.0" {
            cell.labelFirst.text = "\(NSLocalizedString("Amount", comment: "Amount")): €\(obj.net ?? "")"
        } else {
            cell.labelFirst.text = "\(NSLocalizedString("Amount", comment: "Amount")): €\(obj.calculatedBalance ?? "")"
        }
        
        if obj.status == "available" {
            cell.labelSecond.text =  NSLocalizedString("Status : Available", comment: "Status : Available")
            cell.labelSecond.textColor = UIColor.init(red: 31 / 255, green: 139 / 255, blue: 39 / 255, alpha: 1)
            cell.labelThird.text = "\(NSLocalizedString("Completed On", comment: "Completed On")): \(stringDate)"
        } else {
            cell.labelSecond.text =  NSLocalizedString("Status : Pending", comment: "Status : Pending")
            cell.labelSecond.textColor = UIColor.red
            cell.labelThird.text = "\(NSLocalizedString("Available On", comment: "Available On")): \(stringDate)"
        }
        return cell
    }
    
    
}
