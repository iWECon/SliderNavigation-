//
//  ViewController.swift
//  SliderNavigation
//
//  Created by iWe on 16/4/9.
//  Copyright © 2016年 iWe. All rights reserved.
//

/*
 类知乎首页
 圆角矩形app

 上滑缩小导航栏
 下滑还原导航栏
*/


import UIKit

class ViewController: UIViewController {
    
    
    lazy var tableView: UITableView = {
        let screen_frame = UIScreen.mainScreen().bounds
        let rootTableView = UITableView(frame: screen_frame, style: .Plain)
        
        rootTableView.tableFooterView = UIView()
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 下划线重置为0 -> 左边不留空隙
        rootTableView.separatorInset = UIEdgeInsetsZero
        rootTableView.layoutMargins = UIEdgeInsetsZero
        
        return rootTableView
    }()
    
    
    lazy var navView : UIView = {
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64))
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return view
    }()
    
    
    lazy var tableViewData : NSArray = {
        return NSArray(array: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    }()
    
    
    var previousOffsetY : CGFloat = -64
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let radius: CGFloat = 5
        
        navigationController!.view.layer.cornerRadius = radius
        navigationController!.view.layer.masksToBounds = true
        
        tabBarController!.view.layer.cornerRadius = radius
        tabBarController!.view.layer.masksToBounds = true
        
        emptyNavigationBar()
        
        self.view.addSubview(tableView)
    }
    
    
    func emptyNavigationBar() {
        
        // 置空 导航栏背景
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        
        // 置空 导航栏分割线
        navigationController!.navigationBar.shadowImage = UIImage()
        
        // 自定义UIView
        navigationController!.view.insertSubview(navView, atIndex: 1)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        // ! 表示一定存在, 如果不存在 值为nil则程序崩溃
        
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.text = "\(tableViewData[indexPath.row])"
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(tableView.cellForRowAtIndexPath(indexPath)?.frame)
    }
    
}



// tableView 继承自ScrollView, 所以也有scrollView的委托协议
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        // < 向下拉动  > 向上拉动
        if previousOffsetY <= offsetY {
            
            if navView.frame.origin.y <= -44 {
                
                navView.frame.origin.y = -44
            } else {
                
                navView.frame.origin.y = -(offsetY + 64);
            }
            
        } else {
            
            if navView.frame.origin.y >= 0 {
                
                navView.frame.origin.y = 0
                
            } else {
                
                navView.frame.origin.y = navView.frame.origin.y - (offsetY - previousOffsetY);
                
            }
            
        }
        
        
        // 判断是否滚动到最顶部, 防止回弹效果
        if offsetY <= -64 {
            navView.frame.origin.y = 0
        }
        
        
        let currentOffset = offsetY + scrollView.bounds.height - scrollView.contentInset.bottom
        
        let maximumOffset = scrollView.contentSize.height
        // 判断是否滚动到最底部, 防止回弹效果
        if currentOffset >= maximumOffset {
            
            navView.frame.origin.y = -44
        }
        
        
        previousOffsetY = offsetY
    }
    
    
    
}






