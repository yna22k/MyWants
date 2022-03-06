//
//  AddViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/04.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var pageURLTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    
    
    // ドキュメントディレクトリの「ファイルURL」（URL型）定義
    var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    // ドキュメントディレクトリの「パス」（String型）定義
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //TexrFieldのデザイン
        nameTextField?.borderStyle = .none
        priceTextField?.borderStyle = .none
        pageURLTextField?.borderStyle = .none
        
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
    }
    
    
    //写真をアルバムから選択
    @IBAction func selectPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    //選択した画像を表示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func add(){
        // Realmをインスタンス化
        let realm = try! Realm()
    
        //入力値を取得
        let name: String = nameTextField.text!
        let price: Int? = Int(priceTextField.text!)
        let pageURL: String = pageURLTextField.text!
        let memo: String = memoTextView.text!
        
        //Productクラス（データの型）のインスタンスを作成し、取得したデータを格納
        let Product_instance = Product()
        Product_instance.name = name
        Product_instance.price = price!
        Product_instance.pageURL = pageURL
        Product_instance.memo = memo
    
        //格納されたデータをrealmに書き加える
        realm.beginWrite()
        realm.add(Product_instance)
        try! realm.commitWrite()
        
        //入力内容リセット
        nameTextField.text = ""
        priceTextField.text = ""
        pageURLTextField.text = ""
        memoTextView.text = ""
        
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
