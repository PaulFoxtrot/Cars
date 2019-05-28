//
//  Car+CoreDataProperties.swift
//  NewCarList
//
//  Created by foxtrot on 28/05/2019.
//  Copyright © 2019 foxtrot. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var model: String?
    @NSManaged public var year: Int16

}
