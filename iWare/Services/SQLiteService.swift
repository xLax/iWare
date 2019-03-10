import Foundation

class SQLiteService {
    
    static let shareInstance: SQLiteService = SQLiteService()
    
    static var database: OpaquePointer? = nil
    static let dbFileName = "iCarDataBase.db"
    
    private init() { }
    
    static func connectDb() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
        }
    }
    
    static func createPostsTable() {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS POSTS (POST_ID VARCHAR(10) PRIMARY KEY, USER_NAME VARCHAR(50), CONTENT VARCHAR(300), IMAGE_ID VARCHAR(50))", nil, nil, &errormsg);
        
        if(res != 0){
            print(errormsg)
            print("error creating table");
            return
        } else {
            print("create posts table successfully")
        }
    }
    
    static func insertPost(post: Post) {
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO POSTS(POST_ID, USER_NAME, CONTENT, IMAGE_ID) VALUES (?,?,?,?)",-1,
                               &sqlite3_stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, post.id, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 2, post.userName, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 3, post.text, -1, nil);
            sqlite3_bind_text(sqlite3_stmt, 4, post.imageId, -1, nil);
            let sqlMessage = sqlite3_step(sqlite3_stmt)
            if(sqlMessage == SQLITE_DONE){
                print("new row added or replaced succefully")
            } else {
                print(sqlMessage)
            }
        }
    }
    
    static func deletePost(id: String) {
        print("id", id)
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"DELETE FROM POSTS WHERE POST_ID=?", -1,&sqlite3_stmt , nil) == SQLITE_OK){
            sqlite3_bind_text(sqlite3_stmt, 1, id, -1, nil);
            let sqlMessage = sqlite3_step(sqlite3_stmt)
            if(sqlMessage == SQLITE_DONE){
                print("row delete succefully")
            } else {
                print(sqlMessage)
            }
        }
    }
    
    static func getAllPosts() -> [Post] {
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Post]()
        if (sqlite3_prepare_v2(database,"SELECT * from POSTS;", -1, &sqlite3_stmt, nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                let id = String(cString:sqlite3_column_text(sqlite3_stmt, 0)!)
                let userName = String(cString:sqlite3_column_text(sqlite3_stmt, 1)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt, 2)!)
                let imageId = String(cString:sqlite3_column_text(sqlite3_stmt, 3)!)
                data.append(Post(id: id, userName: userName, text: text, imageId: imageId))
            }
        }
        
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
}

