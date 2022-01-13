//
//  StickerCollectionViewModel.swift
//  Chat
//
//  Created by HENRY on 2021/12/16.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage
class StickerCollectionViewModel:NSObject{
    
    weak var collectionView : UICollectionView?
    var refImageList :[StorageReference] = []
    var currentUserModel : UserModel?
    var friendModel : UserModel!
    
     init(collectionView: UICollectionView?,friendModel : UserModel) {
        super.init()
        self.collectionView = collectionView
        self.friendModel = friendModel
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
    }
    func requestAPI(){

        UserAPI.requestCurrentUserModel {[weak self] userModel in
            self?.currentUserModel = userModel
            self?.currentUserModel?.roomId = self?.friendModel.roomId
        }
        FIStorage.sharedInstance.downloadImage {[weak self] referenceList in
            self?.refImageList = referenceList
            self?.collectionView?.reloadData()
        }
    }
}
extension StickerCollectionViewModel:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return refImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as! ImageCollectionViewCell
        cell.imageView.sd_setImage(with: refImageList[indexPath.row], placeholderImage: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        sendSticker(imageRef: refImageList[indexPath.row])
        
    }
    
    
    func sendSticker(imageRef: StorageReference){
        let ref = Database.database().reference()
        let email = currentUserModel?.email
        ref.child(friendModel.roomId ?? "1").childByAutoId().setValue(["email":email,
                                                                       "image":imageRef.fullPath,
                                                    "uid":currentUserModel?.uid,
                                                                       "date":Date().covertToString()] )
        imageRef.downloadURL { url, error in
            guard error == nil else{return}
            let urlString = url?.absoluteString
            let model = NotificationModel(dict: self.currentUserModel?.toDict() ?? ["":""])
            model.imageUrl = urlString
            MessageAPI.requestSendAPNS(friendID: self.friendModel.friendId, notification: NotificationData(body: "New Sticker", title: email ?? "",imageUrl: urlString), targetUserModel: model)
        }
        
    }
    
    
}
extension StickerCollectionViewModel: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenBounds = UIScreen.main.bounds
            return CGSize(width: screenBounds.width/3, height: screenBounds.height/8)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView, layout
            collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    }
