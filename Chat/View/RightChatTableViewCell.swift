//
//  RightChatTableViewCell.swift
//  Chat
//
//  Created by HENRY on 2021/12/5.
//

import UIKit
import SnapKit
class RightChatTableViewCell: UITableViewCell {

    var bubbleImageView = UIImageView()
    
    let dateLabel = UILabel()
    var chatLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    func setupView(){
        selectionStyle = .none
        backgroundColor = .clear
        
        
        addSubview(bubbleImageView)
        addSubview(chatLabel)
        addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        rightChatType()
        bubbleImageView.snp.makeConstraints { make in
//            make.bottomMargin.equalTo(prfileImageView.snp.top)
            make.bottomMargin.equalTo(self)
            make.topMargin.equalTo(self)
//            make.leadingMargin.greaterThanOrEqualTo(self).inset(10)
//            make.leadingMargin.greaterThanOrEqualTo(dateLabel.snp.trailing).offset(10)
            make.rightMargin.equalTo(self)
        }

        chatLabel.numberOfLines = 0
        chatLabel.textAlignment = .right

        chatLabel.snp.makeConstraints { make in
            make.bottomMargin.equalTo(bubbleImageView).inset(10)
            make.topMargin.equalTo(bubbleImageView).inset(10)
            make.leadingMargin.equalTo(bubbleImageView).inset(10)
            make.rightMargin.equalTo(bubbleImageView).inset(17)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.greaterThanOrEqualTo(self).inset(10)
            make.trailing.equalTo(bubbleImageView.snp.leading)
//            make.width.equalTo(100)
        
        }
//        let interaction = UIContextMenuInteraction(delegate: self)
//        chatLabel.isUserInteractionEnabled = true
//        chatLabel.addInteraction(interaction)
    }
    func rightChatType(){
        changeImage("chat_bubble_sent")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
    }
    
    func leftChatType(){
        changeImage("chat_bubble_received")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_received")
    }
    
    func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        bubbleImageView.image = image
            .resizableImage(withCapInsets:
                                UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                    resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

}
extension RightChatTableViewCell:UIContextMenuInteractionDelegate{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration?{
        let copyAction = UIAction { action in
            UIPasteboard.general.string = self.chatLabel.text
        }
        copyAction.title = "copy"
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ _ in

            UIMenu(title: "", image: nil, identifier: nil, options: .destructive, children: [copyAction])
        }
    }
}
