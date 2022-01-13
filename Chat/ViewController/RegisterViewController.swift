//
//  RegisterViewController.swift
//  Chat
//
//  Created by HENRY on 2021/11/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var friendIDTextField: UITextField!
    
    var thridLogin = false
    var email : String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isHidden = thridLogin
        if thridLogin{
            emailTextField.text = email
            emailTextField.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        guard let friendId = self.friendIDTextField.text else {return}
        UserAPI.requestCheckFriendIdAvailable(friendId: friendId) { available in
            if available{
                self.createUserIntoFireStone()
            }else{
                UIAlertController.showAlert(in: self, withTitle: "FriendId 不能使用")
            }
        }
    }
    func saveLoginData(){
        let dict = [
            "email":self.self.emailTextField.text,
            "friendId":self.friendIDTextField.text,
            "uid" : Auth.auth().currentUser?.uid,
            "token": UserModel.getAPNSToken()
            
        ]
        UserModel.saveUid(uid: Auth.auth().currentUser?.uid)
        UserModel.saveUserDict(dict: dict as Dictionary<String, Any>)
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").setData(dict as [String : Any])
        self.dismiss(animated: true, completion: nil)
    }
    
    func createUserIntoFireStone(){
        if !thridLogin{
            if  emailTextField.text == "" || passwordTextField.text == "" ||
                    friendIDTextField.text == ""
            {
                return
            }else if friendIDTextField.text == "" {
                return
            }
            Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") {[weak self] authResult, error in
                guard error == nil else{return}
                self?.saveLoginData()
            }
        }else{
            self.saveLoginData()
        }
    }
}
