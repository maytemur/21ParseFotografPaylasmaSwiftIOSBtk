//
//  AyarlarViewController.swift
//  21ParseFotografPaylasma
//
//  Created by maytemur on 18.02.2023.
//

import UIKit
import Parse

class AyarlarViewController: UIViewController {

    @IBOutlet weak var sesControl: UISegmentedControl!
    
    @IBOutlet weak var darkMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitYap(_ sender: Any) {
        
        PFUser.logOutInBackground { (hata) in
            if hata != nil {
                
                let alert = UIAlertController(title: "Hata", message: hata?.localizedDescription ?? "Hata", preferredStyle: .alert)
                
                let okButon = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                
                alert.addAction(okButon)
                self.present(alert, animated: true,completion: nil)
            } else {
                
                //bu else i yazmadan önce toGirisController identifier olarak verdim bir perform show segue yapıyoruz,ana ekran view controller'a,bu view controllerdan ana ekrana verdiğimiz segue yi present modally-full screen yapıyoruz
                
                self.performSegue(withIdentifier: "toGirisController", sender: nil)
            }
        }
        
    }
    
    //burada ilgili ayarlar yapılabilir açılışta da önce default değerler sonra ayarlanmış olanlar yüklenebilir
    
    func UserDefKaydet(deger : String, anahtar : String){ //value : Any de olabilirdi
        
        let kullaniciAyarlari = UserDefaults.standard
        kullaniciAyarlari.set(deger, forKey: anahtar)
        kullaniciAyarlari.synchronize() //synchronize demeden kaydedilmez
    }
    
    func UserDefYukle(anahtar : String)-> String{
        
        if let ayar = UserDefaults.standard.string(forKey: anahtar){
            return ayar
        }
        return ""
    }
    
    func UserDefSil(anahtar : String){
        //object kullandık çünkü ne döneceğini bilmiyoruz
        if UserDefaults.standard.object(forKey: anahtar) != nil {
            UserDefaults.standard.removeObject(forKey: anahtar)
            UserDefaults.standard.synchronize()
        }
    }
    //bu 3 fonksiyon yeterli olacaktır ve bunları her projemizde rahatlıkla kullanabiliriz dediğine göre ve hatta bu fonksiyonu code snippet olarak xcode'un belleğine ekleyebiliriz bunun için code bloğu 3 fonksiyonu komple seçtikten sonra sağ tıklayıp menüden Create Code Snippet diyoruz!
    //Code Snippet olarak KullaniciAyarlari ismini verdim
    

}
