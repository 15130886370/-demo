//
//  TMHomeController.swift
//  EffectDemo
//
//  Created by ittmomWang on 16/6/12.
//  Copyright © 2016年 ittmomWang. All rights reserved.
//

import UIKit

class TMHomeController: UIViewController {

    @IBOutlet weak var titleScroll: UIScrollView!
    
    @IBOutlet weak var contentScroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false//关掉系统自动调节scrollView的位置
        
        //添加子控制器
        setUpChildVC()
        //添加子标题
        setUpTitle()
        //默认显示第o个控制器
        scrollViewDidEndScrollingAnimation(contentScroll)

    }

    private func setUpChildVC() {
        let vc1 = MyTableViewController()
        vc1.title = "国际"
        addChildViewController(vc1)
        let vc2 = MyTableViewController()
        vc2.title = "军事"
        addChildViewController(vc2)
        let vc3 = MyTableViewController()
        vc3.title = "社会"
        addChildViewController(vc3)
    }

    private func setUpTitle() {
        let labelWidth: CGFloat = UIScreen.main.bounds.width / 3
        
        for i in 0 ..< 3 {
            let title = UILabel(frame: CGRect(x: labelWidth * CGFloat(i), y: 0, width: labelWidth, height: 34))
            title.text = childViewControllers[i].title
            title.backgroundColor = UIColor.gray
            title.textAlignment = .center
            title.tag = 100 + i
            titleScroll.addSubview(title)
            title.isUserInteractionEnabled = true
            let guest = UITapGestureRecognizer.init(target: self, action: #selector(labelTap(tap:)))
            title.addGestureRecognizer(guest)
        }
        titleScroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)

        contentScroll.contentSize = CGSize(width: UIScreen.main.bounds.width * 7, height: 0)
        contentScroll.delegate = self
    }
    
    @objc func labelTap(tap: UITapGestureRecognizer) {
        let index = CGFloat((tap.view?.tag)! - 100)
        var offset: CGPoint = contentScroll.contentOffset
        let offsetX = UIScreen.main.bounds.width * index
        offset.x = offsetX
        
        contentScroll.setContentOffset(offset, animated: true)
    }
}

 // MARK: - UIScrollViewDelegate

extension TMHomeController: UIScrollViewDelegate {

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        let offsetX = scrollView.contentOffset.x
        let height = scrollView.frame.size.height
        let width = scrollView.frame.size.width

        let index = Int(offsetX / UIScreen.main.bounds.width)
        
        //设置标题滚动条随内容滚动而滚动
        var titleOffset = titleScroll.contentOffset
        let titleLabel = titleScroll.subviews[index] as! UILabel
        titleLabel.textColor = UIColor.red
        var titleOffsetX = titleLabel.frame.origin.x + titleLabel.frame.size.width * 0.5 - scrollView.frame.size.width * 0.5
        let maxTitleOffset = titleScroll.contentSize.width - width

        if titleOffsetX < 0 {
            titleOffsetX = 0
        }

        if titleOffsetX > maxTitleOffset {
            titleOffsetX = maxTitleOffset
        }

        titleOffset.x = titleOffsetX
        titleScroll.setContentOffset(titleOffset, animated: true)
        
        //修改中间title显示颜色不正确的bug
        for subLabel in titleScroll.subviews {
            if subLabel.isKind(of: UILabel.self) {
                let label = subLabel as! UILabel
                if label != titleLabel{
                    label.textColor = UIColor.black
                }
            }
        }
        let willShowVC = childViewControllers[index] as! MyTableViewController
        //如果控制器已经加载了,就不要再次计算frame了
        if willShowVC.isViewLoaded { return }

        willShowVC.view.frame = CGRect(x: offsetX, y: 100, width: width, height: height)
        
        scrollView.addSubview(willShowVC.view)
        
    }
    
    //用户手动滑动scrollView停止时候执行的方法
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
}

