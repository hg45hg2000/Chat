//
//  LeftSitckerTableViewCell.swift
//  Chat
//
//  Created by HENRY on 2021/12/9.
//

import UIKit
import SnapKit
class LeftSitckerTableViewCell: UITableViewCell {
    let stickerImageView = UIImageView()
    let profileImageView = UIImageView()
    let dateLabel = UILabel()
    weak var delegate : StickerTableViewCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
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
    func setupView(){
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(stickerImageView)
        addSubview(profileImageView)
        addSubview(dateLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.bottom.equalTo(self)
            make.trailing.equalTo(stickerImageView.snp.leading)
            make.width.equalTo(profileImageView.snp.height).multipliedBy(1)
            make.width.equalTo(50)
        }
        profileImageView.image = UIImage(named: "Portrait")
        profileImageView.backgroundColor = .gray
        stickerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectedImageView))
        stickerImageView.addGestureRecognizer(tap)
        stickerImageView.contentMode = .scaleAspectFit
        stickerImageView.snp.makeConstraints { make in
//            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(200)
//            make.width.equalTo(stickerImageView.snp.height).multipliedBy(1)
        
        }
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textAlignment = .left
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(stickerImageView.snp.trailing).offset(10)
            make.trailing.equalTo(self)
        }
        
    }
    @objc func selectedImageView(){
        self.delegate?.SitckerTableViewCellSelectedImageView(cell: self, imageView: stickerImageView)
    }

}
