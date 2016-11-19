//
//  EmoticonController.swift
//  EmoticonKeyBoard
//
//  Created by 莫清霆 on 2016/11/18.
//  Copyright © 2016年 莫清霆. All rights reserved.
//

import UIKit

fileprivate let EmoticonCell = "EmoticonCell"

class EmoticonController: UIViewController {
    
    //MARK:懒加载属性
    fileprivate lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar:UIToolbar = UIToolbar()
    
    
    //表情包管理
    fileprivate var manager = EmoticonManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

//MARK:设置界面UI
extension EmoticonController{
    
    fileprivate func setupUI(){
        //添加子控件
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.toolBar)
        self.collectionView.backgroundColor = UIColor.orange
        self.toolBar.backgroundColor = UIColor.darkGray
        
        //设置子空间的frame
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar":self.toolBar,"cView":self.collectionView] as [String : Any]
        
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //准备collectionView
        self.prepareForCollectionView()
        
        //准备toolbar
        self.prepareForToolBar()
        
        
        
    }
    
    
    
    ///准备工作
    fileprivate func prepareForCollectionView(){
        //创建cell
        self.collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier:EmoticonCell)
        
        self.collectionView.dataSource = self
        
    }
    
    ///准备工作
    fileprivate func prepareForToolBar(){
        //定义toolbar中titles
        let titles = ["最近","默认","emoji","浪小花"]
        
        //遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        
        for title in titles {
            let item  = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.itemClick(item:)))
            
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil))
        }
        
        //设置toolBar的iems 数组
        tempItems.removeLast()
        self.toolBar.items = tempItems
        self.toolBar.tintColor = UIColor.orange
        
        
    }
    
    @objc private func itemClick(item : UIBarButtonItem) {
        print(item.tag)
    }
    
}


//MARK:collectionView 数据源代理方法
extension EmoticonController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let package = manager.packages[section]
        print("表情数量:\(package.emoticons.count)")
        
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        
        //给cell设置数据
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.black : UIColor.brown
        
        print("indexPath.section : \(indexPath.section)")
        let packge = self.manager.packages[indexPath.section]
        print("packages : \(packge.emoticons.count)")
        let emoticon = packge.emoticons[indexPath.item]
        cell.emoticon = emoticon
        print(emoticon.description)
        
        return cell
    }
}


//MARK:表情键盘约束
class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        
        //设置layout 的属性
        self.itemSize = CGSize(width: itemWH, height: itemWH)
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
        
        //设置collectionView的属性
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = ((self.collectionView?.bounds.height)! - 3 * itemWH) / 2
        self.collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
        
    }
}
