//
//  JZLCycleView.swift
//  JZLCycleView_Swift
//
//  Created by allenjzl on 2018/1/9.
//  Copyright © 2018年 com.Woodpecker. All rights reserved.
//

import UIKit
import Kingfisher


class JZLCycleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:初始化方法
    class func cycleViewWithFrame(frame: CGRect) -> JZLCycleView {
        let cycleView = JZLCycleView.init(frame: frame)
        return cycleView
    }
    
   class func cycleViewWithFrame(frame:CGRect ,imgArray:NSArray) -> JZLCycleView {
        let cycleView = JZLCycleView.init(frame: frame)
        cycleView.imgArray = imgArray.mutableCopy() as! NSMutableArray
        return cycleView
    }
    
    //collectionView
    lazy var collectionView: UICollectionView = {
        let flowout = UICollectionViewFlowLayout.init()
        flowout.minimumLineSpacing = 0
        flowout.minimumInteritemSpacing = 0
        flowout.itemSize = CGSize.init(width: self.bounds.size.width, height: self.bounds.size.height)
        flowout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout: flowout)
        collectionView.register(JZLCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect.init(x: self.bounds.size.width / 2 - 50, y: self.bounds.size.height - 20, width: 100, height: 20))
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
    }()
    
    var index = NSInteger()
    var timer:Timer = Timer()
    var _imgArray = NSMutableArray()
    var imgArray: NSMutableArray {
        get {
            return _imgArray
        }
        set {
            _imgArray = newValue
            self.pageControl.numberOfPages = _imgArray.count
            self.timer.invalidate()
            self.addTimer()
            self.collectionView.reloadData()
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.timer.invalidate()
    }
 
}



// MARK:  UICollectionViewDelegate,UICollectionViewDataSource
extension JZLCycleView: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imgArray.count == 0 {
            return 1
        } else {
           return self.imgArray.count * 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:JZLCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! JZLCollectionViewCell
        if self.imgArray.count == 0 {
//            cell.imgView.image = nil
        } else {
            let img = self.imgArray[indexPath.item % self.imgArray.count]
            //本地图片
            if (img as AnyObject).isKind(of: UIImage.self) {
                cell.imgView.image = img as? UIImage
            }else {//图片url
                if (img as AnyObject).isKind(of: NSString.self) {
                    if (img as! NSString).hasPrefix("http"){
                        
                        cell.imgView.kf.setImage(with: ImageResource.init(downloadURL: NSURL.init(string: img as! String)! as URL))
                    }else {
                        cell.imgView.image = UIImage.init(named: img as! String)
                    }
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    

    // MARK:scrollViewDelagate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.index = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width) % self.imgArray.count
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
        if self.imgArray.count == 0 {
            return
        } else {
            //到第一组的最后一个,无动画滚动到中间一组的最后一个
            if self.index == self.imgArray.count - 1 {
                self.collectionView .scrollToItem(at: NSIndexPath.init(item: self.imgArray.count * 2 - 1, section: 0) as IndexPath , at:  UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
             //到最后一组的第一个,无动画滚动到中间一组的第一个
            if self.index == self.imgArray.count * 2 {
                self.collectionView .scrollToItem(at: NSIndexPath.init(item: self.imgArray.count, section: 0) as IndexPath , at:  UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    // MARK:添加定时器
    func addTimer() -> Void {
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                self.index += 1
                if self.imgArray.count == 0 {
                    return
                }else {
                    let indexPath = NSIndexPath.init(item: self.index, section: 0)
                    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                    if indexPath.item == self.imgArray.count * 2 {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            self.collectionView .scrollToItem(at: NSIndexPath.init(item: 4, section: 0) as IndexPath , at:  UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                        })
                    }
                    self.pageControl.currentPage = self.index % self.imgArray.count
                }
            })
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(automaticScrollCollectionCell), userInfo: nil, repeats: true)
        }
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
        
    }
    
    
    @objc func automaticScrollCollectionCell() -> Void {
        self.index += 1
        if self.imgArray.count == 0 {
            return
        }else {
            let indexPath = NSIndexPath.init(item: self.index, section: 0)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            if indexPath.item == self.imgArray.count * 2 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.collectionView .scrollToItem(at: NSIndexPath.init(item: 4, section: 0) as IndexPath , at:  UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                })
            }
            self.pageControl.currentPage = self.index % self.imgArray.count
        }
    }
    
    
    // MARK:删除定时器
    func removeTimer() -> Void {
        self.timer.invalidate()
    }

    
    
    
    
    
    
}










