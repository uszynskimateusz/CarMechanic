//
//  Car.swift
//  CarMechanic
//
//  Created by Mateusz Uszyński on 31/10/2020.
//

import Foundation
import RealmSwift

class Car: Object {
    @objc dynamic var name: String = ""
    let parts = List<Part>()
}
