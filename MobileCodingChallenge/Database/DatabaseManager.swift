//  DatabaseManager.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 17/08/22.

import Foundation

var shareInstance = DatabaseManager()
class DatabaseManager: NSObject{
    
    var database:FMDatabase? = nil
    class func getInstance() -> DatabaseManager{
        if shareInstance.database == nil{
            shareInstance.database = FMDatabase(path: Util.getPath("Signup.db"))
        }
        return shareInstance
    }
    
    // "INSERT INTO reginfo (name, username, email, password) VALUES(?,?,?,?)"
    func saveData(_ modelInfo:SignupModel) -> Bool {
        shareInstance.database?.open()
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO Signup (username, email, country, password) VALUES (?,?,?,?)", withArgumentsIn: [modelInfo.username, modelInfo.email, modelInfo.country, modelInfo.password])
        shareInstance.database?.close()
        return isSave!
    }
    
    //MARK: - Get All Students data
    func getAllUsers() -> [SignupModel]{
        shareInstance.database?.open()
        let resultSet : FMResultSet! = try! shareInstance.database?.executeQuery("SELECT * FROM Signup", values: nil)
        var allUsers = [SignupModel]()
        if resultSet != nil{
            while resultSet.next() {
                let signupModel = SignupModel(username: resultSet.string(forColumn: "username")!, email: resultSet.string(forColumn: "email")!, country: resultSet.string(forColumn: "country")!, password: resultSet.string(forColumn: "password")!)
                allUsers.append(signupModel)
            }
        }
        shareInstance.database?.close()
        return allUsers
    }
    
}
