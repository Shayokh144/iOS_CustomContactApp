//
//  HomeViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 3/24/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit
import CoreData
class HomeViewController: UIViewController {
    enum HomePageButtons : Int{
        case CONTACTS_BUTTON, FAVOURITE_BUTTON, SYNC_BUTTON
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIButton!
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let messageFrameViewForLoadingIndicator = UIView()
    var loadingActivityIndicatorView = UIActivityIndicatorView()
    var LoadingActivityLabel = UILabel()
    let loadingEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var allData: [CustomEntity] = []
    var filteredData: [CustomEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(moreButtonTapped))
        self.searchBar.delegate = self
        self.fetchDataFromCoreData()
        self.configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeButtonColor(homePageSelectedBtn: HomePageButtons.CONTACTS_BUTTON)
        self.searchCancelButton.isHidden = true
        self.searchCancelButton.isEnabled = false
        self.populateData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func moreButtonTapped(){
        // show alert view
        self.showAlertView()
    }
    
    fileprivate func showAlertView(){
        showSimpleActionSheet()
    }
    fileprivate func populateData(){
        self.fetchDataFromCoreData()
    }
    fileprivate func fetchDataFromCoreData(){
        if (Constants.allContactData.count == 0){
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.coreDataEntityName)
            var coreDataList = [ContactData]()
            do{
                var dataObj = CustomEntity()
                coreDataList = try managedContext.fetch(fetchRequest) as! [ContactData]
                for data in coreDataList{
                    if let name = data.value(forKey: "cName") as? String{
                        dataObj.cName = name
                    }
                    if let email = data.value(forKey: "cEmail") as? String{
                        dataObj.cEmail = email
                    }
                    if let presentPost = data.value(forKey: "cPresentPost") as? String{
                        dataObj.cPresentPost = presentPost
                    }
                    if let workPlace = data.value(forKey: "cWorkPlace") as? String{
                        dataObj.cWorkPlace = workPlace
                    }
                    if let imageData = data.value(forKey: "cImageData") as? Data{
                        dataObj.cImageData = imageData
                    }
                    if let mobileP = data.value(forKey: "cPersonalMobile") as? String{
                        dataObj.cPersonalMobile = mobileP
                    }
                    if let mobileO = data.value(forKey: "cOfficeMobile") as? String{
                        dataObj.cOfficeMobile = mobileO
                    }
                    if let cOfficeLandPhone = data.value(forKey: "cOfficeLandPhone") as? String{
                        dataObj.cOfficeLandPhone = cOfficeLandPhone
                    }
                    if let cHomeLandPhone = data.value(forKey: "cHomeLandPhone") as? String{
                        dataObj.cHomeLandPhone = cHomeLandPhone
                    }
                    if let designation = data.value(forKey: "cDesignation") as? String{
                        dataObj.cDesignation = designation
                    }
                    if let batch = data.value(forKey: "cBatchNO") as? String{
                        dataObj.cBatchNO = batch
                    }
                    if let joinindDate = data.value(forKey: "cJoiningDate") as? String{
                        dataObj.cJoiningDate = joinindDate
                    }
                    if let gradationNumber = data.value(forKey: "cGradationNumber") as? String{
                        dataObj.cGradationNumber = gradationNumber
                    }
                    if let serviceId = data.value(forKey: "cServiceId") as? String{
                        dataObj.cServiceId = serviceId
                    }
                    if let dateOfBirth = data.value(forKey: "cDateOfBirth") as? String{
                        dataObj.cDateOfBirth = dateOfBirth
                    }
                    if let homeDistrict = data.value(forKey: "cHomeDistrict") as? String{
                        dataObj.cHomeDistrict = homeDistrict
                    }
                    if let bloodGroup = data.value(forKey: "cBloodGroup") as? String{
                        dataObj.cBloodGroup = bloodGroup
                    }
                    if let userFavKey = data.value(forKey: "userFavoutiteKey") as? String{
                        dataObj.userFavoutiteKey = userFavKey
                    }
                    Constants.allContactData.append(dataObj)
                }
            }
            catch{
                print("No data Found...")
            }
        }
        allData = Constants.allContactData
        filteredData = allData
    }
    fileprivate func deleteAllDataFromCoreData(entityName: String){
        Constants.allContactData = []
        filteredData = []
        allData = []
        // Now delete from coreDB
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteAllRequest = NSBatchDeleteRequest.init(fetchRequest: request)
        do{
            try managedContext.execute(deleteAllRequest)
        }
        catch{
            //print("error ..... ")
        }
        
    }
    func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        let customContactCell = UINib(nibName: "CustonContactTableViewCell", bundle: nil)
        self.tableView.register(customContactCell, forCellReuseIdentifier: CustonContactTableViewCell.cellIdentifier)
    }
    
    fileprivate func showSimpleActionSheet() {
        let alert = UIAlertController(title: "More Options", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Advance Search", style: .default, handler: { (_) in
            //print("User click Search button")
            let advanceSearchVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.advanceSearchVCStoryBoardID)as! AdvanceSearchViewController
            self.navigationController?.pushViewController(advanceSearchVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "About us", style: .default, handler: { (_) in
            let aboutUsVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.aboutUsVCStoryBoardID)as! AboutUsViewController
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            //print("User click Logout button")
            UserDefaults.standard.set(false, forKey: Constants.loginUserDefaultKey)
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.loginVCStoryBoardID)as! ViewController
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(loginVC, animated: true)
            //self.present(loginVC, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            //print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            //print("completion block")
        })
    }
    @IBAction func contactButtonAction(_ sender: Any) {
        changeButtonColor(homePageSelectedBtn: HomePageButtons.CONTACTS_BUTTON)
        showContactList()
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        changeButtonColor(homePageSelectedBtn: HomePageButtons.FAVOURITE_BUTTON)
        showFavouriteList()
    }
    
    @IBAction func syncButtonAction(_ sender: Any) {
        changeButtonColor(homePageSelectedBtn: HomePageButtons.SYNC_BUTTON)
        if(Reachability.isConnectedToInternet()){
            syncData()
        }
        else{
            showErrorMessage(message: "No Network connection !!")
        }
        
    }
    fileprivate func showErrorMessage(message: String){
        // create the alert
        let alert = UIAlertController(title: "Try again!", message: message, preferredStyle: .alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func searchCancelBtnAction(_ sender: Any) {
        searchCancelButton.isEnabled = false
        searchCancelButton.isHidden = true
        searchBar.text = ""
        filteredData = allData
        self.tableView.reloadData()
    }
    
    private func updateTableView(){
        populateData()
        self.tableView.reloadData()
    }
    private func configureAllButtonUI(){
        self.contactButton.layer.cornerRadius = 2
        self.favouriteButton.layer.cornerRadius = 2
        self.syncButton.layer.cornerRadius = 2
        
        self.contactButton.layer.borderWidth = 1
        self.favouriteButton.layer.borderWidth = 1
        self.syncButton.layer.borderWidth = 1
    }
    
    private func changeButtonColor(homePageSelectedBtn: HomePageButtons){
        switch homePageSelectedBtn {
        case .CONTACTS_BUTTON:
            //print("contacts selected")
            self.contactButton.setTitleColor(Constants.SELECTED_BUTTON_TEXT_COLOR, for: .normal)
            self.favouriteButton.setTitleColor(UIColor.white, for: .normal)
            self.syncButton.setTitleColor(UIColor.white, for: .normal)
            //self.showContactList()
        case .FAVOURITE_BUTTON:
            //print("favourite selected")
            self.contactButton.setTitleColor(UIColor.white, for: .normal)
            self.favouriteButton.setTitleColor(Constants.SELECTED_BUTTON_TEXT_COLOR, for: .normal)
            self.syncButton.setTitleColor(UIColor.white, for: .normal)
            //self.showFavouriteList()
        case .SYNC_BUTTON:
            //print("sync selected")
            self.contactButton.setTitleColor(UIColor.white, for: .normal)
            self.favouriteButton.setTitleColor(UIColor.white, for: .normal)
            self.syncButton.setTitleColor(Constants.SELECTED_BUTTON_TEXT_COLOR, for: .normal)
            //self.syncData()
        }
    }
    private func showContactList(){
        //print("show contact list")
        updateTableView()
    }
    private func showFavouriteList(){
        //print("show favourite list")
        let favouriteList = getFavouriteList()
        var newFavouriteDataList: [CustomEntity] = []
        for dataObj in Constants.allContactData{
            if favouriteList.contains(dataObj.userFavoutiteKey){
                newFavouriteDataList.append(dataObj)
            }
        }
        filteredData  = newFavouriteDataList
        tableView.reloadData()
    }
    private func getFavouriteList()-> [String]{
        let defaults = UserDefaults.standard
        let favouriteList = defaults.object(forKey: Constants.favouriteListUserDefaultKey) as? [String] ?? [String]()
        return favouriteList
    }
    func syncData(){
        //print("sync data")
        let jsonObj = JsonResponseHandler()
        jsonObj.jsonResponseDelegate = self
        disaBleAllButton()
        self.tableView.isUserInteractionEnabled = false
        jsonObj.getJsonResponseFromUrl(urlString: Constants.jsonDataUrl)
        self.showLoadingActivityIndicator(title: "Fetching data... ")
        
    }
    func disaBleAllButton(){
        self.searchCancelButton.isEnabled = false
        self.contactButton.isEnabled = false
        self.favouriteButton.isEnabled = false
        self.syncButton.isEnabled = false
    }
    func enableAllButton(){
        self.searchCancelButton.isEnabled = true
        self.contactButton.isEnabled = true
        self.favouriteButton.isEnabled = true
        self.syncButton.isEnabled = true
    }
    fileprivate func gotoNextPageWithData(data: CustomEntity){
        let contactDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "contactDetailsViewControllerStoryBoard")as! ContactDetailsViewController
        contactDetailsVC.contactDetailsData = data
        self.navigationController?.pushViewController(contactDetailsVC, animated: true)
    }

}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustonContactTableViewCell.cellIdentifier) as? CustonContactTableViewCell{
            cell.nameLabel.text = filteredData[indexPath.row].cName
            cell.presentPostLabel.text = filteredData[indexPath.row].cPresentPost
            cell.workPlaceLabel.text = filteredData[indexPath.row].cWorkPlace
            cell.customContactCellButtonDelegate = self
            cell.moreButton.tag = indexPath.row
            cell.userImageView.image = UIImage(data: filteredData[indexPath.row].cImageData)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoNextPageWithData(data: filteredData[indexPath.row])
    }
}

extension HomeViewController: CustomContactCellButtonProtocol{
    
    func didPressCustomCellButton(_ tag: Int) {
        print("tapped button index = \(tag)")
        // show call, msg, mail options
        let alertMsg = "contact with " + filteredData[tag].cName + "."
        let alert = UIAlertController(title: "Contact Now!", message: alertMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (_) in
            let number = "tel://+88" + self.filteredData[tag].cPersonalMobile
            UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { (_) in
            let number = "sms:+88" + self.filteredData[tag].cPersonalMobile
            UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { (_) in
            let email = self.filteredData[tag].cEmail
            if let url = URL(string: "mailto:\(email)"){
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url)
                }
                else{
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == ""){
            self.searchCancelButton.isHidden = true
            self.searchCancelButton.isEnabled = false
            filteredData = allData
        }
        else{
            filteredData = []
            /*for (index, data) in allData.enumerated(){
                if(data.cName.lowercased().contains(searchText.lowercased())){
                    filteredData.append(data)
                }
            }*/
            filteredData = allData.filter{
                $0.cName.lowercased().contains(searchText.lowercased())
            }
            if(self.searchCancelButton.isHidden == true){
                self.searchCancelButton.isHidden = false
                self.searchCancelButton.isEnabled = true
            }
            
        }
        self.tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchCancelButton.isHidden = false
        self.searchCancelButton.isEnabled = true
    }
}


extension HomeViewController{
    func showLoadingActivityIndicator(title: String){
        self.LoadingActivityLabel.removeFromSuperview()
        self.loadingActivityIndicatorView.removeFromSuperview()
        self.loadingEffectView.removeFromSuperview()
        
        self.LoadingActivityLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        self.LoadingActivityLabel.text = title
        self.LoadingActivityLabel.font = .systemFont(ofSize: 14, weight: .medium)
        self.LoadingActivityLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        self.loadingEffectView.frame = CGRect(x: view.frame.midX - self.LoadingActivityLabel.frame.width/2, y: view.frame.midY - self.LoadingActivityLabel.frame.height/2, width: 160, height: 46)
        self.loadingEffectView.layer.cornerRadius = 15
        self.loadingEffectView.layer.masksToBounds = true
        
        self.loadingActivityIndicatorView = UIActivityIndicatorView()
        self.loadingActivityIndicatorView.activityIndicatorViewStyle = .white
        self.loadingActivityIndicatorView.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        self.loadingActivityIndicatorView.startAnimating()
        
        self.loadingEffectView.contentView.addSubview(self.loadingActivityIndicatorView)
        self.loadingEffectView.contentView.addSubview(self.LoadingActivityLabel)
        self.view.addSubview(self.loadingEffectView)
    }
    fileprivate func finishAllAsyncTask(){
        DispatchQueue.main.async {
            self.enableAllButton()
            self.loadingEffectView.removeFromSuperview()
            self.updateTableView()
            self.tableView.isUserInteractionEnabled = true
            self.changeButtonColor(homePageSelectedBtn: .CONTACTS_BUTTON)
        }
    }
}
extension HomeViewController: JsonResponseProtocol{
    func receiveErrorMessage(errorMsg: String) {
        self.finishAllAsyncTask()
        self.showErrorMessage(message: errorMsg)
    }
    
    func saveDataToCoreDB(dataObjectList: [CustomEntity]){
        self.deleteAllDataFromCoreData(entityName: Constants.coreDataEntityName)
        DispatchQueue.main.async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityObj = NSEntityDescription.entity(forEntityName: Constants.coreDataEntityName, in: managedContext)
        for dataObj in dataObjectList{
            let dataObjForCD = NSManagedObject(entity: entityObj!, insertInto: managedContext)
            //if(dataObj.cName != nil){
                dataObjForCD.setValue(dataObj.cName, forKey: "cName")
            //}
            //if(dataObj.cEmail != nil){
                dataObjForCD.setValue(dataObj.cEmail, forKey: "cEmail")
            //}
            //if(dataObj.cImageLink != nil){
                dataObjForCD.setValue(dataObj.cImageLink, forKey: "cImageLink")
            //}
            //if(dataObj.cImageData != nil){
                dataObjForCD.setValue(dataObj.cImageData, forKey: "cImageData")
            //}
            dataObjForCD.setValue(dataObj.cPresentPost, forKey: "cPresentPost")
            dataObjForCD.setValue(dataObj.cWorkPlace, forKey: "cWorkPlace")
            dataObjForCD.setValue(dataObj.cPersonalMobile, forKey: "cPersonalMobile")
            dataObjForCD.setValue(dataObj.cOfficeMobile, forKey: "cOfficeMobile")
            
            dataObjForCD.setValue(dataObj.cHomeLandPhone, forKey: "cHomeLandPhone")
            dataObjForCD.setValue(dataObj.cOfficeLandPhone, forKey: "cOfficeLandPhone")
            dataObjForCD.setValue(dataObj.cDesignation, forKey: "cDesignation")
            dataObjForCD.setValue(dataObj.cBatchNO, forKey: "cBatchNO")
            dataObjForCD.setValue(dataObj.cJoiningDate, forKey: "cJoiningDate")
            dataObjForCD.setValue(dataObj.cGradationNumber, forKey: "cGradationNumber")
            dataObjForCD.setValue(dataObj.cServiceId, forKey: "cServiceId")
            dataObjForCD.setValue(dataObj.cDateOfBirth, forKey: "cDateOfBirth")
            dataObjForCD.setValue(dataObj.cHomeDistrict, forKey: "cHomeDistrict")
            dataObjForCD.setValue(dataObj.cBloodGroup, forKey: "cBloodGroup")
            dataObjForCD.setValue(dataObj.userFavoutiteKey, forKey: "userFavoutiteKey")
            do{
                try managedContext.save()
            }
            catch{
                print("Failed saving..")
            }
        }
        }
    }
    func downLoadImageForEachContact(cAllData: [CustomEntity]){
        var dataWithImage: [CustomEntity] = cAllData
        let dispatchGroup = DispatchGroup.init()
        for index in 0 ..< dataWithImage.count{
            if let url = URL(string: dataWithImage[index].cImageLink){
            dispatchGroup.enter()
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    //imageView.image = UIImage(data: data!)
                    dataWithImage[index].cImageData = data
                    dispatchGroup.leave()
                    }
                    
                }
            }
            }
        }
        dispatchGroup.notify(queue: .global()){
            print("async task finished")
            self.saveDataToCoreDB(dataObjectList: dataWithImage)
            self.finishAllAsyncTask()
        }
        //saveDataToCoreDB(dataObjectList: dataWithImage)
    }
    func receiveJsonResponseData(data: [CustomEntity]) {
        //Constants.allContactData = data// this data not included image
        // after finishing all task including image...
        downLoadImageForEachContact(cAllData: data)
    }
}








