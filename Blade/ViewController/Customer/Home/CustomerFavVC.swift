//
//  CustomerFavVC.swift
//  Blade
//
//  Created by cqlsys on 09/10/22.
//

import UIKit

class CustomerFavVC: UIViewController {

    @IBOutlet weak var favCV: UICollectionView!
    @IBOutlet weak var viewStylist: UIView!
    @IBOutlet weak var viewSaloon: UIView!
    @IBOutlet weak var btnStylist: UIButton!
    @IBOutlet weak var btnSalon: UIButton!
    fileprivate var arraySaloon: [CustomerHomeNearByModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if viewSaloon.isHidden == true {
            self.apiCall(type: "2")
        } else {
            self.apiCall(type: "1")
        }
    }
    
    func apiCall(type: String) {
        SignupEP.favouriteSalonOrStylistListing(type: type).request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[CustomerHomeNearByModel]> else { return }
                if data.code == 200{
                    self.arraySaloon = data.data ?? []
                    self.favCV.reloadData()
                }
            }
        } error: { error in
            
        }

    }
    
    @IBAction func onClickFav(_ sender: UIButton) {
        SignupEP.addOrRemoveFavouriteSalonOrStylist(salonOrStylistId: "\(arraySaloon[sender.tag].id ?? 0)", isFav: "0").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                    self.arraySaloon.remove(at: sender.tag)
                    self.favCV.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    
    
    @IBAction func onClickStylist(_ sender: UIButton) {
        btnStylist.alpha = 1
        btnSalon.alpha = 0.5
        viewStylist.isHidden = false
        viewSaloon.isHidden = true
        self.apiCall(type: "2")
    }
    
    @IBAction func onClickSaloon(_ sender: UIButton) {
        btnStylist.alpha = 0.5
        btnSalon.alpha = 1
        viewStylist.isHidden = true
        viewSaloon.isHidden = false
        self.apiCall(type: "1")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomerFavVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySaloon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var str = "SaloonCell1"
        if viewSaloon.isHidden == false {
            str = "SaloonCell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: str, for: indexPath) as! SaloonCell
        cell.objSallon = arraySaloon[indexPath.row]
        cell.btnLike.tag = indexPath.row
        if viewSaloon.isHidden == true {
            cell.labelAddress.text = arraySaloon[indexPath.row].salonName
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewSaloon.isHidden == true {
            return CGSize(width: (collectionView.frame.size.width / 2 ) - 33, height: 235)
        } else {
            return CGSize(width: collectionView.frame.size.width - 40 , height: 335)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewSaloon.isHidden == true {
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
            vw.sallonId = "\(self.arraySaloon[indexPath.row].id ?? 0)"
            vw.type = .stylist
            self.navigationController?.pushViewController(vw, animated: true)
        } else {
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
            vw.sallonId = "\(self.arraySaloon[indexPath.row].id ?? 0)"
            self.navigationController?.pushViewController(vw, animated: true)
        }
    }
}
