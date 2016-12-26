import Foundation
import RealmSwift

class PaperCollection: Object {
    dynamic var id = UUID().uuidString
    dynamic var last_modified = Date()
    dynamic var title = ""
    let isFav = RealmOptional<Bool>()
    var paperSessions = List<PaperSession>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func totalLabels() -> Int {
        return paperSessions.count
    }
    
    func totalPapers() -> Int {
        var count = 0
        
        for ps in paperSessions {
            count += ps.paperCount()
        }
        return count
    }
    
    func totalLikes() -> Int {
        
        var count = 0
        
        for ps in paperSessions {
            count += ps.likes()
        }
        
        return count
    }
}

class PaperSession: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var last_modified = Date()
    dynamic var title = ""
    
    let likesCount = RealmOptional<Int>()
    let favCount = RealmOptional<Int>()
    let totalLikes = RealmOptional<Int>()
    var papers = List<Paper>()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func paperCount() -> Int {
        return papers.count
    }
    
    func likes() -> Int {
        if papers.isEmpty {
            return 0
        } else {
            var count = 0
            for p in papers {
                if let liked = p.isLiked.value {
                    if liked {
                        count += 1
                    }
                }
            }
            return count
        }
    }
}

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
    
    let isLiked = RealmOptional<Bool>()
    let isRead = RealmOptional<Bool>()
    let isFav = RealmOptional<Bool>()
    
    func populateEndnote( _ properties: [String:AnyObject]) {
        //self.rawEntry = properties as NSObject?
        self.entryType = (properties["TY"] as? String)!
        self.abstract = (properties["AB"] as? String)!
        self.acmid = (properties["UR"] as? String)!
        
        let t = (properties["A1"] as! [String])
        self.authors = t.joined(separator: ",")
        
        self.title = (properties["T1"] as? String)!
        self.inProceeding = (properties["T2"] as? String)!
        self.published = (properties["PY"] as? String)!
        
        if let v = properties["VL"] {
            self.volume = v as! String
        }
        
        self.startPage = (properties["SP"] as? String)!
        self.endPage = (properties["EP"] as? String)!
        self.doi = (properties["UR"] as? String)!
        self.databaseUrl = (properties["DP"] as? String)!
        self.databasePublisher = (properties["DB"] as? String)!
        
        if let kw = properties["KW"] {
            self.keywords = kw as! String
        }
        
        //self.keywords = (properties["KW"] as? String)!
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Realm {
    
    var paperSessions: Results<PaperSession> {
        return objects(PaperSession.self)
    }
    
    var paperCollections: Results<PaperCollection> {
        return objects(PaperCollection.self)
    }
    
    var papers: Results<Paper> {
        return objects(Paper.self)
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
