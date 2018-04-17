
import Foundation
import PerfectCRUD

public struct DatabaseManager<D: DatabaseConfigurationProtocol> {
    
    // MARK: - Dependency Injection
    
    public let db: Database<D>
    public init(db: Database<D>) {
        self.db = db
    }
    
    // MARK: - Create
    /// ## Create a DB table with an optional primary key
    public func create<T: Codable, V: Equatable>(_ table: T.Type,
                                                 pk: KeyPath<T, V>? = nil,
                                                 policy: TableCreatePolicy = .reconcileTable) throws {
        do {
            try db.create(table.self, primaryKey: pk, policy: policy)
        } catch let error {
            print(error.localizedDescription)
            throw CRUDSQLGenError("Not able to create the table: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Read
    
    /// ## Read Data from DB
    /// - Parameter table: Type of table to be read from DB
    /// - Parameter where: where - CRUDBooleanExpression? if not passed all the data will be updated
    /// - Returns: T
    public func read<T: Codable>(_ table: T.Type,
                                 where expr: CRUDBooleanExpression?) throws -> [T] {
        
        let tbl = db.table(table.self)
        
        do {
            if let expression = expr {
                let query = tbl.where(expression)
                let result = try query.select().map { $0 }
                return result
            } else {
                let result = try tbl.select().map { $0 }
                return result
            }
        } catch let error {
            print(error.localizedDescription)
            throw CRUDSQLExeError("Not able to read from DB: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Insert
    
    /// ## Insert one record into table
    /// - Parameter record: table row
    
    public func insert<T: Codable>(_ record: T) throws {
        
        do {
            let type = try tableType(record)
            let table = db.table(type)
            try table.insert(record)
        } catch let error {
            print(error.localizedDescription)
            throw CRUDSQLExeError("Not able to insert the record: \(error.localizedDescription)")
        }
    }
    
    /// ## Insert many records into table
    /// - Parameter records: table rows
    
    public func insert<T: Codable>(_ records: [T]) throws {
        
        let mirror = Mirror(reflecting: records)
        guard let arrayType = mirror.subjectType as? Array<T>.Type else {
            throw CRUDSQLGenError("Not able to identify the table")
        }
        let type = arrayType.Element.self
        let table = db.table(type)
        
        do {
            for rec in records {
                try table.insert(rec)
            }
        } catch let error {
            print(error.localizedDescription)
            throw CRUDSQLExeError("Not able to insert the record: \(error.localizedDescription)")
        }
    }
    // MARK: - Update
    
    /// ## Update records from a table
    /// - Parameter: table - type of the table
    /// - Parameter: where - CRUDBooleanExpression? if not passed all the data will be updated
    
    public func update<T: Codable>(_ table: T,
                                   where expr: CRUDBooleanExpression?) throws {
        do {
            let type = try tableType(table)
            let tbl = db.table(type)
            if let expression = expr {
                try tbl.where(expression).update(table)
            }
        } catch let error {
            throw CRUDSQLExeError("Not able to delete the table: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete
    
    /// ## Delete records from a table
    /// - Parameter: table - type of the table
    /// - Parameter: where - CRUDBooleanExpression? if not passed all the data will be deleted
    public func delete<T: Codable>(_ table: T.Type,
                                   where expr: CRUDBooleanExpression?) throws {
        
        let tbl = db.table(table)
        do {
            if let expression = expr {
                let query = tbl.where(expression)
                try query.delete()
            } else {
                try tbl.delete()
            }
        } catch let error {
            throw CRUDSQLExeError("Not able to delete the table: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    
    public func tableType<T: Codable>(_ table: T) throws -> T.Type {
        let mirror = Mirror(reflecting: table)
        guard let type = mirror.subjectType as? T.Type else {
            throw CRUDSQLGenError("Not able to identify the table")
        }
        return type
    }
}

