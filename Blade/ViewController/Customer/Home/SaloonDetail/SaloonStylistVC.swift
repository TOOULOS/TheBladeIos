//
//  SaloonStylistVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit

class SaloonStylistVC: UIViewController {
    @IBOutlet weak var addStylistHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var btnAddStylist: CustomButton!
    var objModle: SaloonDetailModel?
    @IBOutlet weak var cv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserPreference.shared.data?.role ?? 0 == 2 {
            addStylistHeightConstrant.constant = 48
            btnAddStylist.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cv.reloadData()
    }

    @IBAction func onClickEdit(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "AddSaloonStylistVC") as! AddSaloonStylistVC
        vw.obj = UserPreference.shared.data?.salonStylists?[sender.tag]
        vw.type = .edit
        vw.index = sender.tag
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
    @IBAction func onClickAddStylist(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "AddSaloonStylistVC") as! AddSaloonStylistVC
        vw.type = .add
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
}

extension SaloonStylistVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserPreference.shared.data?.role ?? 0 == 2 {
            return UserPreference.shared.data?.salonStylists?.count ?? 0
        } else {
            return objModle!.salonStylists?.count ?? 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
        if UserPreference.shared.data?.role ?? 0 == 2 {
            let obj = UserPreference.shared.data?.salonStylists?[indexPath.row]
            cell.imageSaloon.sd_setImage(with: URL(string:  obj?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            cell.btnEdit.isHidden = false
            cell.btnEdit.tag = indexPath.row
            cell.labelName.text = obj?.name ?? ""
            cell.labelAddress.text = UserPreference.shared.data?.salonName ?? ""
            cell.labelTotalRating.text = obj?.rating ?? ""
        } else {
            let obj = objModle?.salonStylists?[indexPath.row]
            cell.imageSaloon.sd_setImage(with: URL(string:  obj?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
            cell.labelName.text = obj?.name ?? ""
            cell.labelAddress.text = objModle?.salonName ?? ""
            cell.labelTotalRating.text = obj?.rating ?? ""
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserPreference.shared.data?.role ?? 0 == 1 {
            let vw = self.storyboard?.instantiateViewController(withIdentifier: "CustomerSaloonDetailVC") as! CustomerSaloonDetailVC
            vw.type = .stylist
            //vw.objModle = objModle?.salonStylists[indexPath.row].id ?? 0
            vw.sallonId = "\(objModle?.salonStylists?[indexPath.row].id ?? 0)"
            
            self.navigationController?.pushViewController(vw, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ) - 25, height: 235)
    }
}
