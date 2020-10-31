//
//  Part.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 31/10/2020.
//

import Foundation
import RealmSwift

class Part: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCar = LinkingObjects(fromType: Car.self, property: "parts")
}
