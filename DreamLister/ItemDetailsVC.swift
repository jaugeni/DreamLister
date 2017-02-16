//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by YAUHENI IVANIUK on 1/7/17.
//  Copyright © 2017 YauheniIvaniuk. All rights reserved.
//

import UIKit
import CoreData


class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var storePicker:UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumImg: UIImageView!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var typeItemLbl: UILabel!
    
    
    var stores = [Store]()
    var types = [ItemType]()
    
    var pickerViewData = [[String](), [String]()]
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
//                let store = Store(context: context)
//                store.name = "Best Buy"
//                let store2 = Store(context: context)
//                store2.name = "Snowboarding store"
//                let store3 = Store(context: context)
//                store3.name = "Car Seller"
//                let store4 = Store(context: context)
//                store4.name = "Target"
//                let store5 = Store(context: context)
//                store5.name = "Amazon"
//                let store6 = Store(context: context)
//                store6.name = "Mall"
//        
//        
//                let itemType = ItemType(context: context)
//                itemType.type = "Electronic"
//                let itemType2 = ItemType(context: context)
//                itemType2.type = "For House"
//                let itemType3 = ItemType(context: context)
//                itemType3.type = "Snowboarding"
//        
//                ad.saveContext()
        
        getStores()
        
        for store in stores {
            pickerViewData[0].append(store.name!)
        }
        
        for type in types {
            pickerViewData[1].append(type.type!)
        }

        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        priceField.resignFirstResponder()
        detailsField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return pickerViewData[component][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerViewData[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            storeLbl.text = pickerViewData[0][row]
        } else {
            typeItemLbl.text = pickerViewData[1][row]
        }
        
    }
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let fetchRequestTypes: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do{
            
            self.stores = try context.fetch(fetchRequest)
            self.types = try context.fetch(fetchRequestTypes)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            //handle error
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumImg.image
        
        if itemToEdit == nil {
            
            item = Item(context: context)
            
        } else {
            
            item = itemToEdit
            
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title  = title
            
        }
        
        if let price = priceField.text {
            
            item.price = (price as NSString).doubleValue
            
        }
        
        if let details = detailsField.text {
            
            item.details = details
            
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while (index < stores.count)
                storeLbl.text = store.name
            }
            
            
            
            if let item = item.toItemType {
                
                var index = 0
                repeat {
                    let  i = types[index]
                    if i.type == item.type {
                        
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                } while (index < types.count)
                typeItemLbl.text = item.type
            }
           
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
