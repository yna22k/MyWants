//
//  File.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/05.
//

import Foundation
import RealmSwift


class Product: Object{
    @objc dynamic var imageFileName: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var pageURL: String = ""
    @objc dynamic var memo: String = ""
}
