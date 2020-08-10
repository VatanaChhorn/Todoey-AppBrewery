//
//  Catagory.swift
//  Todoey
//
//  Created by Chhorn Vatana on 8/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Catagories: Object {
    @objc dynamic var name : String = ""
    let items = List<Items>() 
}
