//
//  HomeVC.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import UIKit
import Foundation
import CoreData

class HomeVC: UIViewController {
    @IBOutlet weak var viewHeader: UIView!{
        didSet{
            viewHeader.addShadow(offset: CGSize(width: 0, height: -2), color: AppColors.lightgray, radius: 4, opacity: 0.6)
        }
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCartCount: UILabel! {
        didSet {
            lblCartCount.layer.cornerRadius = lblCartCount.frame.size.height/2
            lblCartCount.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var btnCart: UIButton! {
        didSet {
            btnCart.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var tblProduct: UITableView!
    @IBOutlet weak var btnLogout: UIButton! {
        didSet {
            btnLogout.setTitle("", for: .normal)
        }
    }
    
    var arrProduct = [productdata]()
    var userId = 0
    var cartItem = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = UserDefaults.standard.object(forKey: "user_id") as? Int ?? 0
        lblName.text = " Hello \(UserDefaults.standard.object(forKey: "user_name") as? String ?? "")"
        tblProduct.register(UINib(nibName: "ProductTC", bundle: nil), forCellReuseIdentifier: "ProductTC")
        
        getProductData()
    }
    
    static var storyboardInstance:HomeVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: HomeVC.identifier) as! HomeVC
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "user_id")
        UserDefaults.standard.set(nil, forKey: "user_name")
        UserDefaults.standard.synchronize()
        self.navigationController?.pushViewController(LoginVC.storyboardInstance, animated: false)
    }
    
    @IBAction func btnCartAction(_ sender: Any) {
        
    }
    
    
    //MARK: API call
    func getProductData() {
        ServerAPIs.getRequest { response, error, statusCode in
            if statusCode == 200 {
                print("sucesss..",response)
                
                do {
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: response.rawData(), options: []) as? [[String: Any]] {
                        print(jsonDictionary)
                        self.arrProduct.append(contentsOf: jsonDictionary.map({productdata(dict: $0 as! [String:Any])}))
                        self.tblProduct.reloadData()
                        print("????????????????",self.arrProduct.count)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2) {
                            self.fatchAllFavproduct()
                            
                            self.fetchCartItems()
                            
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
               
            }else {
                print(error)
            }
        }
    }
    
    //MARK: coredata
    
  
    
    func fatchAllFavproduct() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favaorite")
        let userPredicate = NSPredicate(format: "userId == %@", "\(userId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate])
        
                do {
                    let results = try managedContext.fetch(fetchRequest)
                    var arrfavProduct = [Int]()
                    for case let favoriteProduct as NSManagedObject in results {
                        if let productId = favoriteProduct.value(forKey: "productId") as? Int {
                            arrfavProduct.append(productId)
                        }
                    }
                    for (index, item) in self.arrProduct.enumerated() {
                        if arrfavProduct.contains(item.id) {
                            arrProduct[index].isFav = true
                        }
                    }
                    self.tblProduct.reloadData()
                } catch let error as NSError {
                    print("Error retrieving favorite products: \(error), \(error.userInfo)")
                }
    }
    
    func createFavoriteProduct(productId: Int,index:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let favoriteProductEntity = NSEntityDescription.entity(forEntityName: "Favaorite", in: managedContext) else {
                    print("Failed to retrieve FavoriteProduct entity description")
                    return
                }
                
                let favoriteProduct = NSManagedObject(entity: favoriteProductEntity, insertInto: managedContext)
                favoriteProduct.setValue(userId, forKey: "userId")
                favoriteProduct.setValue(productId, forKey: "productId")
                
                do {
                    try managedContext.save()
                    print("Product favorited successfully")
                    self.arrProduct[index].isFav = true
                    self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                } catch let error as NSError {
                    print("Failed to favorite product: \(error), \(error.userInfo)")
                }
        }
    
    func unfavoriteProduct(productId: Int,index:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favaorite")
        let userPredicate = NSPredicate(format: "userId == %@", "\(userId)")
        let productPredicate = NSPredicate(format: "productId == %@", "\(productId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, productPredicate])
        
            
            do {
                if let favoriteProduct = try managedContext.fetch(fetchRequest).first as? NSManagedObject {
                    managedContext.delete(favoriteProduct)
                    do {
                        try managedContext.save()
                        self.arrProduct[index].isFav = false
                        self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        print("Product unfavorited successfully")
                    } catch let error as NSError {
                        print("Failed to unfavorite product: \(error), \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("Error unfavoriting product: \(error), \(error.userInfo)")
            }
        }
    
    func fetchCartItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let userPredicate = NSPredicate(format: "userId == %@", "\(userId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate])
            
        self.cartItem = 0
            do {
                let results = try managedContext.fetch(fetchRequest)
                for case let cartItem as NSManagedObject in results {
                    if let productId = cartItem.value(forKey: "productId") as? Int,
                       let quantity = cartItem.value(forKey: "quantity") as? Int {
                        if let index = self.arrProduct.firstIndex(where: { $0.id == productId }) {
                            self.arrProduct[index].cartcount = quantity
                            self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                            
                            self.cartItem += quantity
                        }
                    }
                    
                    lblCartCount.text = "\(self.cartItem)"
                }
            } catch let error as NSError {
                print("Error fetching cart items: \(error), \(error.userInfo)")
            }
        }
    
    func addToCart(productId: Int, quantity: Int,index:Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
            guard let cartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: managedContext) else {
                print("Failed to retrieve Cart entity description")
                return
            }
            
            let cartItem = NSManagedObject(entity: cartEntity, insertInto: managedContext)
            cartItem.setValue(productId, forKey: "productId")
            cartItem.setValue(userId, forKey: "userId")
            cartItem.setValue(quantity, forKey: "quantity")
            
            do {
                try managedContext.save()
                print("Product added to cart successfully")
                self.arrProduct[index].cartcount = quantity
                self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } catch let error as NSError {
                print("Failed to add product to cart: \(error), \(error.userInfo)")
            }
        }
    
    func removeFromCart(productId: Int,index:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let userPredicate = NSPredicate(format: "userId == %@", "\(userId)")
        let productPredicate = NSPredicate(format: "productId == %@", "\(productId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, productPredicate])
            
            do {
                if let cartItem = try managedContext.fetch(fetchRequest).first as? NSManagedObject {
                    managedContext.delete(cartItem)
                    
                    do {
                        try managedContext.save()
                        print("Product removed from cart successfully")
                        self.arrProduct[index].cartcount = 00
                        self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    } catch let error as NSError {
                        print("Failed to remove product from cart: \(error), \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("Error removing product from cart: \(error), \(error.userInfo)")
            }
        }
    
    
    func updateQuantity(productId: Int, newQuantity: Int,index:Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let userPredicate = NSPredicate(format: "userId == %@", "\(userId)")
        let productPredicate = NSPredicate(format: "productId == %@", "\(productId)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, productPredicate])
            
            do {
                if let cartItem = try managedContext.fetch(fetchRequest).first as? NSManagedObject {
                    cartItem.setValue(newQuantity, forKey: "quantity")
                    
                    do {
                        try managedContext.save()
                        print("Cart item quantity updated successfully")
                        self.arrProduct[index].cartcount = newQuantity
                        self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    } catch let error as NSError {
                        print("Failed to update cart item quantity: \(error), \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                print("Error updating cart item quantity: \(error), \(error.userInfo)")
            }
        }

}

extension HomeVC :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProduct.dequeueReusableCell(withIdentifier: "ProductTC", for: indexPath) as! ProductTC
        cell.cellData = arrProduct[indexPath.row]
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(ProductAddtoCart(_:)), for: .touchUpInside)
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(ProductRemovetoCart(_:)), for: .touchUpInside)
        cell.btnFav.tag = indexPath.row
        cell.btnFav.addTarget(self, action: #selector(productFavUnfav(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func ProductAddtoCart(_ sender: UIButton) {
        let index = sender.tag
        let item = arrProduct[index]
        self.cartItem += 1
        if item.cartcount > 0 { //update
            updateQuantity(productId:item.id , newQuantity: item.cartcount + 1, index: index)
        }else { //add new
            addToCart(productId:item.id , quantity: item.cartcount + 1, index: index)
        }
        lblCartCount.text = "\(cartItem)"
    }
    
    @objc func ProductRemovetoCart(_ sender: UIButton) {
        let index = sender.tag
        let item = arrProduct[index]
        if item.cartcount > 0 {
            self.cartItem -= 1
            if item.cartcount == 1  { //remove from db
                removeFromCart(productId: item.id, index: index)
            }else { //update
                updateQuantity(productId:item.id , newQuantity: item.cartcount - 1, index: index)
            }
        }
        lblCartCount.text = "\(cartItem)"
    }
    
    @objc func productFavUnfav(_ sender: UIButton) {
        let index = sender.tag
        let item = arrProduct[index]
        if item.isFav { //remove from db
            self.unfavoriteProduct(productId: item.id, index: index)
        }else { //add
            self.createFavoriteProduct(productId: item.id, index: index)
        }
    }
    
}
