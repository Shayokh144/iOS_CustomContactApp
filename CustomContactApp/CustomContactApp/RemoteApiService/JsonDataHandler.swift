//
//  JsonDataHandler.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/4/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import Foundation
protocol JsonResponseProtocol: class {
    func receiveJsonResponseData(data: [CustomEntity])
    func receiveErrorMessage(errorMsg: String)
}
protocol JsonResponsePasswordProtocol: class {
    func receivePasswordList(passwordList: [String])
    func receiveErrorMessage(errorMsg: String)
}
class JsonResponseHandler{
    weak var jsonResponseDelegate: JsonResponseProtocol?
    weak var jsonResponsePasswordDelegate: JsonResponsePasswordProtocol?
    func getJsonResponseFromUrl(urlString: String){
        guard let url = URL(string: urlString) else {
            self.jsonResponseDelegate?.receiveErrorMessage(errorMsg: "No data found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    //print(error?.localizedDescription ?? "Response Error")
                    self.jsonResponseDelegate?.receiveErrorMessage(errorMsg: "No data found!")
                    return
            }
            do{
                // here data response received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    self.jsonResponseDelegate?.receiveErrorMessage(errorMsg: "No data found!")
                    return
                }
                var jsonArrayFinal: [[String: Any]] = jsonArray["user"] as! [[String: Any]]
                var customEntityList: [CustomEntity] = []
                var customEntityObj = CustomEntity()
                var userID : String = ""
                for index in 0 ..< jsonArrayFinal.count{
                    var dataObj = jsonArrayFinal[index]
                    customEntityObj.cName = dataObj["Name"] as! String
                    customEntityObj.cImageLink = dataObj["ImageLink"] as! String
                    if(customEntityObj.cImageLink.count > 0){
                        customEntityObj.cImageLink = Utility.convertImageUrl(gDriveUrl: customEntityObj.cImageLink)
                    }
                    customEntityObj.cPersonalMobile = dataObj["Mobile_P"] as! String
                    customEntityObj.cOfficeMobile = dataObj["Mobile_O"] as! String
                    customEntityObj.cOfficeLandPhone = dataObj["LandPhone_O"] as! String
                    customEntityObj.cHomeLandPhone = dataObj["LandPhone_R"] as! String
                    customEntityObj.cEmail = dataObj["Email"] as! String
                    customEntityObj.cDesignation = dataObj["Designation"] as! String
                    if(customEntityObj.cDesignation.count > 0){
                        Constants.designationList.insert(customEntityObj.cDesignation)
                    }
                    customEntityObj.cPresentPost = dataObj["Present_Post"] as! String
                    if(customEntityObj.cPresentPost.count > 0){
                        Constants.presentPostList.insert(customEntityObj.cPresentPost)
                    }
                    customEntityObj.cWorkPlace = dataObj["Work_Place"] as! String
                    if(customEntityObj.cWorkPlace.count > 0){
                        Constants.workPlaceList.insert(customEntityObj.cWorkPlace)
                    }
                    customEntityObj.cBatchNO = dataObj["Batch_No"] as! String
                    customEntityObj.cJoiningDate = dataObj["Joining_Date"] as! String
                    customEntityObj.cGradationNumber = dataObj["Gradation_Number"] as! String
                    customEntityObj.cServiceId = dataObj["Service_ID"] as! String
                    customEntityObj.cDateOfBirth = dataObj["Date_OF_Birth"] as! String
                    customEntityObj.cHomeDistrict = dataObj["Home_District"] as! String
                    customEntityObj.cBloodGroup = dataObj["Blood_Group"] as! String
                    userID = customEntityObj.cName + customEntityObj.cEmail + customEntityObj.cServiceId + customEntityObj.cPersonalMobile
                    userID = userID.replacingOccurrences(of: " ", with: "")
                    customEntityObj.userFavoutiteKey = userID
                    customEntityList.append(customEntityObj)
                }
                UserDefaults.standard.set(Array(Constants.designationList), forKey: Constants.designationUserDefaultKey)
                UserDefaults.standard.set(Array(Constants.workPlaceList), forKey: Constants.workPlaceUserDefaultKey)
                UserDefaults.standard.set(Array(Constants.presentPostList), forKey: Constants.presentPostUserDefaultKey)
                self.jsonResponseDelegate?.receiveJsonResponseData(data: customEntityList) //sending data
                
            }catch let parsingError{
                self.jsonResponseDelegate?.receiveErrorMessage(errorMsg: "No data found")
                //print("Error", parsingError)
            }
        }
        task.resume()
        return
    }
    
    
    
    func getPasswordListFromUrl(urlString: String){
        guard let url = URL(string: urlString) else {
            self.jsonResponsePasswordDelegate?.receiveErrorMessage(errorMsg: "No data found!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    //print(error?.localizedDescription ?? "Response Error")
                    self.jsonResponsePasswordDelegate?.receiveErrorMessage(errorMsg: "No data found!")
                    return
            }
            do{
                // here data response received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    self.jsonResponsePasswordDelegate?.receiveErrorMessage(errorMsg: "No data found!")
                    return
                }
                var passwordList: [String] = []
                var jsonArrayFinal: [[String: Any]] = jsonArray["user"] as! [[String: Any]]
                for index in 0 ..< jsonArrayFinal.count{
                    //print(jsonArrayFinal[index]["password"])
                    passwordList.append(jsonArrayFinal[index]["password"] as! String)
                }
                self.jsonResponsePasswordDelegate?.receivePasswordList(passwordList: passwordList)
                
            }catch let parsingError{
                self.jsonResponsePasswordDelegate?.receiveErrorMessage(errorMsg: "No data found")
                //print("Error", parsingError)
            }
        }
        task.resume()
        return
    }
}
