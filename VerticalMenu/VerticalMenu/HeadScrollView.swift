//
//  HeadScrollView.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/26.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import Foundation
import UIKit
class HeadScrollView: UIView {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    var headScrollView: UIScrollView?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bringSubview(toFront: self.topView);

    
    
        self.topView.height = 105
        self.clipsToBounds = true;
        self.layer.masksToBounds = true
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        self.headScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        self.headScrollView?.contentInset = UIEdgeInsetsMake(231, 0, 0, 0)

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let point = change?[.newKey]
        self.updateSubViewWithScrollOffset(point as! CGPoint);


    }

    
    
    func updateSubViewWithScrollOffset(_ offset: CGPoint) {
        var newOffset = offset
        self.layoutIfNeeded()
         let bottomHeight =  -self.headScrollView!.contentInset.top
        
        let  y = (newOffset.y < bottomHeight) ? bottomHeight : (newOffset.y > -105 ? -105 : newOffset.y) //间距小于64选64， 高度大于两百四选两百四，之前选期间选高度值
        newOffset = CGPoint(x: newOffset.x, y: y)
        
        let newY = -newOffset.y - 231;
        let topBottomMargin = -105  - bottomHeight ;
        let alpha  =  1 - (newOffset.y - bottomHeight) / topBottomMargin
        
        self.frame = CGRect(x: 0, y: newY, width: self.frame.size.width, height: self.frame.size.height)
        
        self.topView.frame = CGRect(x: 0, y: -newY, width: self.frame.size.width, height: self.frame.size.height)
    
        
        print("topView.frame== %@  self.frame == %@   alpha = %f",topView.frame,self.frame,alpha)
        
        topView.alpha =  1 - alpha;
        bottomView.alpha = alpha ;
        
    
    }


}
