//
//  TestButton.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/5.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import Foundation
import UIKit
class TestButton: UIButton {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if  view == nil {
            return findView(view: self, point: point)
                
            }
        return view
    }
    
    
    
    func findView(view: UIView,point: CGPoint) -> XZRButton? {
         let p = view.convert(point, from: self);
        if view is XZRButton && view.bounds.contains(p){
            return view as? XZRButton
        } else {
            for subview in view.subviews {
                if let res = findView(view: subview, point: point) {
                    return res
                }
            }
        }
        return nil
    }
    
//    func getSubviewsOfView(v:UIView) -> XZRButton {
//        var zrButton:XZRButton?  = nil
//        
//        for subview in v.subviews {
//            zrButton =  getSubviewsOfView(v: subview)
//            let p = subview.convert(point, from: self);
//            if  subview.bounds.contains(p){
//                return subView;
//                
//            }
//            if subview is XZRButton {
//                circleArray.append(subview as! XZRButton)
//            }
//        }
//        
//        return circleArray
//    }
    
}
