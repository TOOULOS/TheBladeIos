//
//  CustomerHome.swift
//  Blade
//
//  Created by cqlsys on 09/10/22.
//

import UIKit
import GooglePlaces
import StoreKit

class CustomerHome: UIViewController {

    @IBOutlet weak var searchVW: UIView!
    @IBOutlet weak var searchTB: UITableView!
    @IBOutlet weak var topRatedBarberCV: UICollectionView!
    @IBOutlet weak var nearbySallonCV: UICollectionView!
    @IBOutlet weak var imageProfile: RoundImage!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var textFieldSearch: UITextField!
    fileprivate var lat: String = ""
    fileprivate var lng: String = ""
    fileprivate var arrayNearBySallon: [CustomerHomeNearByModel] = []
    fileprivate var arrayTopRatedSallon: [CustomerHomeTopRatedModel] = []
    var timer : Timer!
    var apiCall: Bool = false
    
    fileprivate var searchArray: [SearchModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if objLocationData.currentLat == nil {
                self.lat = UserPreference.shared.data?.latitude ?? ""
                self.lng = UserPreference.shared.data?.longitude ?? ""
                self.labelAddress.text = UserPreference.shared.data?.location ?? ""
            } else {
                self.lat = "\(objLocationData.currentLat ?? 0)"
                self.lng = "\(objLocationData.currentLong ?? 0)"
                self.labelAddress.text = objLocationData.location ?? ""
            }
            self.apiCall = true
            self.setUpData()
        }

        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if  needsUpdate() == true {
            Utilities.sharedInstance.showAlertViewWithAction("", "A new version of Blade App is a available on App Store. Please update the app to use latest version with new features.", self) {
                guard let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6445888988") else {
                    return
                }
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)

                } else {
                    UIApplication.shared.openURL(url)
                }
            }

        }
    }

    func needsUpdate() -> Bool {
        var regionCode = ""
        if #available(iOS 16, *) {
            regionCode = Locale.current.region?.identifier ?? ""
        } else {
            regionCode = "IN"
            // Fallback on earlier versions
        }
        let infoDictionary = Bundle.main.infoDictionary
        let appID = infoDictionary!["CFBundleIdentifier"] as! String
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(appID)&country=\(regionCode ?? "")")!
        guard let data = try? Data(contentsOf: url) else {
          print("There is an error!")
          return false;
        }
        let lookup = (try? JSONSerialization.jsonObject(with: data , options: [])) as? [String: Any]
        if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
            if let results = lookup!["results"] as? [[String:Any]] {
                if let appStoreVersion = results[0]["version"] as? String{
                    let currentVersion = infoDictionary!["CFBundleShortVersionString"] as? String
                    if !(appStoreVersion == currentVersion) {
                    //    print("Need to update [\(appStoreVersion) != \(currentVersion)]")
                        return true
                    }
                }
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

            self.setUpData()


        SKStoreReviewController.requestReview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if timer != nil{
            timer.invalidate()
        }
    }
    
    func setUpData() {
        labelName.text = "\(NSLocalizedString("Hi", comment: "Hi")) \(UserPreference.shared.data?.name ?? "")"
        imageProfile.sd_setImage(with: URL(string:  UserPreference.shared.data?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
            
        })
        if apiCall == true {
            self.homeApiCall()
        }
    }
    
    
    @IBAction func onClickSeeAllSalon(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "SaloonListVC") as! SaloonListVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickSeeAllBarber(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "BarbarListVC") as! BarbarListVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    func homeApiCall() {
        SignupEP.userHomeScreen(latitude: lat, longitude: lng).request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<CustomerHomeModel> else { return }
                if data.code == 200{
                    self.arrayNearBySallon = data.data?.nearBySalons ?? []
                    self.arrayTopRatedSallon = data.data?.topRatedBarbers ?? []
                    self.nearbySallonCV.reloadData()
                    self.topRatedBarberCV.reloadData()
                }
            }
        } error: { error in
            
        }

    }
    
    @IBAction func onClickTopRatedLike(_ sender: UIButton) {
        SignupEP.addOrRemoveFavouriteSalonOrStylist(salonOrStylistId: "\(arrayTopRatedSallon[sender.tag].id ?? 0)", isFav: arrayTopRatedSallon[sender.tag].isFav == 1 ? "0" : "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                   let val = self.arrayTopRatedSallon[sender.tag].isFav == 1 ? 0 : 1
                    self.arrayTopRatedSallon[sender.tag].isFav = val
                    self.topRatedBarberCV.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    @IBAction func onClickBtnLike(_ sender: UIButton) {
        SignupEP.addOrRemoveFavouriteSalonOrStylist(salonOrStylistId: "\(arrayNearBySallon[sender.tag].id ?? 0)", isFav: arrayNearBySallon[sender.tag].isFav == 1 ? "0" : "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                   let val = self.arrayNearBySallon[sender.tag].isFav == 1 ? 0 : 1
                    self.arrayNearBySallon[sender.tag].isFav = val
                    self.nearbySallonCV.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    @IBAction func onClickEditProfile(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickAddress(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        if #available(iOS 13.0, *) {
            autocompleteController.tableCellBackgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        self.present(autocompleteController, animated: true, completion: nil)
    }
}

extension CustomerHome: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    labelAddress.text = place.name
      lat = "\(place.coordinate.latitude ?? 0)"
      lng = "\(place.coordinate.longitude ?? 0)"
      self.homeApiCall()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

extension CustomerHome: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topRatedBarberCV {
            return arrayTopRatedSallon.count
        } else {
            return arrayNearBySallon.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topRatedBarberCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
            cell.objTopRated = arrayTopRatedSallon[indexPath.row]
            cell.btnLike.tag = indexPath.row
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell", for: indexPath) as! SaloonCell
            cell.objSallon = arrayNearBySallon[indexPath.row]
            cell.btnLike.tag = indexPath.row
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topRatedBarberCV {
            return CGSize(width: 200, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: 228, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
        if collectionView == topRatedBarberCV {
            vw.type = .stylist
            vw.sallonId = "\(arrayTopRatedSallon[indexPath.row].id ?? 0)"
        } else {

            vw.sallonId = "\(arrayNearBySallon[indexPath.row].id ?? 0)"
        }
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    
}

extension CustomerHome : UITextFieldDelegate{
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if string == "\n"{
                self.view.endEditing(true)
                return false
            }
             timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.output), userInfo: updatedText, repeats: false)
            
        }
         return true
    }
    
    @objc func output(){
        print("hello")
        if timer != nil{
            timer.invalidate()
        }
        if textFieldSearch.text! == ""{
            self.searchVW.isHidden = true
            //            self.homeListSuggestionArray = []
            //            suggestVw.isHidden = true
            //            suggestVw.reloadData()
        }else{
            SignupEP.searchNearbySalonsAndStylists(latitude: lat, longitude: lng, keyword: textFieldSearch.text!).request(showSpinner: false) { response in
                if response != nil{
                    guard let data = response as? ObjectData<[SearchModel]> else { return }
                    if data.code == 200{
                        self.searchArray = data.data ?? []
                        if self.searchArray.count == 0 {
                            self.searchVW.isHidden = true
                        } else {
                            if self.textFieldSearch.text! == "" {
                                self.searchVW.isHidden = true
                            } else {
                                self.searchVW.isHidden = false
                            }
                            
                        }
                        self.searchTB.reloadData()
                    }
                }
            } error: { error in
                
            }
        }
    }
}

extension CustomerHome: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.labelTitle.text = self.searchArray[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textFieldSearch.text = ""
        searchVW.isHidden = true
        textFieldSearch.endEditing(true)
        
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
        if self.searchArray[indexPath.row].role == 3 {
            vw.type = .stylist
            vw.sallonId = "\(self.searchArray[indexPath.row].id ?? 0)"
        } else {

            vw.sallonId = "\(self.searchArray[indexPath.row].id ?? 0)"
        }
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
}
