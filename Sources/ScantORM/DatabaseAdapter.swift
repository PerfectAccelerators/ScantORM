import PerfectCRUD

protocol DatabaseAdapterProtocol {
    var dbConfig: DBConfiguration { get }
    init(config: DBConfiguration)
}

protocol DatabaseConnectionProtocol {
    associatedtype DBConfigurationProtocol: DatabaseConfigurationProtocol
    func connect() -> Database<DBConfigurationProtocol>?
    func disconnect()
}

struct DatabaseAdapter<DBC: DatabaseConfigurationProtocol>: DatabaseAdapterProtocol {
    var dbConfig: DBConfiguration
    
    init(config: DBConfiguration) {
        dbConfig = DBConfiguration(name: config.name,
                                   host: config.host,
                                   port: config.port,
                                   user: config.user,
                                   pass: config.pass,
                                   driverType: config.driverType)
    }
}

extension DatabaseAdapter {
    func connect() -> Database<DBC>? {
        do {
            let connection = try DBC.init(url: nil,
                                          name: dbConfig.name ?? "perfect",
                                          host: dbConfig.host ?? "localhost",
                                          port: dbConfig.port ?? 3306,
                                          user: dbConfig.user,
                                          pass: dbConfig.pass)
            
            return Database(configuration: connection)
        } catch let error {
            print("\(error)")
            return nil
        }
    }
    
    func disconnect() {
        // Todo
    }
}

