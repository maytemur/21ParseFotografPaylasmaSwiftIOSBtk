//
//  ViewController.swift
//  21ParseFotografPaylasma
//
//  Created by maytemur on 9.02.2023.
//

import UIKit
import Parse


class ViewController: UIViewController {
    @IBOutlet weak var txtAd: UITextField!
    
    @IBOutlet weak var txtSifre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //testParseConnection()
    }
    func testParseConnection(){
        //        let myObj = PFObject(className:"FirstClass")
        //veri kaydederkej PFObject kullanıyoruz çekerkende PFQuery kullanıyoruz
        
        //        myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
        //        myObj.saveInBackground { (success, error) in
        //            if(success){
        //                print("You are connected!")
        //            }else{
        //                print("An error has occurred!")
        //            }
        //        }
        
        //        let myHaber = PFObject(className:"Haberler")
        //        //veri kaydederkej PFObject kullanıyoruz çekerkende PFQuery kullanıyoruz
        //
        //        myHaber["baslik"] = "1nci gelen haber başlığı"
        //        myHaber["resim"] = "1nci gelen haber resim url'si veya binary kendisi"
        //        myHaber["detay"] = "1nci gelen haber detay bilgisi"
        //
        //        myHaber.saveInBackground { (success, error) in
        //            if(success){
        //                print("You are OK!")
        //            }else{
        //                print("An error has occurred!")
        //            }
        //        }
        //Query örneği
        let query = PFQuery(className: "Haberler")
        query.whereKey("baslik", contains: "2nci") //içinde 2nci geçen kayıtlar gelecek
        query.findObjectsInBackground { gelenler, hata in  //optinal obje listesi geliyor [PFObject]? şeklinde sonuçta içinde hiçbir şeyde olmayabilir
            if hata != nil {
                print(hata?.localizedDescription)
            } else {
                print(gelenler)
            }
        }
    }
    
    @IBAction func girisYapClicked(_ sender: Any) {
        //        performSegue(withIdentifier: "toTabBar", sender: nil)
        if txtAd.text != "" && txtSifre.text != "" {
            
            PFUser.logInWithUsername(inBackground: txtAd.text!, password: txtSifre.text!) { (kullanici,hata) in
                if hata != nil {
                    self.hataMesajiGoster(title: "Hata !", message: hata?.localizedDescription ?? "Hata")
                    
                    
                }else {
                    
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else {
            self.hataMesajiGoster(title: "Hata", message: "Kullanıcı adı ve parola girmelisiniz")
        }
        
    }
    
    @IBAction func kayitOlClicked(_ sender: Any) {
        
        if txtAd.text != "" && txtSifre.text != "" {
            let user = PFUser()
            user.username = txtAd.text! //firebase de mail ile yaptık burada da username ile yapalım dedi
            user.password = txtSifre.text!
            //kullanıcıyı oluşturalım
            user.signUpInBackground { basarili, basarisiz in
                if basarisiz != nil {
                    self.hataMesajiGoster(title: "Hata", message: basarisiz?.localizedDescription ?? "Hata")
                } else { // tamamdır arka planda asenkron olarak block code ile oluşturuyor hata yok!
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
            
        } else {
            hataMesajiGoster(title: "Hata", message: "Kullanıcı adı ve parola girmelisiniz")
        }
        
    }
    func hataMesajiGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //firebase de olduğu gibi kullanıcı girdikten sonra her defasında isim şifre sormasın bunu yine firebase de olduğu gibi scen delegate dosyası içinden yapacağız
    //ilk olarak ana tabbar'a storyboard ID veriyoruz
}

