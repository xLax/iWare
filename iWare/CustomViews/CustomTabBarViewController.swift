//
//  CustomTabBarViewController.swift
//  iWare
//
//  Created by admin on 03/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    var tabBarIteam = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        let selectedImageAdd = UIImage(named: "Profile_white")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAdd = UIImage(named: "Profile_gray")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[0])!
        tabBarIteam.image = DeSelectedImageAdd
        tabBarIteam.selectedImage = selectedImageAdd
        
        let selectedImageAlert =  UIImage(named: "Alert_white")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageAlert = UIImage(named: "Alert_gray")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[1])!
        tabBarIteam.image = deselectedImageAlert
        tabBarIteam.selectedImage =  selectedImageAlert
        
        let selectedImageProfile =  UIImage(named: "Add_white")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageProfile = UIImage(named: "Add_gray")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[2])!
        tabBarIteam.image = deselectedImageProfile
        tabBarIteam.selectedImage = selectedImageProfile
        
        // selected tab background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , size: tabBarItemSize)
        
        // initaial tab bar index
        self.selectedIndex = 1
    }
}
