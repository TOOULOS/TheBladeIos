//
//  ChangeLanguageVC.swift
//  Blade
//
//  Created by cqlsys on 22/12/22.
//

import UIKit

class ChangeLanguageVC: UIViewController {
    var onSubmit: ((Int) -> (Void))?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickEnglish(_ sender: Any) {
        Bundle.setLanguage("en")
        L102Language.setAppleLAnguageTo(lang: "en")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("1", forKey: "CurrentLang")
        UserDefaults.standard.set("en", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func onClickDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickFrench(_ sender: UIButton) {
        Bundle.setLanguage("fr")
        L102Language.setAppleLAnguageTo(lang: "fr")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("2", forKey: "CurrentLang")
        UserDefaults.standard.set("fr", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickItalian(_ sender: Any) {
        let userdef = UserDefaults.standard
        userdef.set(["it"], forKey: APPLE_LANGUAGE_KEY)
        Bundle.setLanguage("it")
        L102Language.setAppleLAnguageTo(lang: "it")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("6", forKey: "CurrentLang")
        UserDefaults.standard.set("it", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickGreek(_ sender: Any) {
        Bundle.setLanguage("el")
        L102Language.setAppleLAnguageTo(lang: "el")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("4", forKey: "CurrentLang")
        UserDefaults.standard.set("el", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onClickGerman(_ sender: Any) {
        Bundle.setLanguage("de")
        L102Language.setAppleLAnguageTo(lang: "de")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("3", forKey: "CurrentLang")
        UserDefaults.standard.set("de", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func onClickRussian(_ sender: Any) {
        Bundle.setLanguage("ru")
        L102Language.setAppleLAnguageTo(lang: "ru")
        UIView.appearance().semanticContentAttribute    = .forceLeftToRight
        UINavigationBar.appearance().semanticContentAttribute   = .forceLeftToRight
        UserDefaults.standard.set("5", forKey: "CurrentLang")
        UserDefaults.standard.set("ru", forKey: "CurrentLang1")
        onSubmit?(1)
        self.dismiss(animated: false, completion: nil)
    }
}
