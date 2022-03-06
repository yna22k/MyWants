//
//  BoughtItem.swift
//  MyWants
//
//  Created by 金妍廷 on 2022/03/07.
//

import Foundation
import RealmSwift


class Bought: Object{
    @objc dynamic var imageURL: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price: Int = 0
}
