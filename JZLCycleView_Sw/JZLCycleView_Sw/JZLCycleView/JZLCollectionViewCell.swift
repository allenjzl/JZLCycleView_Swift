//
//  JZLCollectionViewCell.swift
//  JZLCycleView_Swift
//
//  Created by allenjzl on 2018/1/9.
//  Copyright © 2018年 com.Woodpecker. All rights reserved.
//

import UIKit

class JZLCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView .addSubview(self.imgView)
        self.imgView.frame = CGRect.init(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView.init()
        return imgView
    }()
}
