//
//  AddViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/04.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var pageURLTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameTextField?.borderStyle = .none
        priceTextField?.borderStyle = .none
        pageURLTextField?.borderStyle = .none
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
