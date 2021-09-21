import Foundation

public protocol PlistValueType {}

extension String: PlistValueType {}
extension URL: PlistValueType {}
extension NSNumber: PlistValueType {}
extension Int: PlistValueType {}
extension Float: PlistValueType {}
extension Double: PlistValueType {}
extension Bool: PlistValueType {}
extension Date: PlistValueType {}
extension Data: PlistValueType {}
extension Array: PlistValueType {}
extension Dictionary: PlistValueType {}

/// Extend this class and add your plist keys as static constants
/// so you can use the shortcut dot notation (e.g. ` configuration.get(.yourKey)`)

open class Keys {}

public final class Key<ValueType: PlistValueType>: Keys {
    
    public let key: String
    
    internal var separatedKeys: [String] {
        return key.components(separatedBy: ".")
    }
    
    public init(_ key: String) {
        self.key = key
    }
    
}

struct SwiftyPlist {
    private let dictionary: NSDictionary
        
        public init?(plistPath: String) {
            guard let plist = NSDictionary(contentsOfFile: plistPath) else {
                print("could not read plist file.")
                return nil
            }
            dictionary = plist
        }
        
        public func get<T>(_ key: Key<T>) -> T? {
            var object: AnyObject = dictionary
            
            for (_, separatedKey) in key.separatedKeys.enumerated() {
                if let index = Int(separatedKey), let array = object as? Array<AnyObject> {
                    guard index < array.count else { return nil }
                    object = array[index]
                } else if let dictionary = object as? NSDictionary {
                    object = dictionary[separatedKey] as AnyObject
                }
            }
            
            let optionalValue: T?
            
            switch T.self {
            case is Int.Type:    optionalValue = object as? T
            case is Float.Type:  optionalValue = object.floatValue as? T
            case is Double.Type: optionalValue = object.doubleValue as? T
            case is URL.Type:  optionalValue = URL(string: (object as? String) ?? "") as? T
            default:             optionalValue = object as? T
            }
            
            guard let value = optionalValue else {
                print("Could not cast value of type \(type(of: object)) to \(T.self)")
                return nil
            }
            
            return value
        }
}
