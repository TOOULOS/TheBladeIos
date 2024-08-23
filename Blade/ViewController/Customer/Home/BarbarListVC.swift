//
//  BarbarListVC.swift
//  Blade
//
//  Created by cqlsys on 09/10/22.
//

import UIKit

class BarbarListVC: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    fileprivate var arraySaloon: [CustomerHomeTopRatedModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        SignupEP.nearbyStylists(latitude: UserPreference.shared.data?.latitude ?? "", longitude: UserPreference.shared.data?.longitude ?? "").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? ObjectData<[CustomerHomeTopRatedModel]> else { return }
                if data.code == 200{
                    self.arraySaloon = data.data ?? []
                    self.cv.reloadData()
                }
            }
        } error: { error in
            
        }

    }
    
    @IBAction func onClickLike(_ sender: UIButton) {
        SignupEP.addOrRemoveFavouriteSalonOrStylist(salonOrStylistId: "\(arraySaloon[sender.tag].id ?? 0)", isFav: arraySaloon[sender.tag].isFav == 1 ? "0" : "1").request(showSpinner: true) { response in
            if response != nil{
                guard let data = response as? DefaultModel else { return }
                if data.code == 200{
                   let val = self.arraySaloon[sender.tag].isFav == 1 ? 0 : 1
                    self.arraySaloon[sender.tag].isFav = val
                    self.cv.reloadData()
                }
            }
        } error: { error in
            
        }
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BarbarListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySaloon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
        cell.objTopRated = arraySaloon[indexPath.row]
        cell.btnLike.tag = indexPath.row
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ) - 33, height: 235)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
        vw.sallonId = "\(self.arraySaloon[indexPath.row].id ?? 0)"
        vw.type = .stylist
        self.navigationController?.pushViewController(vw, animated: true)
    }
}
