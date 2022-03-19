//
//  BoughtViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/07.
//

import UIKit
import RealmSwift

class BoughtViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var boughtItem_list: [Bought] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        table.dataSource = self
//        table.rowHeight = 160
//        table.backgroundView = nil
        table.delegate = self
        table.separatorStyle = .none
        
        
    
        
    
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        boughtItem_list = get_boughtList()
//        let realm = try! Realm()
//        try! realm.write {
//            realm.delete(boughtItem_list)
//        }
        table.reloadData()
        
    }
    
        //realmに保存された配列を読み込む
        func get_boughtList() -> [Bought]{
            let realm = try! Realm()
            return Array(realm.objects(Bought.self))
        }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boughtItem_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let name = cell?.viewWithTag(1) as! UILabel
        let price = cell?.viewWithTag(2) as! UILabel
        let date = cell?.viewWithTag(3) as! UILabel
        let image = cell?.contentView.viewWithTag(4) as! UIImageView
        
        cell!.backgroundColor = UIColor.clear

        //画像
        let imageFileName = boughtItem_list[indexPath.row].imageFileName
        let imageData = loadImageFromDocumentDirectory(fileName: imageFileName)
        image.image = imageData
        
        name.text = boughtItem_list[indexPath.row].name
        price.text = String(boughtItem_list[indexPath.row].price) + "円"
        date.text = boughtItem_list[indexPath.row].date
        
        cell!.layer.cornerRadius = 10
        
        return cell!
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
