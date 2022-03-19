//
//  DetailViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/06.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var pageURLtextView: UITextView!
    @IBOutlet var memoTextView: UITextView!
    
    var alertController: UIAlertController!
  
    var item = Product()



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.shadowImage = UIImage()
        pageURLtextView.textContainer.lineFragmentPadding = CGFloat(0.0)
        pageURLtextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pageURLtextView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageFileName = item.imageFileName
        let imageData = loadImageFromDocumentDirectory(fileName: imageFileName)
        imageView.image = imageData
        nameLabel.text = item.name
        priceLabel.text = String(item.price) + "円"
        pageURLtextView.text = item.pageURL
        memoTextView.text = item.memo
        
        let text: String = item.pageURL
        let attributedText = NSMutableAttributedString(string: text)
        let linkRange = (text as NSString).range(of: text)
        attributedText.addAttribute(.link, value: text, range: linkRange)
        pageURLtextView.attributedText = attributedText
        // リンクをタップ可能にする場合 isSelectableはデフォルトでtrue
        pageURLtextView.isEditable = false
    }
    

  
    

    
    //日付選択
    @IBOutlet var datePicker: UIDatePicker!
    
    func format(date:Date)->String{
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            let strDate = dateformatter.string(from: date)
            
            return strDate
        }
  
    //戻るボタン
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //買ったボタン
    @IBAction func bought(){
        // Realmをインスタンス化
        let realm = try! Realm()

        //入力値を取得
        let imageFileName: String = item.imageFileName
        let name: String = item.name
        let price: Int? = item.price
        let boughtDate: String = self.format(date: datePicker.date)

        //買ったProductクラスのインスタンスを作成し、取得したデータを格納
        let Bought_instance = Bought()
        Bought_instance.imageFileName = imageFileName
        Bought_instance.name = name
        Bought_instance.price = price!
        Bought_instance.date = boughtDate
    
        //格納されたデータをrealmに書き加える
        realm.beginWrite()
        realm.add(Bought_instance)
        try! realm.commitWrite()
        
        //データ削除
        try! realm.write {
            realm.delete(item)
        }
        dismiss(animated: true, completion: nil)
        
    }

    
    //削除ボタン
    @IBAction func delete(){
        let alert: UIAlertController = UIAlertController(title: "削除", message: "一度削除すると元に戻せないので注意してください。", preferredStyle: UIAlertController.Style.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.destructive, handler:{ (action: UIAlertAction!) -> Void in
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(self.item)
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) -> Void in
            
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
