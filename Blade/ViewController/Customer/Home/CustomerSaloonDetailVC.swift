//
//  CustomerSaloonDetailVC.swift
//  Blade
//
//  Created by cqlsys on 11/10/22.
//

import UIKit
import CarbonKit

class CustomerSaloonDetailVC: UIViewController {
    
    @IBOutlet weak var btnBook: CustomButton!
    @IBOutlet weak var btnBookConstarnt: NSLayoutConstraint!
    @IBOutlet weak var imageSaloon: UIImageView!
    @IBOutlet weak var tabVC: UIView!
    var sallonId: String = ""
    var objModle: SaloonDetailModel?
    var type: CustomerSaloonDetailType = .sallon
    
    fileprivate var serviceSelectedId: String = ""
    fileprivate var labelService: String = ""
    fileprivate var priceDouble: String = ""
    fileprivate var totalServiceTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserPreference.shared.data?.role ?? 0 == 3 {
            btnBook.isHidden = true
            btnBookConstarnt.constant = 0
            self.setUpdata()
        } else if UserPreference.shared.data?.role ?? 0 == 2 {
            btnBook.isHidden = true
            btnBookConstarnt.constant = 0
            self.setUpdata()
        } else {
            self.apiCall()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func apiCall() {
        if type == .sallon {
            SignupEP.getSalonDetail(salonId: sallonId).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SaloonDetailModel> else { return }
                    if data.code == 200 {
                        self.objModle = data.data
                        self.setUpdata()
                    }
                }
            } error: { error in
                
            }
        } else {
            SignupEP.getSalonStylistDetail(stylistId: sallonId).request(showSpinner: true) { response in
                if response != nil{
                    guard let data = response as? ObjectData<SaloonDetailModel> else { return }
                    if data.code == 200 {
                        self.objModle = data.data
                        self.setUpdata()
                    }
                }
            } error: { error in
                
            }
        }
        
    }
    
    func setUpdata() {
        var items = [NSLocalizedString("About", comment: "About"),
                     NSLocalizedString("Services", comment: "Services"),
                     NSLocalizedString("Barbers", comment: "Barbers"),
                     NSLocalizedString("Gallery", comment: "Gallery"),
                     NSLocalizedString("Reviews", comment: "Reviews")]
        if UserPreference.shared.data?.role == 3 {
            items = [NSLocalizedString("About", comment: "About"),
                     NSLocalizedString("Services", comment: "Services"),
                     NSLocalizedString("Gallery", comment: "Gallery"),
                     NSLocalizedString("Reviews", comment: "Reviews")]
        } else if type == .stylist {
            items = [NSLocalizedString("About", comment: "About"),
                     NSLocalizedString("Services", comment: "Services"),
                     NSLocalizedString("Gallery", comment: "Gallery"),
                     NSLocalizedString("Reviews", comment: "Reviews")]
        }
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: tabVC)
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = UIColor.black
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 3)
        
        if UserPreference.shared.data?.role != 3 && type != .stylist{
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(view.frame.width / 4, forSegmentAt: 4)
        }
        
     
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setNormalColor(UIColor.darkGray, font: UIFont(name: "HelveticaNeue-Medium", size: 14)!)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white,font: UIFont(name: "HelveticaNeue-Medium", size: 14)!)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.init(named: "Color_button"))
        carbonTabSwipeNavigation.reloadInputViews()
        
        if UserPreference.shared.data?.role ?? 0 == 2 || UserPreference.shared.data?.role ?? 0 == 3 {
            imageSaloon.sd_setImage(with: URL(string:  UserPreference.shared.data?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
        } else {
            imageSaloon.sd_setImage(with: URL(string:  objModle?.image ?? ""), placeholderImage: UIImage.init(named: "demo"), options: [], progress: { (val, a, s) in
                
            })
        }
        
    }
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBookAppointment(_ sender: UIButton) {
        let vw = self.storyboard?.instantiateViewController(withIdentifier: "BookSlotVC") as! BookSlotVC
        vw.serviceSelectedId = serviceSelectedId
        vw.serviceNameString = labelService
        vw.priceDouble = priceDouble
        vw.type = type
        vw.totalServiceTime = totalServiceTime
        vw.objModle = objModle
        self.navigationController?.pushViewController(vw, animated: true)
    }
    
}

extension CustomerSaloonDetailVC: CarbonTabSwipeNavigationDelegate{
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if UserPreference.shared.data?.role == 3 || type == .stylist {
            if index == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonAboutVC") as! SaloonAboutVC
                vc.objModle = objModle
                return vc
            } else if index == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonServiceVC") as! SaloonServiceVC
                if UserPreference.shared.data?.role == 1 {
                    vc.onBackWithPrice = { [weak self] (serviceName, serviceID, price, time) in
                        self?.serviceSelectedId = serviceID
                        self?.labelService = serviceName
                        self?.priceDouble = price
                        self?.totalServiceTime = time
                    }
                }
                vc.objModle = objModle
                return vc
            } else if index == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonGalleryVC") as! SaloonGalleryVC
                vc.objModle = objModle
                return vc
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonReviewVC") as! SaloonReviewVC
                vc.objModle = objModle
                return vc
            }
        } else {
            if index == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonAboutVC") as! SaloonAboutVC
                
                vc.objModle = objModle
                return vc
            } else if index == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonServiceVC") as! SaloonServiceVC
                if UserPreference.shared.data?.role == 1 {
                    vc.onBackWithPrice = { [weak self] (serviceName, serviceID, price, time) in
                        self?.serviceSelectedId = serviceID
                        self?.labelService = serviceName
                        self?.priceDouble = price
                        self?.totalServiceTime = time
                    }
                }
                vc.objModle = objModle
                return vc
            } else if index == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonStylistVC") as! SaloonStylistVC
                vc.objModle = objModle
                return vc
            } else if index == 3 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonGalleryVC") as! SaloonGalleryVC
                vc.objModle = objModle
                return vc
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaloonReviewVC") as! SaloonReviewVC
                vc.objModle = objModle
                return vc
            }
        }
        
    }
}

enum CustomerSaloonDetailType {
    case sallon
    case stylist
    case reschedule
    case normal
    case rescheduleManual
}
 
