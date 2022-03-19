//
//  AddViewController.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/04.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import PKHUD



class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var pageURLTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var textCountLabel: UILabel!
    
//    private let placeholder = "メモを入力（44文字以内）"
    let textLength = 72
    
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TexrFieldのデザイン
        nameTextField?.borderStyle = .none
        priceTextField?.borderStyle = .none
        priceTextField.keyboardType = UIKeyboardType.numberPad
        pageURLTextField?.borderStyle = .none
        
        memoTextView.delegate = self
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
    
    
    // 文字数制限＆行数制限
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //既に存在する改行数
        let existingLines = textView.text.components(separatedBy: .newlines)
        //新規改行数
        let newLines = text.components(separatedBy: .newlines)
        //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        let linesAfterChange = existingLines.count + newLines.count - 1
        return linesAfterChange <= 3 && memoTextView.text.count + (text.count - range.length) <= textLength
    }
    
    // TextViewの内容が変わるたびに実行される
        func textViewDidChange(_ textView: UITextView) {
            //既に存在する改行数
            let existingLines = textView.text.components(separatedBy: .newlines)
            if existingLines.count <= 3 {
                self.textCountLabel.text = "\(memoTextView.text.count) / \(textLength)"
                if memoTextView.text.count == textLength {
                    textCountLabel.textColor = .orange
                }else{
                    textCountLabel.textColor = .darkText
                }
            }
        }

    
    @IBAction func add(){
        // Realmをインスタンス化
        let realm = try! Realm()
    
        //入力値を取得
        let image = imageView.image
        let name: String = nameTextField.text!
        let price: Int = Int(priceTextField.text!) ?? 0
        let pageURL: String = pageURLTextField.text!
        let memo: String = memoTextView.text!
        
  
        let fileName: String! = "\(UUID())"
        
        if image != nil{
        saveImageInDocumentDirectory(image: image!, fileName: fileName)
        }

        //Productのインスタンスを作成し、取得したデータを格納
        let Product_instance = Product()
        Product_instance.imageFileName = fileName
        Product_instance.name = name
        Product_instance.price = price
        Product_instance.pageURL = pageURL
        Product_instance.memo = memo
    
        //格納されたデータをrealmに書き加える
        realm.beginWrite()
        realm.add(Product_instance)
        try? realm.commitWrite()
        
        //PKHUD
        HUD.flash(.success, delay: 1.0)
        
        //入力内容リセット
        imageView.image = nil
        nameTextField.text = ""
        priceTextField.text = ""
        pageURLTextField.text = ""
        memoTextView.text = ""
        self.textCountLabel.text = "0 / \(textLength)"

    }
    
    func saveImageInDocumentDirectory(image: UIImage, fileName: String)  {
          let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
          let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.pngData() {
              try? imageData.write(to: fileURL, options: .atomic)
            print(fileURL)
          }
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

