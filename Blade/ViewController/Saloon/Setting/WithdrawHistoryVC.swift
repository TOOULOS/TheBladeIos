//
//  WithdrawHistoryVC.swift
//  Blade
//
//  Created by cqlsys on 28/04/23.
//

import UIKit

class WithdrawHistoryVC: UIViewController {
    
    fileprivate var arrTranscation: [TransfersBodyModel] = []
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        SignupEP.stripeBalanceTransfersListing(limit: "1000", page: "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<TransfersModel> else { return }
                if data.code == 200{
                    self.arrTranscation = data.data?.stripeBalanceTransfers ?? []
                    self.tb.reloadData()
                }
            }
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension WithdrawHistoryVC: UITableViewDelegate, UITableViewDataSource {
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
        let date = Date(timeIntervalSince1970: Double(obj.created ?? "0") ?? 0) ?? Date()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let stringDate = dateFormatter.string(from: date)
        
        cell.labelFirst.text = "\(NSLocalizedString("Amount", comment: "Amount")): €\(obj.amount ?? "")"

        cell.labelThird.text = "\(NSLocalizedString("Withdraw Created on", comment: "Withdraw Created on")): \(stringDate)"
        return cell
    }
    
    
}
