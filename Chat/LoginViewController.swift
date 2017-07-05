//
//  LoginViewController.swift
//  Chat
//
//  Created by iOS on 7/3/17.
//  Copyright © 2017 Spencer Wallsworth. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, LoginViewModelDelegate, WarningDelegate{


    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var verifyPasswordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userLoginModeSelection: UISegmentedControl!
    
    
    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        loginViewModel = LoginViewModel()
        if let viewModel = loginViewModel{
            viewModel.delegate = self
        }
        updateAccountLoginDisplay()
        //testing only get rid of later
        emailTextField.text = "spencer.wallsworth@gmail.com"
        passwordTextField.text = "treeman"
        verifyPasswordTextField.text = "treeman"
        //end
        super.viewDidLoad()


        
    }
    override func viewDidAppear(_ animated: Bool) {
        verifyPasswordTextField.isHidden = !isLoggingIn()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Mark: LoginViewModelDelegate functions
    func invalidLogin(message:String){
        showWarning(message: message)
    }
    func invalidAccountCreation(message:String){
        showWarning(message: message)
    }
    func errorSigningingOut(message: String) {
        showWarning(message: message)
    }
    func validLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //ChatViewCroller
        let vc = storyboard.instantiateViewController(withIdentifier: "UserAccountVC") as! ChatViewController
        vc.email = emailTextField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func selectUserLoginMode(_ sender: UISegmentedControl) {
        updateAccountLoginDisplay()
    }
    

    @IBAction func login(_ sender: Any) {
        if isLoggingIn(){
            loginViewModel?.login(email: emailTextField.text!, password: passwordTextField.text!)
        }else{
            loginViewModel?.createAccount(username: usernameTextField.text!, email: emailTextField.text!, password1: passwordTextField.text!, password2: verifyPasswordTextField.text!)
        }
    }
    
    
    
   
    
    func isLoggingIn()->Bool{
        return userLoginModeSelection.selectedSegmentIndex == 0
    }
    
    func updateAccountLoginDisplay(){
        verifyPasswordTextField.isHidden = isLoggingIn()
        verifyPasswordLabel.isHidden = isLoggingIn()
        usernameLabel.isHidden = isLoggingIn()
        usernameTextField.isHidden = isLoggingIn()
        if isLoggingIn(){
            titleLabel.text = "Please Signin"
        }else{
            titleLabel.text = "Create an Account"
        }
    }
    //This does nothing
    func updateView() {}

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
