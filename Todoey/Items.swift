//
//  Items.swift
//  Todoey
//
//  Created by Chhorn Vatana on 8/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCatagory = LinkingObjects(fromType: Catagories.self, property: "items")
}
