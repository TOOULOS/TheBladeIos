//
//  NotificationVC.swift
//  Blade
//
//  Created by cqlsys on 20/10/22.
//

import UIKit

class NotificationVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var notificationTB: UITableView!
    fileprivate var notifyArray: [NotificationModel] = []
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentPage = 1
        self.notifyArray.removeAll()
        self.apiCall()
    }
    
    
    func loadMoreItemsForList(){
        currentPage += 1
        self.apiCall()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    
    func apiCall() {
        SignupEP.notificationListingPagination(page: "\(currentPage)", limit: "10").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[NotificationModel]> else { return }
                if data.code == 200 {
                    if data.data?.count != 0 {
                        self.isLoadingList = false
                        self.notifyArray.append(contentsOf: data.data ?? [])
                    }
                    
                    
                    self.notificationTB.reloadData()
                }
            }
        } error: { error in
            
        }
    }
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
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
