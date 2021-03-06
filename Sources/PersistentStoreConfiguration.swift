//
//  PersistentStoreConfiguration.swift
//  Glover
//
//  Created by Sebastian Owodzin on 13/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation
import CoreData

public enum PersistentStoreType: String {
    case SQLite
    case Binary
    case InMemory

    func toCoreDataStoreType() -> String {
        switch self {
        case .SQLite:
            return NSSQLiteStoreType
        case .Binary:
            return NSBinaryStoreType
        case .InMemory:
            return NSInMemoryStoreType
        }
    }
}

//public struct PersistentStoreType {
//    @available(iOS 3.0, OSX 10.4, *)
//    static let SQLite = NSSQLiteStoreType
//
////    @available(OSX 10.4, *)
////    static let XML = NSXMLStoreType
//
//    @available(iOS 3.0, OSX 10.4, *)
//    static let Binary = NSBinaryStoreType
//
//    @available(iOS 3.0, OSX 10.4, *)
//    static let InMemory = NSInMemoryStoreType
//}

public struct PersistentStoreConfiguration: CustomStringConvertible, CustomDebugStringConvertible {
    var type: PersistentStoreType
    var url: URL?
    var configuration: String?
    var options: [String: AnyObject]?

    public var description: String {
        return "PersistentStoreConfiguration: [ type: \(type) | configuration: \(configuration) | URL: \(url) | options: \(options) ]"
    }

    public var debugDescription: String {
        return "PersistentStoreConfiguration: [ type: \(type) | configuration: \(configuration) | URL: \(url) | options: \(options) ]"
    }

    public init(type: PersistentStoreType, url: URL? = nil, configuration: String? = nil, options: [String: AnyObject]? = nil) {
        self.type = type
        self.url = url
        self.configuration = configuration
        self.options = options
    }
}
