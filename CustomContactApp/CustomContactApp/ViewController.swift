//
//  ViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 3/21/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit
import MessageUI
class ViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var passCodeRequestTime: Date = Date()
    var isSentSMS = false
    let homeViewControllerIdentifier = "homeViewCntrollerStoryBoard"
    let randomNum = Int(arc4random_uniform(UInt32(Constants.userNameList.count)))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BJS Directory"
        self.userNameTextField.isUserInteractionEnabled = false
        self.userNameTextField.text = Constants.userNameList[randomNum]
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isSentSMS){
            self.showPassCodeGetterAlert()
        }
        
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        if(Constants.passwordList.count == 0){
            getPasswordList()
        }
        else{
            startLoginProcess()
        }

    }
    fileprivate func disableUI(){
        self.view.isUserInteractionEnabled = false
        self.loginButton.isUserInteractionEnabled = false
    }
    fileprivate func enableUI(){
        self.view.isUserInteractionEnabled = true
        self.loginButton.isUserInteractionEnabled = true
    }
    fileprivate func startLoginProcess(){
        let userNameString : String  = userNameTextField.text ?? ""
        let passwordString : String = passwordTextField.text ?? ""
        if(self.isTimeValid() && doesUserExist(userName: userNameString, password: passwordString) ){
            goToNextPage()
        }
        else{
            DispatchQueue.main.async {
                self.showErrorMessage()
                
            }
        }
    }
    fileprivate func getPasswordList(){
        if(Reachability.isConnectedToInternet()){
            let jsonObj = JsonResponseHandler()
            jsonObj.jsonResponsePasswordDelegate = self
            self.disableUI()
            jsonObj.getPasswordListFromUrl(urlString: Constants.jsonDataPasswordUrl)
        }
    }
    fileprivate func isTimeValid()-> Bool {
        let currentTime: Date = Date()
        let difference  = Int(currentTime.timeIntervalSince1970 - self.passCodeRequestTime.timeIntervalSince1970)
        let hours = difference/3600
        let minutes = (difference - (hours * 3600))/60
        if(hours > 0){
            return false
        }
        if(minutes > 15){
            return false
        }
        return true
    }
    fileprivate func showPassCodeGetterAlert(){
        let message = "For password you neeed to send Password Request SMS. Would you like to send SMS ?"
        let title = "Request for password"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"No", style: UIAlertActionStyle.destructive, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title:"Yes", style: UIAlertActionStyle.default, handler: { _ in
            self.passCodeRequestTime = Date()
            self.displayMessageInterface()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    fileprivate func displayMessageInterface(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [Constants.userNameList[randomNum]]
        composeVC.body = "Please send password for login BJS Direcory App."
        if MFMessageComposeViewController.canSendText(){
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    fileprivate func doesUserExist(userName: String, password : String)-> Bool{
        if(self.isUserNameExist() && self.isPasswordExist(userPassWord: password)){
            UserDefaults.standard.set(true, forKey: Constants.loginUserDefaultKey)
            if (UserDefaults.standard.object(forKey: Constants.favouriteListUserDefaultKey) == nil){
                let arr: [String] = []
                UserDefaults.standard.set(arr, forKey: Constants.designationUserDefaultKey)
            }
            
            return true
        }
        return false
    }
    
    fileprivate func isUserNameExist()-> Bool{
        return true
    }
    
    fileprivate func isPasswordExist(userPassWord: String)-> Bool{
        if Constants.passwordList.contains(userPassWord){
            return true
        }
        return false
    }
    
    fileprivate func goToNextPage(){
        let homePgaeVC = self.storyboard?.instantiateViewController(withIdentifier: homeViewControllerIdentifier)as! HomeViewController
        self.navigationController?.pushViewController(homePgaeVC, animated: true)
    }
    fileprivate func showErrorMessage(){
        // create the alert
        let alert = UIAlertController(title: "Try again!", message: "Username or Password not matched!", preferredStyle: .alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.showPassCodeGetterAlert()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            //print("sent")
            self.isSentSMS = true
            dismiss(animated: true, completion: nil)
        default:
            //print("default")
            self.isSentSMS = false
            dismiss(animated: true, completion: nil)
        }
    }
}
extension ViewController: JsonResponsePasswordProtocol{
    func receiveErrorMessage(errorMsg: String) {
        DispatchQueue.main.async {
            self.enableUI()
            self.showErrorMessage()
            
        }
    }
    
    func receivePasswordList(passwordList: [String]) {
        Constants.passwordList = passwordList
        DispatchQueue.main.async {
            self.startLoginProcess()
            self.enableUI()
        }
    }
    
    
}
