//
//  SaloonStylistListVC.swift
//  Blade
//
//  Created by cqlsys on 23/10/22.
//

import UIKit

class SaloonStylistListVC: UIViewController {

    @IBOutlet weak var listCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEdit(_ sender: UIButton) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vw = story.instantiateViewController(withIdentifier: "AddSaloonStylistVC") as! AddSaloonStylistVC
        vw.obj = UserPreference.shared.data?.salonStylists?[sender.tag]
        vw.index = sender.tag
        vw.type = .edit
        self.navigationController?.pushViewController(vw, animated: true)
    }
}

extension SaloonStylistListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserPreference.shared.data?.salonStylists?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaloonCell1", for: indexPath) as! SaloonCell
        cell.btnEdit.tag = indexPath.row
        let obj = UserPreference.shared.data?.salonStylists?[indexPath.row]
        cell.imageSaloon.sd_setImage(with: URL(string:  obj?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
            
        })
       cell.labelName.text = obj?.name ?? ""
        cell.labelAddress.text = obj?.salonName ?? ""
        cell.labelTotalRating.text = obj?.rating ?? ""
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2 ) - 25, height: 235)
    }
}
