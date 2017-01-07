//
//  ItemDetailsVCViewController.swift
//  DreamLister
//
//  Created by YAUHENI IVANIUK on 1/7/17.
//  Copyright © 2017 YauheniIvaniuk. All rights reserved.
//

import UIKit

class ItemDetailsVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
        }

        
    }


 
}
