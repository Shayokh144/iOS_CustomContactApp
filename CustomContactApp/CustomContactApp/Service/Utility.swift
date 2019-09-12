//
//  Utility.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/2/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import Foundation
class Utility{
    class func isUserLoggedIn()-> Bool{
        var isLoggedIn = false
        if (UserDefaults.standard.object(forKey: Constants.loginUserDefaultKey) != nil){
            if(UserDefaults.standard.bool(forKey: Constants.loginUserDefaultKey)){
                isLoggedIn = true
            }
        }
        return isLoggedIn
        
    }
    class func findIdFromGDriveUrl(urlString: String)-> String{
        let baseUrl = "https://drive.google.com/open?id="
        let idString = urlString.replacingOccurrences(of: baseUrl, with: "")
        return idString
    }
    class func convertImageUrl(gDriveUrl: String)-> String{
        let imageId = Utility.findIdFromGDriveUrl(urlString: gDriveUrl)
        var imageUrl = "https://drive.google.com/uc?id="
        imageUrl.append(imageId)
        return imageUrl
    }
}
