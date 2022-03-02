//
//  OrderLiseTableViewController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/26.
//

import UIKit

class OrderListTableViewController: UITableViewController {

    @IBOutlet var totalcountLabel: UILabel!
    
    //接收下載資料
    var deleteitem = [OrderDownload.Records](){
        didSet {
            DispatchQueue.main.async {
            //顯示總訂單數
                self.totalcountLabel.text = "總共\(self.totalcount)筆訂單"
            }
        }
    }
    
    //總訂單計算
    var totalcount: Int {
        get {
            return deleteitem.count
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {

        
        OrderController.shared.fetchOrder { result in
            
            switch result {
            case .success(let Response):
                self.deleteitem = Response
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
            }
                
            case.failure(_):
                print("error")
                break
                
            }
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return deleteitem.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderListTableViewCell
        let data = self.deleteitem[indexPath.row].fields
        cell.orderernameLabel.text = data.name
        cell.drinknameLabel.text = data.drinkname
        cell.addtionLabel.text = data.drinkaddtion
        cell.remarkLabel.text = data.remark ?? "無"
        cell.numberImage.image = UIImage(systemName: "\(indexPath.row + 1).circle.fill")
   
        MenuBodyController.share.fetchBodyImage(url: data.imageurl) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if indexPath == self.tableView.indexPath(for: cell) {
                        cell.drinkImage.image = image
                        cell.loadingActivityIndicator.stopAnimating()
                
                    }
                }
            case .failure(_):
                print("error")
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItem = deleteitem[indexPath.row]
            OrderController.shared.deleteOrder(orderID: deleteItem.id) {result in
                switch result {
                case.success(let message):
                    print(message)
                    DispatchQueue.main.async {
                        self.deleteitem.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        self.tableView.reloadData()
                    }
                   
                case.failure(_):
                    print("error")
                }
               }
              }
             }
            }
