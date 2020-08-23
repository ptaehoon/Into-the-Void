//
//  SignUpAuth.swift
//  Into The Void
//
//  Created by David Lie-Tjauw on 2/15/20.
//  Copyright © 2020 Andrew Rochat. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import Firebase

class SignUpAuth: UIViewController {

    
//    @IBOutlet var username: UITextField!
    @IBOutlet var signUpEmail: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    
    @IBOutlet var playerName: UITextField!
    
//    var ref = Database.database().reference() //reference to firebase realtime database


  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SIGNUP VIEW LOADED");

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//    @IBAction func UserSignInClicked(_ sender: UIButton) {
//        if(userEmail.text! != "") && (userPassword.text! != ""){
//
//            let safeEmail:String = (userEmail.text!)
//            let safePassword:String = (userPassword.text!)
//
//            Auth.auth().signIn(withEmail: safeEmail, password: safePassword) { (authResult, error) in
//                if authResult?.user != nil{
//                    self.performSegue(withIdentifier: "gotologgedinview", sender: nil)
//                }
//                else{
//                    let errCode = AuthErrorCode(rawValue: error!._code)!.rawValue
//                    var errorMessage:String = ""
//                    if errCode == 17009 {
//                        errorMessage = "Password is invalid"
//                    }
//                    else if errCode == 17008 {
//                        errorMessage = "Please enter a valid email address"
//                    }
//                    else if errCode == 17011{
//                        errorMessage = "User account does not exist"
//                    }
//                    else if errCode == 17020 {
//                        errorMessage = "Please connect to wifi"
//                    }
//                    else {
//                        errorMessage = "Sign in error"
//                    }
//                    self.addAlert(alertMessage: errorMessage)
//                }
//            }
//
//        }
//        else{
//            self.addAlert(alertMessage: "Please complete all fields")
//        }
//    }
    
    // password must be 6 characters or longer
    // username must be a valid email format
//    @IBAction func SignUpButtonClicked(_ sender: UIButton) {
//                    
//        if (signUpEmail.text! != "") && (password.text! != "") && (playerName.text! != ""){
//        
//            
//            let safeEmail:String = (signUpEmail.text!)
//            let safePassword:String = (password.text!)
//            let safePlayerName:String = (playerName.text!)
//            
//            Auth.auth().createUser(withEmail: safeEmail, password: safePassword) { (authResult, error) in
//                
//                if authResult?.user != nil{
//                    //user successfully signs up!
//                    
//                    // create user node in firebase database
//                    
//                    var thing1 = safeEmail.replacingOccurrences(of: "@", with: "")
//                    var thing2 = thing1.replacingOccurrences(of: ".", with: "")
//                    
//                    self.ref.child("users").child(thing2).setValue(["playerName": safePlayerName])
//
//                    
//                    self.performSegue(withIdentifier: "gotologgedinview", sender: nil)
//                    
//                    
//                }
//                else{
//                    let errCode = AuthErrorCode(rawValue: error!._code)!.rawValue
//                    var errorMessage:String = ""
//                    if errCode == 17026 {
//                        errorMessage = "Password must be 6 characters long"
//                    }
//                    else if errCode == 17008 {
//                        errorMessage = "Please enter a valid email address"
//                    }
//                    else if errCode == 17007{
//                        errorMessage = "Email is already being used"
//                    }
//                    else if errCode == 17020 {
//                        errorMessage = "Please connect to wifi"
//                    }
//                    else {
//                        errorMessage = "Sign up error"
//                    }
////                    print(error)
//                    self.addAlert(alertMessage: errorMessage)
//                }
//                
//              
//            }
//        }
//        else{
//            print("nada");
//            addAlert(alertMessage: "Please enter email and password")
//        }
//    }
//    
//    func addAlert(alertMessage:String) {
//        let alert = UIAlertController(title: alertMessage, message: nil, preferredStyle: .alert)
//        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        
//        alert.addAction(okButton)
//        self.present(alert, animated: true, completion: nil)
//    }
}
