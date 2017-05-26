//
//  ViewController.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/5.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
       var  button = TestButton()
      let memu =  XZRHorizontalMenu()
    
    var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self;
                tableView?.register( UITableViewCell.self, forCellReuseIdentifier: "cell")
       let View =  UINib(nibName: "HeadScrollView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeadScrollView
        View.frame = CGRect(x: 0, y: 0, width: self.view.size.width, height: 231);
         View.headScrollView = tableView;
        self.view.addSubview(View);
        self.view.addSubview(tableView!)
    
        self.view.bringSubview(toFront: View)

        
        
    

    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 ;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 ;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
       cell.textLabel?.text = "111";
        return cell
        
    }
    
    
    func tapped() {
       
        
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
        
        let pick =  CustomDatePickerView(frame: CGRect(x: 0, y: 100, width: self.view.size.width, height:300))
        
        self.view.addSubview(pick)
                memu.showMenuInView(button);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
        
    }


}

