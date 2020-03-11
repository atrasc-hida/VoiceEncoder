//
//  CustomButton.swift
//  RecordingSample
//
//  Created by 飛田 由加 on 2020/03/11.
//  Copyright © 2020 atrasc. All rights reserved.
//

import Foundation
import UIKit

// カスタムボタン
class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStartAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEndAnimation()
    }
}

// MARK: - Private functions
extension CustomButton {
    
    //影付きのボタンの生成
    internal func commonInit(){
        self.layer.shadowOffset = CGSize(width: 2, height: 2 )
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = 5
    }
    
    //ボタンが押された時のアニメーション
    internal func touchStartAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
            self.alpha = 0.9
        },completion: nil)
    }
    
    //ボタンから手が離れた時のアニメーション
    internal func touchEndAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            self.alpha = 1
        },completion: nil)
    }
    
    // ボタンを非活性にする
    func disableButton(){
        self.isEnabled = false
        self.backgroundColor = UIColor.lightGray
        self.layer.shadowOpacity = 0
    }

    // ボタンを活性にする
    func enableButton() {
            self.isEnabled = true
            self.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            self.layer.shadowOpacity = 1
    }
}
