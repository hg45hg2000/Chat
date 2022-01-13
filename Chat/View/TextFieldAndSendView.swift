//
//  TextFieldAndSendView.swift
//  Chat
//
//  Created by HENRY on 2021/11/15.
//

import UIKit
import FirebaseDatabase
protocol TextFieldAndSendViewDelegate : NSObjectProtocol{
    func TextFieldAndSendViewSendButtonPress(TextFieldAndSendView: UIView ,button: UIButton)
    func TextFieldAndSendViewSitckerButtonPress(TextFieldAndSendView: UIView ,button: UIButton)
}

class TextFieldAndSendView: UIView {

    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton : UIButton!
    @IBOutlet weak var stickerButton : UIButton!
    @IBOutlet weak var photoButton : UIButton!
    @IBOutlet weak var  stickerButtonWidth:NSLayoutConstraint!
    @IBOutlet weak var phptoButtonWidth:NSLayoutConstraint!
    weak var delegate : TextFieldAndSendViewDelegate?
    
    var editType : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextField.delegate = self
    }
    
    @IBAction func sendButtonPress(_ sender: UIButton) {
        self.delegate?.TextFieldAndSendViewSendButtonPress(TextFieldAndSendView: self, button: sender)
        
    }
    @IBAction func sitckerButtonPress(_ sender: UIButton) {
        self.delegate?.TextFieldAndSendViewSitckerButtonPress(TextFieldAndSendView: self, button: sender)
    }
    
    
}
extension TextFieldAndSendView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stickerButtonWidth.constant = 0
        phptoButtonWidth.constant = 0
        stickerButton.isHidden = true
        photoButton.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        stickerButtonWidth.constant = 60
        phptoButtonWidth.constant = 60
        stickerButton.isHidden = false
        photoButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
