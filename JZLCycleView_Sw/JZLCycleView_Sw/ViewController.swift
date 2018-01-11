//
//  ViewController.swift
//  JZLCycleView_Sw
//
//  Created by allenjzl on 2018/1/10.
//  Copyright © 2018年 com.Woodpecker. All rights reserved.
//

import UIKit


class ViewController: UIViewController,JZLCycleViewDelagate {
    func selectedItemAtIndex(index: NSInteger) {
        print("点击了第%ld个",index)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let jzlCycleView: JZLCycleView = JZLCycleView.cycleViewWithFrame(frame: CGRect.init(x: 0, y: 64, width: 375, height: 200))
        jzlCycleView.delegate = self
        self.view.addSubview(jzlCycleView)
        jzlCycleView.imgArray = NSMutableArray.init(array: ["car1","car2","car3","car4"])
        
        
        
        
        let jzlCycleView2: JZLCycleView = JZLCycleView.cycleViewWithFrame(frame: CGRect.init(x: 0, y: 400, width: 375, height: 200), imgArray: NSArray.init(array: ["http://pic2.cxtuku.com/00/01/30/b5898506ee44.jpg","http://img4.duitang.com/uploads/blog/201306/08/20130608100514_HfKmk.thumb.600_0.jpeg","http://my.isself.com/upimg/user/30/20131117/13846939809150.jpg","http://img2.duitang.com/uploads/item/201208/07/20120807210311_ztEEM.thumb.600_0.jpeg"]))
        jzlCycleView2.delegate = self
        self.view.addSubview(jzlCycleView2)

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

