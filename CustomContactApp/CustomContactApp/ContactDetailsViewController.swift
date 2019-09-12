//
//  ContactDetailsViewController.swift
//  CustomContactApp
//
//  Created by Guest User on 3/28/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit

struct tableDataType{
    var dataTitle: String = ""
    var dataDescription: String = ""
}
class ContactDetailsViewController: UIViewController {
    let contactDetailsSegue: String = "contactDetailsSegue"
    var contactDetailsData: CustomEntity = CustomEntity()
    var tableData :  [tableDataType] = []
    
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var mailBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact Profile"
        //self.view.backgroundColor = Constants.CONTACT_DETAILS_BLUE_COLOR
        self.configureTableView()
        // Do any additional setup after loading the view.
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(contactDetailsData)
        nameLabel.text = contactDetailsData.cName
        currentPositionLabel.text = contactDetailsData.cPresentPost
        self.userImageView.image = UIImage(data: contactDetailsData.cImageData)
        self.createMenuListForTable()
    }
    fileprivate func updateUI(){
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
    }
    func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let customContactCell = UINib(nibName: "ContactDetailsTableViewCell", bundle: nil)
        self.tableView.register(customContactCell, forCellReuseIdentifier: ContactDetailsTableViewCell.cellIdentifier)
    }
    
    @IBAction func phoneBtnAction(_ sender: Any) {
        let number = "tel://+88" + contactDetailsData.cPersonalMobile
        UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func messageBtnAction(_ sender: Any) {
        let number = "sms:+88" + contactDetailsData.cPersonalMobile
        UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
    }
    @IBAction func mailBtnAction(_ sender: Any) {
        let email = contactDetailsData.cEmail
        if let url = URL(string: "mailto:\(email)"){
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url)
            }
            else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func favouriteBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        var favouriteList = defaults.object(forKey: Constants.favouriteListUserDefaultKey) as? [String] ?? [String]()
        if(!favouriteList.contains(contactDetailsData.userFavoutiteKey)){
            favouriteList.append(contactDetailsData.userFavoutiteKey)
            UserDefaults.standard.set(favouriteList, forKey: Constants.favouriteListUserDefaultKey)
            var message: String = ""
            message.append(contactDetailsData.cName)
            message.append(" is added to favourite!")
            favouriteAdditionAlert(message: message)
        }
        else{
            var message: String = ""
            message.append(contactDetailsData.cName)
            message.append(" already in the Favourite list!")
            favouriteAdditionAlert(message: message)
        }
    }
    
    
    fileprivate func favouriteAdditionAlert(message: String){
        // create the alert
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func createMenuListForTable(){
        var presentPost: tableDataType = tableDataType()
        presentPost.dataTitle = "Present Post"
        presentPost.dataDescription = contactDetailsData.cPresentPost
        tableData.append(presentPost)
        
        var personalMobile: tableDataType = tableDataType()
        personalMobile.dataTitle = "Mobile(p)"
        personalMobile.dataDescription = contactDetailsData.cPersonalMobile
        tableData.append(personalMobile)
        
        var officeMobile: tableDataType = tableDataType()
        officeMobile.dataTitle = "Mobile(o)"
        officeMobile.dataDescription = contactDetailsData.cOfficeMobile
        tableData.append(officeMobile)
        
        var officeLandPhn: tableDataType = tableDataType()
        officeLandPhn.dataTitle = "Land Phone(o)"
        officeLandPhn.dataDescription = contactDetailsData.cOfficeLandPhone
        tableData.append(officeLandPhn)
        
        var homeLandPhn: tableDataType = tableDataType()
        homeLandPhn.dataTitle = "Land Phone(h)"
        homeLandPhn.dataDescription = contactDetailsData.cHomeLandPhone
        tableData.append(homeLandPhn)
        
        var designation: tableDataType = tableDataType()
        designation.dataTitle = "Designation"
        designation.dataDescription = contactDetailsData.cDesignation
        tableData.append(designation)
        
        var workPlace: tableDataType = tableDataType()
        workPlace.dataTitle = "Work Place"
        workPlace.dataDescription = contactDetailsData.cWorkPlace
        tableData.append(workPlace)
        
        var email: tableDataType = tableDataType()
        email.dataTitle = "Email"
        email.dataDescription = contactDetailsData.cEmail
        tableData.append(email)
        
        var batch: tableDataType = tableDataType()
        batch.dataTitle = "Batch"
        batch.dataDescription = contactDetailsData.cBatchNO
        tableData.append(batch)
        
        var joiningDate: tableDataType = tableDataType()
        joiningDate.dataTitle = "Joining Date"
        joiningDate.dataDescription = contactDetailsData.cJoiningDate
        tableData.append(joiningDate)
        
        var gradationNo: tableDataType = tableDataType()
        gradationNo.dataTitle = "Gradation Number"
        gradationNo.dataDescription = contactDetailsData.cGradationNumber
        tableData.append(gradationNo)
        
        var serviceId: tableDataType = tableDataType()
        serviceId.dataTitle = "Service ID"
        serviceId.dataDescription = contactDetailsData.cServiceId
        tableData.append(serviceId)
        
        var homeDis: tableDataType = tableDataType()
        homeDis.dataTitle = "Home District"
        homeDis.dataDescription = contactDetailsData.cHomeDistrict
        tableData.append(homeDis)
        
        var bloodGrp: tableDataType = tableDataType()
        bloodGrp.dataTitle = "Blood Group"
        bloodGrp.dataDescription = contactDetailsData.cBloodGroup
        tableData.append(bloodGrp)
    }
}

extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailsTableViewCell.cellIdentifier) as? ContactDetailsTableViewCell{
            cell.titleLabel.text = tableData[indexPath.row].dataTitle
            cell.descriptionLabel.text = tableData[indexPath.row].dataDescription
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = Constants.LIGHT_GREY_COLOR
            }
            else{
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
        return UITableViewCell()
    }
}
