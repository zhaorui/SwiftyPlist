import XCTest
@testable import SwiftyPlist

private extension Keys {
    static let string = Key<String>("string")
    static let url    = Key<URL>("url")
    static let number = Key<NSNumber>("number")
    static let int    = Key<Int>("int")
    static let float  = Key<Float>("float")
    static let double = Key<Double>("double")
    static let date   = Key<Date>("date")
    static let bool   = Key<Bool>("bool")
    
    static let array      = Key<[Any]>("array")
    static let innerInt   = Key<Int>("array.0")
    static let innerArray = Key<String>("array.1.0")
    
    static let dictionary  = Key<[String : String]>("dictionary")
    static let innerString = Key<String>("dictionary.innerString")
}

private extension Keys {
    static let invalid_string = Key<String>("nonexist-string")
    static let invalid_url = Key<URL>("nonexist-url")
    static let invalid_number = Key<NSNumber>("nonexist-number")
    static let invalid_int = Key<Int>("nonexist-int")
    
    static let invalid_float  = Key<Float>("nonexist-float")
    static let invalid_double = Key<Double>("nonexist-double")
    static let invalid_date   = Key<Date>("nonexist-date")
    static let invalid_bool   = Key<Bool>("nonexist-bool")
    
    static let invalid_array      = Key<[Any]>("nonexist-array")
    static let invalid_innerInt   = Key<Int>("array.1") //which should be string
    static let out_of_bound_index = Key<Int>("array.100")
    
    static let invalid_dictionary  = Key<[String : String]>("nonexist-dictionary")
    static let invalid_innerString = Key<String>("dictionary.nonexist-innerString")
    static let invalid_wrongInt = Key<Int>("dictionary.innerString")
}

final class SwiftyPlistTests: XCTestCase {
    
    func testSep() {
        let numbers = NSArray(array: [1,2,3,4,5])
        let v = numbers.object(at: 2)
        print(v)
    }
    
    func testGetNonExistentValue() {
        let plistPath = Bundle.module.path(forResource: "Configuration", ofType: "plist")!
        let config = SwiftyPlist(plistPath: plistPath)!
        
        XCTAssertNil(config.get(.invalid_string))
        XCTAssertNil(config.get(.invalid_url))
        XCTAssertNil(config.get(.invalid_number))
        XCTAssertNil(config.get(.invalid_int))
        XCTAssertNil(config.get(.invalid_float))
        XCTAssertNil(config.get(.invalid_double))
        XCTAssertNil(config.get(.invalid_bool))
        XCTAssertNil(config.get(.invalid_date))
        
        XCTAssertNil(config.get(.invalid_array))
        XCTAssertNil(config.get(.invalid_innerInt))
        XCTAssertNil(config.get(.out_of_bound_index))
        
        XCTAssertNil(config.get(.invalid_dictionary))
        XCTAssertNil(config.get(.invalid_innerString))
        XCTAssertNil(config.get(.invalid_wrongInt))

    }
    
    func testGetValue() {
        let plistPath = Bundle.module.path(forResource: "Configuration", ofType: "plist")!
        let config = SwiftyPlist(plistPath: plistPath)!
        
        XCTAssertTrue("hoge" == config.get(.string)!)
        XCTAssertTrue(URL(string: "https://github.com/ykyouhei/SwiftyConfiguration")! == config.get(.url)!)
        XCTAssertTrue(NSNumber(value: 0 as Int32) == config.get(.number)!)
        XCTAssertTrue(1 == config.get(.int)!)
        XCTAssertTrue(1.1 == config.get(.float)!)
        XCTAssertTrue(3.14 == config.get(.double)!)
        XCTAssertTrue(config.get(.bool)!)
        XCTAssertTrue(Date(timeIntervalSince1970: 0) == config.get(.date)!)
        
        let array = config.get(.array)!
        XCTAssertTrue(array[0] as! Int == 0)
        XCTAssertTrue(array[1] as! [NSString] == ["array.1.0"])
        XCTAssertTrue(0 == config.get(.innerInt)!)
        XCTAssertTrue("array.1.0" == config.get(.innerArray)!)
        
        XCTAssertTrue(["innerString" : "moge"] == config.get(.dictionary)!)
        XCTAssertTrue("moge" == config.get(.innerString)!)
        
    }
}
