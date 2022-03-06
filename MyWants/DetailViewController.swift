//
//  DetailViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/06.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var pageURLLabel: UILabel!
    @IBOutlet var memoTextView: UITextView!
  
    var item = Product()



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIImage()
//        name.text = selectedItem.name
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = item.name
        priceLabel.text = String(item.price) + "円"
        pageURLLabel.text = item.pageURL
        memoTextView.text = item.memo
        

    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bought(){
        // Realmをインスタンス化
        let realm = try! Realm()
    
        //入力値を取得
        let name: String = item.name
        let price: Int? = item.price

        //Productクラス（データの型）のインスタンスを作成し、取得したデータを格納
        let Bought_instance = Bought()
        Bought_instance.name = name
        Bought_instance.price = price!
    
        //格納されたデータをrealmに書き加える
        realm.beginWrite()
        realm.add(Bought_instance)
        try! realm.commitWrite()
        
        //データ削除
        dismiss(animated: true, completion: nil)
        
    }

    
    
   
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
