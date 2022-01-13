//
//  ViewController.swift
//  Chat
//
//  Created by HENRY on 2021/11/12.
//

import UIKit
import FirebaseDatabase

class ChatViewController: BaseViewController{
    
    var chatTableViewModel : ChatTableViewModel!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldView: TextFieldAndSendView!
    
    var stickerCollectionViewModel : StickerCollectionViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var showSticker = false

    var friendModel : UserModel!
    
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableViewModel = ChatTableViewModel(tableView: tableView)
        chatTableViewModel.delegate = self
        stickerCollectionViewModel = StickerCollectionViewModel(collectionView: collectionView, friendModel: friendModel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tableView.addGestureRecognizer(tap)
        textFieldView.delegate = self
        requestAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
  
    
    func requestAPI(){
        title = friendModel.email
        chatTableViewModel.requestAPI(roomID: friendModel.roomId ?? "1")
        stickerCollectionViewModel.requestAPI()
    }
    @IBAction func selectedPhotoButtonPress(_ sender: UIButton) {
        let controller = UIImagePickerController()
              controller.sourceType = .photoLibrary
              controller.delegate = self
            present(controller, animated: true, completion: nil)
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
        showCollectionView(show: false)
    }
}

extension ChatViewController:TextFieldAndSendViewDelegate{
    func TextFieldAndSendViewSitckerButtonPress(TextFieldAndSendView: UIView, button: UIButton) {
       showCollectionView(show: !showSticker)
    }
    func showCollectionView(show: Bool){
        if show {self.collectionViewHeight.constant = UIScreen.main.bounds.height/4}
        else{self.collectionViewHeight.constant = 0}
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .beginFromCurrentState) {
            self.view.layoutIfNeeded()
        }
        showSticker = show
    }
    
    func TextFieldAndSendViewSendButtonPress(TextFieldAndSendView: UIView, button: UIButton) {
        guard let text =  textFieldView.chatTextField.text  else {return}
        let email = stickerCollectionViewModel.currentUserModel?.email

        chatTableViewModel.sendText(roomId: friendModel.roomId ?? "1", text: text, userModel: stickerCollectionViewModel.currentUserModel)
        textFieldView.chatTextField.text = ""

        textFieldView.chatTextField.resignFirstResponder()
        let model = NotificationModel(dict: stickerCollectionViewModel.currentUserModel?.toDict() ?? ["":""])
        MessageAPI.requestSendAPNS(friendID: friendModel.friendId, notification: NotificationData(body:  text , title: email ?? ""), targetUserModel: model)
    }
}
extension ChatViewController:StickerTableViewCellDelegate{
    func SitckerTableViewCellSelectedImageView(cell: UITableViewCell, imageView: UIImageView) {
        let controller = ImageViewerContoller()
        controller.imageView.image = imageView.image
        present(controller, animated: true, completion: nil)
    }
    
    
}

extension ChatViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       let image = info[.originalImage] as? UIImage
        let name = Date().description
        loadUI.showLoadUI()
        FIStorage.sharedInstance.uploadSticker(image: image, name: name) {
            [weak self] in
            self?.loadUI.stopLoadUI()
            let path = FIStorage.sharedInstance.stickerImagePath(name: name)
            let ref = FIStorage.sharedInstance.getRefPath(path: path)
            self?.stickerCollectionViewModel.sendSticker(imageRef: ref)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

