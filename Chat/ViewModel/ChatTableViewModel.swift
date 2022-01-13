//
//  ChatTableViewModel.swift
//  Chat
//
//  Created by HENRY on 2021/12/16.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage

class ChatTableViewModel:NSObject{
    var data : [ChatModel] = []
    weak var tableView : UITableView?
    weak var delegate : StickerTableViewCellDelegate?
    init(tableView : UITableView?){
        super.init()
        self.tableView = tableView
        setup()
    }
    func setup(){
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.separatorStyle = .none
        tableView?.register(UINib(nibName: "RightChatTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: RightChatTableViewCell.self))
        tableView?.register( LeftChatTableViewCell.self, forCellReuseIdentifier: String(describing: LeftChatTableViewCell.self))
        tableView?.register(UINib(nibName: "RightSitckerTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: RightSitckerTableViewCell.self))
        tableView?.register(UINib(nibName: "LeftSitckerTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: LeftSitckerTableViewCell.self))
    }
    func requestAPI(roomID: String){

        data = []
        tableView?.reloadData()
        let ref = Database.database().reference(withPath: roomID)
        ref.removeAllObservers()
        ref.observe(.childAdded) {[weak self] snapshot in
            if let dic = snapshot.value as? Dictionary<String, Any>{
                
                self?.data.append(ChatModel(dict: dic))
                let lastRow = IndexPath(row: (self?.data.count ?? 0) - 1, section: 0)
                self?.tableView?.insertRows(at: [lastRow], with: .none)
                self?.tableView?.scrollToRow(at: lastRow, at: .bottom, animated: true)
            }
        }
    }
    func sendText(roomId: String,text: String,userModel: UserModel?){
        let ref = Database.database().reference()
        let email = userModel?.email
        ref.child(roomId).childByAutoId().setValue(["email":email,
                                                    "text": text ,
                                                    "uid":userModel?.uid,
                                                    "date":Date().covertToString()])
    }
}
extension ChatTableViewModel:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userModel = data[indexPath.row]
        if userModel.uid == Auth.auth().currentUser?.uid{
            switch userModel.type{
            case .text(let text):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RightChatTableViewCell.self), for: indexPath)as! RightChatTableViewCell
                cell.chatLabel.text = text
                cell.dateLabel.text = userModel.date
                return cell
            case .image(let ref):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RightSitckerTableViewCell.self), for: indexPath) as! RightSitckerTableViewCell
                cell.stickerImageView.sd_setImage(with: ref)
                cell.dateLabel.text = userModel.date
                cell.delegate = delegate
                return cell
                
            }
        }else{
            switch userModel.type{
            case .text(let text):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LeftChatTableViewCell.self), for: indexPath) as!LeftChatTableViewCell
                cell.chatLabel.text = text
                cell.dateLabel.text = userModel.date
                cell.profileImageView.sd_setImage(with: FIStorage.sharedInstance.getEmailProfileRef(email: userModel.email), placeholderImage: UIImage(named: "Portrait"))
                return cell
            case .image(let ref):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LeftSitckerTableViewCell.self), for: indexPath) as! LeftSitckerTableViewCell
                cell.stickerImageView.sd_setImage(with: ref)
                cell.dateLabel.text = userModel.date
                cell.profileImageView.sd_setImage(with: FIStorage.sharedInstance.getEmailProfileRef(email: userModel.email), placeholderImage: UIImage(named: "Portrait"))
                cell.delegate = delegate
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch data[indexPath.row].type{
        case.text(_):
            return UITableView.automaticDimension
        case.image(_):
            return 150
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch data[indexPath.row].type{
        case.text(_):
            return UITableView.automaticDimension
        case.image(_):
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        let identifier = "\(index)" as NSString
        switch data[indexPath.row].type{
        case .text(_):
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil, actionProvider: { suggestedActions in
                let copyAction = UIAction(title: "copy", image: nil) { action in
                    if let cell = tableView.cellForRow(at: indexPath)as? LeftChatTableViewCell{
                        UIPasteboard.general.string = cell.chatLabel.text
                    }
                    if let cell = tableView.cellForRow(at: indexPath)as? RightChatTableViewCell{
                        UIPasteboard.general.string = cell.chatLabel.text
                    }
                        
                }
            return UIMenu(title: "", image: nil, children: [copyAction])
            })
        default:return nil
        }
    }
//    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
//
//        // Ensure we can get the expected identifier
//        guard let row = configuration.identifier as? String else { return nil }
//
//
//        // Get the cell for the index of the model
//        guard let cell = tableView.cellForRow(at: .init(row: Int(row) ?? 0, section: 0))  else { return nil }
//
//        // Since our preview has its own shape (a circle) we need to set the preview parameters
//        // backgroundColor to clear, or we'll see a white rect behind it.
//        let parameters = UIPreviewParameters()
//        parameters.backgroundColor = .clear
//
//        // Return a targeted preview using our cell previewView and parameters
//        return UITargetedPreview(view: cell, parameters: parameters)
//    }
}
