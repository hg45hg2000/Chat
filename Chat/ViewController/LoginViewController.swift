//
//  RegisterViewController.swift
//  Chat
//
//  Created by HENRY on 2021/11/16.
//

import UIKit
import FirebaseFirestore
import Firebase
import FBSDKLoginKit
import FirebaseAuth
import SnapKit
import CryptoKit
import AuthenticationServices

class LoginViewController: BaseViewController{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
//    let loginButton = UIButton()
    let loginButton = FBLoginButton()
    let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    var currentNonce = ""
    fileprivate var appleCurrentNonce: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appleButton)
        // Do any additional setup after loading the view.
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerY.equalTo(view).multipliedBy(1.5)
            make.centerX.equalTo(view).multipliedBy(1.0)
            make.width.equalTo(250)
            make.height.equalTo(30)
        }
        appleButton.snp.makeConstraints { make in
            make.centerY.equalTo(view).multipliedBy(1.6)
            make.centerX.equalTo(view).multipliedBy(1.0)
            make.width.equalTo(250)
            make.height.equalTo(30)
        }
        
        appleButton.cornerRadius = 8.0
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
        let nonce = String.randomNonceString()
        currentNonce = nonce
        loginButton.delegate = self
        loginButton.loginTracking = .limited
        loginButton.nonce = String.sha256(nonce)
        loginButton.permissions = ["public_profile", "email"]
//        loginButton.addTarget(self, action: #selector(fbLogin), for: .touchUpInside)
        
    }
//    @objc func fbLogin(){
//        LoginManager().logIn(permissions: ["public_profile", "email"], from:self) { result, error in
//            let credential = FacebookAuthProvider
//              .credential(withAccessToken: AccessToken.current!.tokenString)
//              self.signIn(credential: credential)
//        }
//    }
    
    @IBAction func loginButtonPress(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let e = error{
                print(e)
            }else{
                if let uid = authResult?.user.uid{
                    strongSelf.createUserIntoFireStone(uid: uid)
                }
            }
        }
    }
    func createUserIntoFireStone(uid: String){
        UserModel.saveUid(uid: uid)
        dismiss(animated: true, completion: nil)
    }
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = String.randomNonceString()
      appleCurrentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        request.nonce = String.sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
}
extension LoginViewController : LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            UIAlertController.showAlert(in: self, withTitle: error.localizedDescription)
            return
        }
        // ...
        // Initialize a Firebase credential.
        let idTokenString = AuthenticationToken.current?.tokenString
        let nonce = currentNonce
        let credential = OAuthProvider.credential(withProviderID: "facebook.com",
                                                  idToken: idTokenString!,
                                                  rawNonce: nonce)
        
        signIn(credential: credential)
    }
    func signIn(credential: AuthCredential){
        Auth.auth().signIn(with: credential) {[weak self] authResult, error in
            if let error = error {
                UIAlertController.showAlert(in: self, withTitle: error.localizedDescription)
                return
            }

            self?.checkUid(uid: authResult?.user.uid, email: authResult?.user.email)
        }
    }
    func checkUid(uid: String?,email: String?){
        guard let uid = uid else {
            return
        }
        UserAPI.requestCheckRegisted(uid) { Registed in
            DispatchQueue.main.async {
                if Registed{
                    UserModel.saveUid(uid: Auth.auth().currentUser?.uid)
                    MessageAPI.requestSaveApnsToken(token: UserModel.getAPNSToken())
                    self.dismiss(animated: true, completion: nil)
                }else{
                    let rg = UIViewController.mainStoryBoard().instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                    rg.thridLogin = true
                    rg.email = email
                    self.navigationController?.pushViewController(rg, animated: true)
                }
            }
        }
    }
}
@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate ,ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIApplication.shared.windows.first!
    }
    

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = appleCurrentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
              print(error?.localizedDescription)
          return
        }
          self.checkUid(uid:Auth.auth().currentUser?.uid, email: authResult?.user.email)
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
