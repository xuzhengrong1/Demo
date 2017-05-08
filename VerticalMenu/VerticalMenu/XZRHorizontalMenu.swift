//
//  ZR Horizontal.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/5.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import Foundation
import UIKit

public enum XZRActionType {
    case none, selector, closure
}


open class XZRButton: UIButton {
    var actionType = XZRActionType.none
    var target:AnyObject!
    var selector:Selector!
    var action:(()->Void)!
    var customBackgroundColor:UIColor?
    var customTextColor:UIColor?
    var initialTitle:String!
    var showDurationStatus:Bool=false
    var buttonTextFont = UIFont.systemFont(ofSize: 13)
    var splitLineColor:UIColor = UIColor.lightGray
    var drawSplitLine :Bool  = true
    
   
    public init() {
        super.init(frame: CGRect.zero)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    ///垂直分割线
    override open func draw(_ rect: CGRect) {
        
        if self.drawSplitLine {
            let splitLieColor = UIBezierPath()
            splitLieColor.move(to: CGPoint(x:self.width-1, y:5))
            splitLieColor.addLine(to: CGPoint(x:self.width-1 , y:self.height-5))
            splitLieColor.close()
            splitLineColor.set()
            splitLieColor.stroke()
            splitLieColor.fill()
        }
        
    }
    
    
   
}
public typealias DismissBlock = () -> Void
class XZRHorizontalMenu: UIView {
    var appearance: XZRHorizontalMenuAppearance = XZRHorizontalMenuAppearance()
//    var menuContentView: UIView = UIView()
    internal var buttons = [XZRButton]()
    let kTextExpandWidth:CGFloat = 20.0
    var dismissBlock : DismissBlock?
     var  memuWidth:CGFloat  = 0
     fileprivate var selfReference: XZRHorizontalMenu?
    public struct XZRHorizontalMenuAppearance {
        
        var kButtonHeight: CGFloat
        let kButtonFont: UIFont
        var contentViewCornerRadius : CGFloat
        var contentViewBackgroundColor:UIColor
        public init(kButtonHeight:CGFloat = 40 ,kButtonFont: UIFont = UIFont.systemFont(ofSize: 13), contentViewCornerRadius:CGFloat  = 6.0, contentViewBackgroundColor:UIColor = UIColor.red) {
            
            self.contentViewCornerRadius = contentViewCornerRadius;
            self.kButtonFont = kButtonFont
            self.kButtonHeight = kButtonHeight;
            self.contentViewBackgroundColor = contentViewBackgroundColor
        }
        mutating func setkButtonHeight(_ kButtonHeight:CGFloat) {
            self.kButtonHeight = kButtonHeight
        }
        
        
    }
    
    
    public init(appearance: XZRHorizontalMenuAppearance) {
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    func setup()  {
        self.layer.cornerRadius = appearance.contentViewCornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = appearance.contentViewBackgroundColor
    }
    
    @discardableResult
    open func addButton(_ title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool=false, action:@escaping ()->Void)->XZRButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = XZRActionType.closure
        btn.action = action
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    @discardableResult
    open func addButton(_ title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool = false, target:AnyObject, selector:Selector)->XZRButton {
        let btn = addButton(title, backgroundColor: backgroundColor, textColor: textColor, showDurationStatus: showDurationStatus)
        btn.actionType = XZRActionType.selector
        btn.target = target
        btn.selector = selector
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonTapped(_:)), for:.touchUpInside)
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonTapDown(_:)), for:[.touchDown, .touchDragEnter])
        btn.addTarget(self, action:#selector(XZRHorizontalMenu.buttonRelease(_:)), for:[.touchUpInside, .touchUpOutside, .touchCancel, .touchDragOutside] )
        return btn
    }
    
    @discardableResult
    fileprivate func addButton(_ title:String, backgroundColor:UIColor? = nil, textColor:UIColor? = nil, showDurationStatus:Bool=false)->XZRButton {
        appearance.setkButtonHeight(appearance.kButtonHeight);
        let btn = XZRButton()
        btn.layer.masksToBounds = true
        btn.setTitle(title, for: UIControlState())
        btn.titleLabel?.font = appearance.kButtonFont
        btn.customBackgroundColor = backgroundColor
        btn.customTextColor = textColor
        btn.initialTitle = title
        btn.width = title.widthOfString(usingFont: appearance.kButtonFont) + kTextExpandWidth
        self.addSubview(btn)
        buttons.append(btn)
        return btn
    }
    
    
    func buttonTapped(_ btn:XZRButton) {
        if btn.actionType == XZRActionType.closure {
            btn.action()
        } else if btn.actionType == XZRActionType.selector {
            let ctrl = UIControl()
            ctrl.sendAction(btn.selector, to:btn.target, for:nil)
        } else {
            print("Unknow action type for button")
        }
        
        if(self.alpha != 0.0){ hideView() }
    }
    
    
    
    
    func buttonTapDown(_ btn:XZRButton) {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        let pressBrightnessFactor = 0.85
        btn.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        brightness = brightness * CGFloat(pressBrightnessFactor)
        btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func buttonRelease(_ btn:XZRButton) {
        btn.backgroundColor = btn.customBackgroundColor
    
    }
    
    func showMenuInView(_ view:UIView)  {
        
        for subView in view.subviews {
            if subView is XZRHorizontalMenu {
                if subView.width > 0 {
                    UIView.animate(withDuration: 0.2, animations: {
                        subView.width = 0
                        subView.frame.origin.x = 0
                    });
                }else
                {
                    UIView.animate(withDuration: 0.2, animations: {
                        subView.width = self.memuWidth
                        subView.frame.origin.x = -self.memuWidth-5
                    });
                }
               
                return;
            }
        }
        selfReference = self
        memuWidth  = 0 //最大值
        self.centerY = view.centerY
         view.addSubview(self)
         for btn in self.buttons {
                btn.frame = CGRect(x:memuWidth, y:0, width:btn.width, height:self.appearance.kButtonHeight)
                memuWidth += btn.width
            }
         self.frame =  CGRect(x: -memuWidth-5 , y: view.height/2-self.appearance.kButtonHeight/2 , width: memuWidth, height: self.appearance.kButtonHeight)
         for btn in self.buttons {
                btn.y = 0
            }
        let toFrame = self.frame
        
        self.frame = CGRect(x: 0, y: toFrame.origin.y, width: 1, height: self.height)
        UIView.animate(withDuration: 0.3,animations: {
            self.frame = toFrame;
        })
        
    }
    override func layoutSubviews() {
        super.layoutSubviews() 
    }
    
    open func hideView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.width = 0
            self.frame.origin.x = 0
        });

    }
    open func destroyView()
{
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { finished in

            if(self.dismissBlock != nil) {
                self.dismissBlock!()
            }

            for button in self.buttons {
                button.action = nil
                button.target = nil
                button.selector = nil
            }
            self.selfReference = nil
            self.removeFromSuperview()
        })
    }
    
    
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
}
