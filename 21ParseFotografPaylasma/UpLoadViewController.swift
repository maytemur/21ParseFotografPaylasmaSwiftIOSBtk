//
//  FeedViewController.swift
//  21ParseFotografPaylasma
//
//  Created by maytemur on 13.02.2023.
//

import UIKit
import Parse

class UpLoadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var gorselResim: UIImageView!
    
    @IBOutlet weak var yorumText: UITextField!
    
    //normalde buton'un aoutlet'ini oluşturmuyorduk burada butonu disable edicez o yüzden ekledik
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiSakla))
        
        view.addGestureRecognizer(keyboardRecognizer)
        
        gorselResim.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(gorselSec))
        
        //addGestureRecognizer olmadan resim tıklanabilir olmuyor
        gorselResim.addGestureRecognizer(gestureRecognizer)
        
        shareButton.isEnabled = false
        
    }
    
    @objc func gorselSec(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        gorselResim.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        shareButton.isEnabled = true
    }
    

    @IBAction func shareClicked(_ sender: Any) {
        //adam 1-2 kere sürekli tıklamasın diye disabled edelim
        shareButton.isEnabled = false
        
        let post = PFObject(className: "Post")
       
        
        //şunu daha önce görmüştük
        let data = gorselResim.image?.jpegData(compressionQuality: 0.5)
        // bu bize veriyi veriyor ama parse da çalışmak için PFFile diye bir object var
        if let data = data {
            if PFUser.current() != nil {
            let parseImage = PFFileObject(name: "resim.jpeg", data: data)
                
                post["postgorsel"] = parseImage
                post["postyorum"] = yorumText.text!
                post["postsahibi"] = PFUser.current()!.username! //istenirse nil kontrolü yapılabilir ama zaten adam buraya geldiyse geçerli bir kullanıcı vardır dedi sonra bunların hepsini nil kontrollü if let içine aldı :)
                
                
                post.saveInBackground { basarili, hata in
                    if hata != nil {
                        let alert = UIAlertController(title: "Hata", message: hata?.localizedDescription ?? "Hata", preferredStyle: .alert)
                        let okbuton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        
                        alert.addAction(okbuton)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        //eğer hata yoksa basarili isek yüklendi ise
                        self.yorumText.text = ""
                        self.gorselResim.image = UIImage(named: "gorselsec")
                        self.tabBarController?.selectedIndex = 0
                        
                        //bu notification center 'ı daha önce kullanmışız ,uygulama içinde haber yollama olanağı veriyor bunu gözlemleyebiliyor ve yeni post varsa diğer uygulama içinde onu çekebiliyoruz dedi
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "yeniPost"), object: nil)
                    }
                }
            
        }
    }
        
    }
    
    @objc func klavyeyiSakla(){
        view.endEditing(true)
        //klavye ile iş bitince saklanacak ve paylaş butonu klavye altında kalan küçük telefonlarda da paylaş butonu görülebilecek
    }
    
}
