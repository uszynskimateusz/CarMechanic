//
//  Data.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 25/10/2020.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
