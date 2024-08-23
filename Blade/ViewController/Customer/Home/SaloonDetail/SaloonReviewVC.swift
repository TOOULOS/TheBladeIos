//
//  SaloonReviewVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit
import Cosmos

class SaloonReviewVC: UIViewController {
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var labelAvgRating: UILabel!
    @IBOutlet weak var reviewTB: UITableView!
    var objModle: SaloonDetailModel?
    @IBOutlet weak var labelCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserPreference.shared.data?.role ?? 0 == 2 || UserPreference.shared.data?.role ?? 0 == 3 {
            labelCount.text = "\(UserPreference.shared.data?.reviews?.count ?? 0) \(NSLocalizedString("customer rating", comment: "customer rating"))"
            viewRating.rating = Double(UserPreference.shared.data?.rating ?? "0") ?? 0
            labelAvgRating.text = UserPreference.shared.data?.rating ?? ""
        } else {
            labelCount.text = "\(objModle?.reviews?.count ?? 0) \(NSLocalizedString("customer rating", comment: "customer rating"))"
            viewRating.rating = Double(objModle?.rating ?? "0") ?? 0
            labelAvgRating.text = objModle?.rating ?? ""
        }
        
        // Do any additional setup after loading the view.
    }

}

extension SaloonReviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserPreference.shared.data?.role ?? 0 == 2 || UserPreference.shared.data?.role ?? 0 == 3 {
            return UserPreference.shared.data?.reviews?.count ?? 0
        } else {
            return objModle?.reviews?.count ?? 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaloonReviewCell", for: indexPath) as! SaloonReviewCell
        if UserPreference.shared.data?.role ?? 0 == 2 || UserPreference.shared.data?.role ?? 0 == 3 {
            cell.obj =  UserPreference.shared.data?.reviews?[indexPath.row]
        } else {
            cell.obj = objModle?.reviews?[indexPath.row]
        }
        return cell
    }
}
