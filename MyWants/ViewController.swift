//
//  ViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/04.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var name: String!
    var price: Int!
    var pageURL: String!
    var memo: String!
    var product_list: [Product] = []
    var selectedItem = Product()


    
    @IBOutlet var collectionView: UICollectionView!
    
    
    //画面を読み込んだ時
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Cellのデザイン
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
           layout.minimumInteritemSpacing = 4
           layout.itemSize = CGSize(width:(self.collectionView.frame.size.width - 80)/2,height: (self.collectionView.frame.size.height-40)/3)
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        product_list = get_productList()
        collectionView.reloadData()
    }
    
    
        //realmに保存された配列を読み込む
        func get_productList() -> [Product]{
            let realm = try! Realm()
            return Array(realm.objects(Product.self))
        }
    
        //collectionViewの設定
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return product_list.count // 表示するセルの数
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  // 表示するセルを登録(先程命名した"Cell")
            let name = cell.contentView.viewWithTag(1) as! UILabel
            let price = cell.contentView.viewWithTag(2) as! UILabel
            
            name.text = product_list[indexPath.row].name
            price.text = String(product_list[indexPath.row].price) + "円"
            return cell
        }
    
    
        // Cell が選択された場合
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedItem = product_list[indexPath.row]
            performSegue(withIdentifier: "toDetail",sender: nil)
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
            if (segue.identifier == "toDetail") {
                let DetailVC: DetailViewController = (segue.destination as? DetailViewController)!
                DetailVC.item = selectedItem
            }
        }
    
    

    
}

