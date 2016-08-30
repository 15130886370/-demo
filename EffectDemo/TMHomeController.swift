//
//  TMHomeController.swift
//  EffectDemo
//
//  Created by ittmomWang on 16/6/12.
//  Copyright © 2016年 ittmomWang. All rights reserved.
//

import UIKit

public let SCREENW:CGFloat = UIScreen.mainScreen().bounds.width
public let SCREENH: CGFloat = UIScreen.mainScreen().bounds.height

class TMHomeController: UIViewController {

    
    @IBOutlet weak var titleScroll: UIScrollView!
    
    @IBOutlet weak var contentScroll: UIScrollView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false//关掉系统自动调节scrollView的位置
        
        //添加子控制器
        setUpChildVC()
        //添加子标题
        setUpTitle()
        //默认显示第o个控制器
        scrollViewDidEndScrollingAnimation(contentScroll)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpChildVC()
    {
        let vc1 = MyTableViewController()
        vc1.title = "国际"
        addChildViewController(vc1)
        let vc2 = MyTableViewController()
        vc2.title = "军事"
        addChildViewController(vc2)
        let vc3 = MyTableViewController()
        vc3.title = "社会"
        addChildViewController(vc3)
        let vc4 = MyTableViewController()
        vc4.title = "政治"
        addChildViewController(vc4)
        let vc5 = MyTableViewController()
        vc5.title = "经济"
        addChildViewController(vc5)
        let vc6 = MyTableViewController()
        vc6.title = "体育"
        addChildViewController(vc6)
        let vc7 = MyTableViewController()
        vc7.title = "娱乐"
        addChildViewController(vc7)
    }

    private func setUpTitle()
    {
        let labelWidth: CGFloat = 100.0
        
        for i in 0..<7
        {
            let title = UILabel(frame: CGRectMake(labelWidth * CGFloat(i), 0, labelWidth, 34))
            title.text = childViewControllers[i].title
            title.backgroundColor = UIColor.grayColor()
            title.textAlignment = .Center
            title.tag = 100 + i
            titleScroll.addSubview(title)
            title.userInteractionEnabled = true
            let guest = UITapGestureRecognizer.init(target: self, action: .labelTap)
            title.addGestureRecognizer(guest)
        }
        titleScroll.contentSize = CGSizeMake(100 * 7, 0)
        
        contentScroll.contentSize = CGSizeMake(SCREENW * 7, 0)
        contentScroll.delegate = self
    }
    
    func labelTap(tap: UITapGestureRecognizer)
    {
        let index = CGFloat((tap.view?.tag)! - 100)
        var offset: CGPoint = contentScroll.contentOffset
        let offsetX = SCREENW * index
        offset.x = offsetX
        
        contentScroll.setContentOffset(offset, animated: true)
    }
}

 //MARK: UIScrollViewDelegate

extension TMHomeController: UIScrollViewDelegate
{
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView)
    {
        let offsetX = scrollView.contentOffset.x
        let height = scrollView.frame.size.height
        let width = scrollView.frame.size.width
        
        
        let index = Int(offsetX / SCREENW)
        
        //设置标题滚动条随内容滚动而滚动
        var titleOffset = titleScroll.contentOffset
        let titleLabel = titleScroll.subviews[index] as! UILabel
        titleLabel.textColor = UIColor.redColor()
        var titleOffsetX = titleLabel.frame.origin.x + titleLabel.frame.size.width * 0.5 - scrollView.frame.size.width * 0.5
        let maxTitleOffset = titleScroll.contentSize.width - width
        if titleOffsetX < 0
        {
            titleOffsetX = 0
        }
        if titleOffsetX > maxTitleOffset
        {
            titleOffsetX = maxTitleOffset
        }
        titleOffset.x = titleOffsetX
        titleScroll.setContentOffset(titleOffset, animated: true)
        
        //修改中间title显示颜色不正确的bug
        for subLabel in titleScroll.subviews
        {
            if subLabel.isKindOfClass(UILabel){
                let label = subLabel as! UILabel
                if label != titleLabel{
                    label.textColor = UIColor.blackColor()
                }
            }
        }
        let willShowVC = childViewControllers[index] as! MyTableViewController
        //如果控制器已经加载了,就不要再次计算frame了
        if willShowVC.isViewLoaded(){return}

        willShowVC.view.frame = CGRectMake(offsetX, 0, width, height)
        
        scrollView.addSubview(willShowVC.view)
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let scale = scrollView.contentOffset.x/scrollView.frame.size.width
        
        let leftIndex = Int(scale)
        var rightIndex : Int = 0
        
        //滑动当前对应的前一个label和后一个label
        if leftIndex < 6 {
            rightIndex = leftIndex + 1
        }
        let leftLabel = titleScroll.subviews[leftIndex] as! UILabel
        let rightLabel = titleScroll.subviews[rightIndex] as! UILabel
        
        let rightScale = scale - CGFloat(leftIndex)
        let leftScale = 1 - rightScale
        
        //到达边界继续滚动的话直接返回,不做处理
        if scale < 1 || scale > 6 {return}
        
        leftLabel.textColor = UIColor.init(red: leftScale, green: 0, blue: 0, alpha: 1.0)
        rightLabel.textColor = UIColor.init(red: rightScale, green: 0, blue: 0, alpha: 1.0)
        
        debugPrint("左:\(leftScale),右:\(rightScale)")
        
    }
    
    //用户手动滑动scrollView停止时候执行的方法
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}


 //MARK: extension Selector

private extension Selector
{
    static let labelTap =  #selector(TMHomeController.labelTap(_:))
}


