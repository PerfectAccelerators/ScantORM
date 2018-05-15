//
//  AppDatabaseProtocol.swift
//  ScantORM
//
//  Created by Fatih Nayebi on 2018-05-15.
//

import Foundation
import PerfectCRUD

public protocol AppDatabaseProtocol {
    associatedtype DBConfigurationProtocol: DatabaseConfigurationProtocol
    func database() -> Database<DBConfigurationProtocol>?
    func disconnect()
}
