import Foundation
import RealmSwift

class Paper: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var last_modified = Date()
    
    dynamic var abstract = ""
    dynamic var acmid = ""
    dynamic var username = ""
    dynamic var address = ""
    dynamic var authors = ""
    dynamic var bookTitle = ""
    dynamic var databasePublisher = ""
    dynamic var databaseUrl = ""
    dynamic var doi = ""
    dynamic var endPage = ""
    dynamic var entryType = ""
    dynamic var inProceeding = ""
    dynamic var isbn = ""
    
    let isLiked = RealmOptional<Bool>()
    let isRead = RealmOptional<Bool>()
    
    dynamic var keywords = ""
    dynamic var location = ""
    dynamic var numpages = ""
    dynamic var pages = ""
    dynamic var published = ""
    dynamic var publisher = ""
    dynamic var rawEntry = ""
    dynamic var series = ""
    dynamic var startPage = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var volume = ""
    dynamic var year = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


// MARK: object extension for
extension Object {
    
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties as [Property]! {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    let object = nestedListObject._rlmArray[index] as AnyObject
                    objects.append(object.toDictionary())
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }  else if let dateObject = self[prop.name] as? NSDate {
                let dateString = dateObject.timeIntervalSince1970  //Perform the conversion you want here
                mutabledic.setValue(dateString, forKey: prop.name)
            }
            
        }
        return mutabledic
    }
    
}
