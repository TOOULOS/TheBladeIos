//
//  MyReviewVC.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import UIKit

class MyReviewVC: UIViewController {

    @IBOutlet weak var reviewTB: UITableView!
    @IBOutlet weak var labelName: UILabel!
    fileprivate var reviewArray: [ReviewModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.text = UserPreference.shared.data?.name ?? ""
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        SignupEP.givenReviewsListing.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[ReviewModel]> else { return }
                if data.code == 200{
                    self.reviewArray = data.data ?? []
                    self.reviewTB.reloadData()
                }
            }
        } error: { errro in
            
        }

    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyReviewVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell", for: indexPath) as! MyReviewCell
        cell.objReview = reviewArray[indexPath.row]
        return cell
    }
}
