//
//  CollectionViewController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/21.
//

import UIKit


private let reuseIdentifier = "Cell"
private let segueIdentifier = "showdetail"
class CollectionViewController: UICollectionViewController {

    //接收下載資料
    static var menubody: MenuBody?
    
    //存取要傳送到訂購畫面的資料
    var passItemDetail: OrderDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuBodyController.share.fetchMenuBody {result in
            switch result {
            case .success(let menubodyResponse):
                CollectionViewController.menubody = menubodyResponse
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(_):
                print("error")
            }
        
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    @IBSegueAction func passItemDetail(_ coder: NSCoder) -> OrderDetailInputTableViewController? {
        guard let passItemDetail = passItemDetail else {return nil}
            return OrderDetailInputTableViewController(coder: coder, OrderDetail: passItemDetail)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let menubody = CollectionViewController.menubody else {
            return 1
        }
        return menubody.records.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        if CollectionViewController.menubody != nil {
            configureCell(cell, forItemAt: indexPath)
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = CollectionViewController.menubody?.records[indexPath.item].fields else{return}
        passItemDetail = OrderDetail(name: data.drinksname, hot: data.hot, image:data.image[0].url , icefree: data.icefree, price: data.price, category: data.category)
        
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    

    func configureCell(_ cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let data = CollectionViewController.menubody!.records[indexPath.item].fields
        cell.loadingActivityIndicator.stopAnimating()
        cell.isUserInteractionEnabled = true
        cell.menubodyNameLabel.text = "-\(data.drinksname)-"
        cell.menubodyPriceLabel.text = "$\(data.price)"
        MenuBodyController.share.fetchBodyImage(url: (data.image[0].url)) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.collectionView.indexPath(for: cell) {
                        cell.menubodyImage.image = image
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
