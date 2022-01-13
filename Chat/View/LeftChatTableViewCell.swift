//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by HENRY on 2021/11/15.
//

import UIKit
import SnapKit

class LeftChatTableViewCell: UITableViewCell {

    var bubbleImageView = UIImageView()
    
    let profileImageView = UIImageView()
    
    var chatLabel = UILabel()
    
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(bubbleImageView)
        addSubview(chatLabel)
        addSubview(profileImageView)
        addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        profileImageView.snp.makeConstraints { make in
//            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(bubbleImageView.snp.leading)
            make.width.equalTo(profileImageView.snp.height).multipliedBy(1)
            make.width.equalTo(50)
        }
        profileImageView.backgroundColor = .gray
        leftChatType()
        bubbleImageView.snp.makeConstraints { make in
            make.bottomMargin.equalTo(profileImageView.snp.top)
            make.topMargin.equalTo(self)
//            make.leadingMargin.equalTo(self)
//            make.rightMargin.lessThanOrEqualTo(self).inset(10)
            make.rightMargin.lessThanOrEqualTo(dateLabel).inset(10)
        }
        chatLabel.numberOfLines = 0
        chatLabel.textAlignment = .left
        chatLabel.snp.makeConstraints { make in
            make.bottomMargin.equalTo(bubbleImageView).inset(10)
            make.topMargin.equalTo(bubbleImageView).inset(10)
            make.leadingMargin.equalTo(bubbleImageView).inset(17)
            make.rightMargin.equalTo(bubbleImageView).inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(bubbleImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(self).inset(10)
        }
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
