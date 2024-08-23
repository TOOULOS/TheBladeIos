//
//  SaloonGalleryVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit
import ImageCropper
class SaloonGalleryVC: UIViewController, imageDelegate {
    func getImageData(data: Data, image: UIImage, tag: Int) {
        var config = ImageCropperConfiguration(with: image, and: .customRect)
        config.customRatio = CGSize(width: 1, height: 1)
        config.maskFillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.75)
        config.borderColor = UIColor.black

        config.showGrid = true
        config.gridColor = UIColor.white
        config.doneTitle = "CROP"
        config.cancelTitle = "Back"

        let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
            SignupEP.addSalonImage(salonImages: _croppedImage?.jpegData(compressionQuality: 1) ?? Data()).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SignupModel> else { return }
                    if data.code == 200{
                        UserPreference.shared.data = data.data
                        self.galleryTB.reloadData()
                    }
                }
            } error: { error in

            }

        }) {
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(cropper, animated: true)




    }
    
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!
    @IBOutlet weak var btnAddGallery: CustomButton!
    @IBOutlet weak var galleryTB: UITableView!
    var objModle: SaloonDetailModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryTB.reloadData()
        if UserPreference.shared.data?.role ?? 0 == 2 || ((UserPreference.shared.data?.role ?? 0) == 3 ){
            heightConstaint.constant = 48
            btnAddGallery.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickAddGallery(_ sender: UIButton) {
        Utilities.sharedInstance.delegate = self
        Utilities.sharedInstance.imagepickerController(view: self)
    }
    @IBAction func onClickDelete(_ sender: UIButton) {
        var arrayObj = UserPreference.shared.data?.salonImages ?? []
        var userObj = UserPreference.shared.data
        if (UserPreference.shared.data?.role ?? 0 == 3 ) {
            var arrayObj = UserPreference.shared.data?.stylistImages ?? []
            SignupEP.deleteStylistImages(stylistImageIds: "\(arrayObj[sender.tag].id ?? 0)").request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        arrayObj.remove(at: sender.tag)
                        userObj?.stylistImages = arrayObj
                        UserPreference.shared.data = userObj
                        self.galleryTB.reloadData()
                    }
                }
            } error: { error in
                
            }
        } else {
            var arrayObj = UserPreference.shared.data?.salonImages ?? []
            SignupEP.deleteSalonImages(salonImageIds: "\(arrayObj[sender.tag].id ?? 0)").request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? DefaultModel else { return }
                    if data.code == 200{
                        arrayObj.remove(at: sender.tag)
                        userObj?.salonImages = arrayObj
                        UserPreference.shared.data = userObj
                        self.galleryTB.reloadData()
                    }
                }
            } error: { error in
                
            }
        }
        

    }
}

extension SaloonGalleryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserPreference.shared.data?.role ?? 0 == 2{
            return UserPreference.shared.data?.salonImages?.count ?? 0
        } else if (UserPreference.shared.data?.role ?? 0 == 3 ) {
            return UserPreference.shared.data?.stylistImages?.count ?? 0
        }else {
            return objModle?.salonImages?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        if UserPreference.shared.data?.role ?? 0 == 2 || (UserPreference.shared.data?.role ?? 0 == 3 ){
            if (UserPreference.shared.data?.role ?? 0 == 3 ) {
                cell.imageGallery.sd_setImage(with: URL(string:  UserPreference.shared.data?.stylistImages?[indexPath.row].image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            } else {
                cell.imageGallery.sd_setImage(with: URL(string:  UserPreference.shared.data?.salonImages?[indexPath.row].image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                    
                })
            }
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.isHidden = false
        } else {
            cell.imageGallery.sd_setImage(with: URL(string:  objModle?.salonImages?[indexPath.row].image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.width)
    }
}
