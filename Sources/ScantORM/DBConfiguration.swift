
struct DBConfiguration: Codable {
    let name: String?
    let host: String?
    let port: Int?
    let user: String?
    let pass: String?
    let driverType: DBDriverType
}

enum DBDriverType: Int, Codable {
    case MySQL = 1
    case PostgreSQL = 2
}
