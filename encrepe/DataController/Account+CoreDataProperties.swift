//
//  Account+CoreDataProperties.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-20.
//

import Foundation
import CoreData

extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var username: Data?
    @NSManaged public var password: Data?
    @NSManaged public var date: Date?
}

extension Account: Identifiable { }

