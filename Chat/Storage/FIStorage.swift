//
//  Storage.swift
//  Chat
//
//  Created by HENRY on 2021/12/15.
//

import Foundation
import FirebaseStorage
import UIKit

class FIStorage{
    let storage = Storage.storage(url: "gs://login-4c196.appspot.com")
    static var sharedInstance = FIStorage()

    private func prfoileImagePath(name:String)->String{
        return "prfolie" + "/" + name.appending(".jpg")
    }
     func stickerImagePath(name:String)->String{
        return "sticker" + "/" + name.appending(".jpg")
    }
    
    func getRefPath(path: String)->StorageReference{
        return storage.reference().child(path)
    }
    
    func downloadImage(completeion:@escaping(_ referenceList:[StorageReference])->Void){
        let storageReference = storage.reference().child("image")
        storageReference.listAll { (result, error) in
            if error != nil {
            // ...
          }
            completeion(result.items)
        }
    }
    func uploadProfileImage(image: UIImage?){
        if let imageJPEG = image?.jpegData(compressionQuality: 0.0001){
            let imageRef = storage.reference().child(prfoileImagePath(name: UserDataManager.sharedInstance.currentUserModel?.email ?? ""))
            let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                imageRef.putData(imageJPEG, metadata: metadata) { metadata, error in
                
            }
        }
    }
    func uploadSticker(image: UIImage?,name: String,completeion:@escaping()->Void){
        if let imageJPEG = image?.jpegData(compressionQuality: 0.0001){
            let imageRef = storage.reference().child(stickerImagePath(name: name))
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
                imageRef.putData(imageJPEG, metadata: metadata) { metadata, error in
                completeion()
            }
        }
    }
    
    func getEmailProfileRef(email:String)->StorageReference{
        return storage.reference().child(prfoileImagePath(name: email))
    }
    
    func getProfileImageRef()->StorageReference{
        let imageRef = storage.reference().child(prfoileImagePath(name: UserDataManager.sharedInstance.currentUserModel?.email ?? ""))
        return imageRef
    }
}
