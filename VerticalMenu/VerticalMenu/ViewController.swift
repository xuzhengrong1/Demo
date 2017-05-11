//
//  ViewController.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/5.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
       var  button = TestButton()
      let memu =  XZRHorizontalMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.frame = CGRect(x: 200, y: 100, width: 40, height: 120)
        button.backgroundColor = UIColor.red;
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.addSubview(button);
        
        memu.isUserInteractionEnabled = true
        memu.addButton("11", backgroundColor: UIColor.red, textColor: UIColor.white, showDurationStatus: false) {
            self.view.backgroundColor = UIColor.red;
        }
        
        memu.addButton("推荐11", target: self, selector: #selector(test))
//        memu.addButton("11", backgroundColor: UIColor.red, textColor: UIColor.white, showDurationStatus: false) {
//            
//        }
        let btn = memu.addButton("11", backgroundColor: UIColor.red, textColor: UIColor.white, showDurationStatus: false) {
            
        }
        let btn2 = memu.addButton("11", backgroundColor: UIColor.red, textColor: UIColor.white, showDurationStatus: false) {
            
        }
        
        let btn3 = memu.addButton("11", backgroundColor: UIColor.red, textColor: UIColor.white, showDurationStatus: false) {
            
        }
        btn.drawSplitLine = false

    }
    
    func tapped() {
                memu.showMenuInView(button);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
        
    }


}

