//
//  ProfileViewController.swift
//  Chat
//
//  Created by HENRY on 2021/11/25.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage
import FBSDKLoginKit

class ProfileViewController: BaseViewController {
    
    let friendTitleLabel = UILabel()
    
    let friendIdLabel = CopyLabel(frame: CGRect.zero)
    
    let logoutButton = UIButton(type: .custom)
    
    let profileImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.6)
            make.width.equalTo(75)
            make.height.equalTo(profileImageView.snp.width).multipliedBy(1.0)
        }
        profileImageView.backgroundColor = .gray
        profileImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectedPhoto))
        profileImageView.addGestureRecognizer(tap)
        
        view.addSubview(friendTitleLabel)
        friendTitleLabel.text = "Friend Id:"
        friendTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).multipliedBy(0.8)
        }
        
        view.addSubview(friendIdLabel)
        friendIdLabel.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        view.addSubview(logoutButton)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.setTitle("log out", for: .normal)
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).multipliedBy(1.3)
        }
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserAPI.requestCurrentUserModel { userModel in
            self.friendIdLabel.text = userModel.friendId
        }
//        profileImageView.sd_setImage(with: FIStorage.sharedInstance.getProfileImageRef(), placeholderImage: UIImage(named: "Portrait"))
        profileImageView.sd_setImage(with: FIStorage.sharedInstance.getProfileImageRef(), maxImageSize: 1*1024*1024, placeholderImage: UIImage(named: "Portrait"), options: .refreshCached, completion: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
    }
    
    @objc func selectedPhoto(){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    @objc func logOut(){
        do {
            try Auth.auth().signOut()
            LoginManager().logOut()
            MessageAPI.requestDeleteApnsToken()
            UserModel.deleteUid()
            checkLoginFlow(true)
        }catch{
            
        }
    }
}
extension ProfileViewController :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[.originalImage] as? UIImage
        FIStorage.sharedInstance.uploadProfileImage(image: image)
        profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
