//
//  FeedViewController.swift
//  21ParseFotografPaylasma
//
//  Created by maytemur on 13.02.2023.
//

import UIKit
import Parse

class FeedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postDizisi = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verileriAl()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name(rawValue: "yeniPost" ), object: nil)
    }
    
    @objc func verileriAl(){
        
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (objeler, hatalar) in
            if hatalar != nil {
                self.hataMesaji(title: "Hata", message: hatalar?.localizedDescription ?? "Hata")
                
            } else{
                if objeler != nil {
                    if objeler!.count > 0 {
                        
                        self.postDizisi.removeAll(keepingCapacity: false)
                        
                        for obje in objeler! {
                            
                            if let kullaniciAdi = obje.object(forKey: "postsahibi") as? String {
                                
                                if let kullaniciYorum = obje.object(forKey: "postyorum") as? String {
                                    if let kullaniciGorsel = obje.object(forKey: "postgorsel") as? PFFileObject {
                                        
                                        let post = Post(kullaniciAdi: kullaniciAdi, kullaniciYorumu: kullaniciYorum, kullaniciGorsel: kullaniciGorsel)
                                        
                                        self.postDizisi.append(post)
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        //for loop bittiği gibi henüz resimleri almadık ama en azından kullanıcı ismi ve yorumu aldık onları gösteriyor mu diye test edelim ve Table View seçili iken sağ menüden selection kısmını no selection yapıyoruzki tablo seçilemesin
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
        }
    }
    
    func hataMesaji (title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButon = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okButon)
        self.present(alert,animated: true,completion: nil)
    }    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let satir = tableView.dequeueReusableCell(withIdentifier: "Satir", for: indexPath) as! FeedTableViewCell
        satir.kullaniciAdiLbl.text = postDizisi[indexPath.row].kullaniciAdi
        satir.commentLbl.text = postDizisi[indexPath.row].kullaniciYorumu
//        satir.feedImage.image =
        
        postDizisi[indexPath.row].kullaniciGorsel.getDataInBackground { (veri, hata) in
            if hata == nil {
                if let veri = veri {
                satir.feedImage.image = UIImage(data: veri)
                }
            }
                 
        }
        return satir
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
        return postDizisi.count
    }
    
    //burada Firebase de olduğu gibi verileri çekerken bir model oluşturuyoruz işimiz kolay olsun diye MVVC ye uygun olarak yoksa 3 alınacak veri için post sahibi, yorumu resmi olarak 3 ayrı dizide de tutabilirdik dedi
    


}
