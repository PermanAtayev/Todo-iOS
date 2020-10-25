//
//  Category.swift
//  Todoey
//
//  Created by Perman Atayev on 2.10.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name = ""
    let items = List<Item>()
}
