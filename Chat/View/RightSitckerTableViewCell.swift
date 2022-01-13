//
//  RightSitckerTableViewCell.swift
//  Chat
//
//  Created by HENRY on 2021/12/9.
//

import UIKit
import SnapKit
protocol StickerTableViewCellDelegate :NSObjectProtocol{
    func SitckerTableViewCellSelectedImageView(cell: UITableViewCell ,imageView : UIImageView)
}

class RightSitckerTableViewCell: UITableViewCell {
    let stickerImageView = UIImageView()
    let dateLabel = UILabel()
    weak var delegate : StickerTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func selectedSticker(){
        self.delegate?.SitckerTableViewCellSelectedImageView(cell: self, imageView: stickerImageView)
    }
    func setupView(){
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(stickerImageView)
        addSubview(dateLabel)
        stickerImageView.snp.makeConstraints { make in
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(200)
//            make.width.equalTo(stickerImageView.snp.height).multipliedBy(1)
        
        }

        stickerImageView.contentMode = .scaleAspectFit
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textAlignment = .right
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.trailing.equalTo(stickerImageView.snp.leading)
            make.leading.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectedSticker))
        stickerImageView.isUserInteractionEnabled = true
        stickerImageView.addGestureRecognizer(tap)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected , stickerImageView.isDescendant(of: self){
//            self.delegate?.SitckerTableViewCellSelectedImageView(cell: self, imageView: stickerImageView)
//        }
        // Configure the view for the selected state
    }

}
