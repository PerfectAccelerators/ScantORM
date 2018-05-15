import XCTest
@testable import ScantORM

final class ScantORMTests: XCTestCase {
    func testExample() {
        
    }
    /*
    func testDatabaseConnection() {
        guard let db = app.database() else {
            XCTAssert(false)
            return
        }
        
        let database = DatabaseManager(db: db)
        do {
            let people = try database.read(Person.self, where: nil)
            XCTAssertNotNil(people)
            print("\(people.first)")
        } catch {
            print("error")
            XCTAssert(false)
        }
    }
 */

    static var allTests = [
        ("testExample", testExample),
    ]
}
