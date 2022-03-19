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

    var sum: Int!
    var price_list: [Int] = []

    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sumLavel: UILabel!
    
    
    //画面を読み込んだ時
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
        //Cellのデザイン
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
           layout.minimumInteritemSpacing = 4
           layout.itemSize = CGSize(width:(self.collectionView.frame.size.width - 80)/2,height: (self.collectionView.frame.size.height-40)/3)
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()}
        
//        sumPrice()
    

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        product_list = get_productList()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    
    
    func sumPrice(){
        product_list = get_productList()
        if product_list.count>0{
            price = product_list[product_list.count-1].price
            price_list.append(price)
        }
        print(price_list)
        sum = price_list.reduce(0, +)
        print(sum ?? 0)
        sumLavel.text = String(sum)+"円"
        
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
            let image = cell.contentView.viewWithTag(1) as! UIImageView
            let name = cell.contentView.viewWithTag(2) as! UILabel
            let price = cell.contentView.viewWithTag(3) as! UILabel
        
            
            //画像
            let imageFileName = product_list[indexPath.row].imageFileName
            let imageData = loadImageFromDocumentDirectory(fileName: imageFileName)
            image.image = imageData
    
            name.text = product_list[indexPath.row].name
            price.text = String(product_list[indexPath.row].price) + "円"
            
            return cell
        }
    
    
        // Cell が選択された時
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
    
    
    func saveImageInDocumentDirectory(image: UIImage, fileName: String)  {
          let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
          let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
              try? imageData.write(to: fileURL, options: .atomic)
          }
      }

    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {

          let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
          let fileURL = documentsUrl.appendingPathComponent(fileName)
          do {
              let imageData = try Data(contentsOf: fileURL)
              return UIImage(data: imageData)
          } catch {}
          return nil
      }
    
    

    
}

