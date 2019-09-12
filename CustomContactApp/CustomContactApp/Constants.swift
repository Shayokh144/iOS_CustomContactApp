//
//  Constants.swift
//  CustomContactApp
//
//  Created by Guest User on 3/28/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit

class Constants{
    static let SELECTED_BUTTON_TEXT_COLOR = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let LIGHT_GREY_COLOR = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    static let CONTACT_DETAILS_BLUE_COLOR = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)
    static let homeVCStoryBoardID = "homeViewCntrollerStoryBoard"
    static let advanceSearchVCStoryBoardID = "advanceSearchStoryBoard"
    static let presentPostStoryBoardID = "presentPostVCStoryBoard"
    static let workPlaceStoryBoarID = "workPlaceVCStoryBoard"
    static let designationStoryBoardID = "designationSelectionVCStoryBoardID"
    static let advanceSearchResultStoryBoardID = "advanceSearchResultVSStoryBoard"
    static let loginVCStoryBoardID = "loginVCStoryBoardID"
    static let dummyUserName = "01521456319"
    static let dummyPassword = "bjsd123"
    static let loginUserDefaultKey = "loginUserDefaultKey"
    static let jsonDataUrl: String = "https://script.google.com/macros/s/AKfycbz0_cBhxEQROndwd38_B3sp-uVjZpXleWrxc_qutJMzrAUkFxI/exec"
    static let jsonDataPasswordUrl: String = "https://script.google.com/macros/s/AKfycbyk9r4Pc2nVITcwJXRGCyCFwCuX-YAJrBMGhI9UHEsLxxo2vqEA/exec"
    static let coreDataEntityName = "ContactData"
    static var allContactData: [CustomEntity] = []
    static var passwordList: [String] = []
    static var presentPostList =  Set<String>()
    static var workPlaceList = Set<String>()
    static var designationList = Set<String>()
    static var designationUserDefaultKey = "designationUserDefaultKey"
    static var workPlaceUserDefaultKey = "workPlaceUserDefaultKey"
    static var presentPostUserDefaultKey = "presentPostUserDefaultKey"
    static var favouriteListUserDefaultKey = "favouriteListUserDefaultKey"
    static var aboutUsVCStoryBoardID =  "aboutUsVCStoryBoard"
    static var userNameList = ["01678171910","01711901345", "01521456319"]
}
