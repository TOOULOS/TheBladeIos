//
//  SaloonNotificationVC.swift
//  Blade
//
//  Created by cqlsys on 22/10/22.
//

import UIKit

class SaloonNotificationVC: UIViewController {
    
    @IBOutlet weak var notificationTB: UITableView!
    fileprivate var notifyArray: [NotificationModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCall()
    }
    
    func apiCall() {
        SignupEP.notificationListing.request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[NotificationModel]> else { return }
                if data.code == 200{
                    self.notifyArray = data.data ?? []
                    self.notificationTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
}

extension SaloonNotificationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifyArray.count == 0 {

            tableView.setEmptyMessage(NSLocalizedString("No notifications are available currently for you.", comment: "No notifications are available currently for you."))
        } else {
            tableView.restore()
        }
        return notifyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.objNotify = notifyArray[indexPath.row]
        return cell
    }
}
