//
//  OrderDetailInputTableViewController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/23.
//

import UIKit
import Foundation

class OrderDetailInputTableViewController: UITableViewController{
    
    //產品簡介
    @IBOutlet var categoaryLabel: UILabel! {
        didSet {
            categoaryLabel.layer.cornerRadius = 20
            categoaryLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet var drinksimage: UIImageView! {
        didSet {
            drinksimage.layer.cornerRadius = 20
            drinksimage.layer.masksToBounds = true
            drinksimage.layer.borderWidth = 2
            drinksimage.layer.borderColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
            
        }
    }
    @IBOutlet var drinksnameLabel: UILabel!
    @IBOutlet var drinkspriceLabel: UILabel!
    //必填
    @IBOutlet var oderernameTextfield: UITextField!
    @IBOutlet var drinkssugarTextfield: UITextField!
    @IBOutlet var drinkstempuretrueTextfield: UITextField!
    @IBOutlet var drinksaddtionTextfield: UITextField!
    @IBOutlet var pickerTextfields: [UITextField]!
    //選填
    @IBOutlet var remarkTextfield: UITextField!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var sendButton: UIButton! {
        didSet {
            sendButton.layer.cornerRadius = 20
            sendButton.layer.masksToBounds = true
        }
    }
    
    internal let pickerView = UIPickerView()
    
    //接收segue傳值
    var OrderDetail: OrderDetail
    init?(coder:NSCoder, OrderDetail: OrderDetail){
        self.OrderDetail = OrderDetail
        super.init(coder: coder)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addtionprice = 0
    var quantity = 1
    var totalprice: Int {
        get {
            return (OrderDetail.price + addtionprice) * quantity
        }
    }
    
    //增加數量
    @IBAction func plusButton(_ sender: UIButton) {
        quantity += 1
        quantityLabel.text = String(quantity)
        sendButton.setTitle("確認訂單 $\(totalprice)", for: .normal)
    }
    
    //減少數量
    @IBAction func minusButton(_ sender: UIButton) {
        
        quantity -= 1
        quantityLabel.text = String(quantity)
        sendButton.setTitle("確認訂單 $\(totalprice)", for: .normal)
        
        if quantity == 0 {
            
            let controller = UIAlertController(title: "提醒您", message: "最少要幫我點一杯喔，謝謝!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: {
                self.quantity = 1
                self.quantityLabel.text = String(self.quantity)
                self.sendButton.setTitle("確認訂單 $\(self.totalprice)", for: .normal)
            })
        
        } else if quantity < 0 {
            
            quantity -= 1
            quantityLabel.text = String(quantity)
            
        }
    }
    
    //上傳訂單
    @IBAction func sendButtonPress(_ sender: UIButton){
        
        if oderernameTextfield.text == "" {
            let controller = UIAlertController(title: "提醒您", message: "記得標注這杯的主人是誰喔！", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        } else if drinkssugarTextfield.text == "" {
            let controller = UIAlertController(title: "提醒您", message: "記得填寫飲料甜度！", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        } else if drinkstempuretrueTextfield.text == "" {
            let controller = UIAlertController(title: "提醒您", message: "記得填寫飲料溫度！", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        } else if drinksaddtionTextfield.text == "" {
            let controller = UIAlertController(title: "提醒您", message: "記得填寫飲料加料與否！", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
        if drinksaddtionTextfield.text != "" , drinkssugarTextfield.text != "" , drinkstempuretrueTextfield.text != "" {
        //上傳到airtable的網址
        let uploadURL = URL(string: "https://api.airtable.com/v0/appBPkPLBGbKXc7la/order")!
        let DateandTime = creatdateandtime()
        //預先提取並記錄此單field
        let orderfield = OrderUpload.Records.Fields(name: oderernameTextfield.text!, imageurl: OrderDetail.image , drinkname: OrderDetail.name, drinksugar: drinkssugarTextfield.text!, drinkaddtion: drinksaddtionTextfield.text!, drinktempuretrue: drinkstempuretrueTextfield.text!, quantity: quantity, remark: remarkTextfield.text!, price: totalprice, id: DateandTime)
        //暫存紀錄
        let orderRecords = OrderUpload.Records(fields: orderfield)
        //要上傳的資訊
        let order = OrderUpload(records: [orderRecords])
        OrderController.shared.PostOrder(url: uploadURL, data: order, completion: { result in
            switch result {
                
            case .success(_):
                DispatchQueue.main.async {
                let controller = UIAlertController(title: "感謝您", message: "已收到您的訂單！", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(controller, animated: true, completion: nil)
                OrderController.shared.order.orderstore.append(orderRecords)
                }
            case .failure(_):
                print("error")
            }
            
        })
        }
    }
    
    //建立日期時間
    func creatdateandtime() -> String {
        let currenttime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmSS"
        return formatter.string(from: currenttime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.navigationItem.title = "訂購單"
        categoaryLabel.text = OrderDetail.category
        drinksnameLabel.text = "-\(OrderDetail.name)-"
        drinkspriceLabel.text = "$\(OrderDetail.price)起"
        MenuBodyController.share.fetchBodyImage(url: OrderDetail.image, completion: { Result in
            switch Result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.drinksimage.image = image
                }
            case .failure(_):
                print("error")
            }
        } )
        quantityLabel.text = "\(quantity)"
        sendButton.setTitle("確認訂單 $\(OrderDetail.price)", for: .normal)
    }
}



    extension OrderDetailInputTableViewController: UITextFieldDelegate {
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.setpickerView(sender: textField)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
        }
        
        func setpickerView(sender: UITextField) {
            switch sender.tag {
               
            //利用tag來偵測需要顯示哪一個pickerView
            case 1:
                pickerView.tag = 1
            case 2:
                pickerView.tag = 2
            case 3:
                pickerView.tag = 3
            default:
                return
            }
            pickerView.delegate = self
            pickerView.dataSource = self
            
            //toolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.barTintColor = .white
            toolBar.tintColor = .black
            toolBar.sizeToFit()
            //toolBarBarButton
            let comformButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(comform))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButoon = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
            toolBar.setItems([cancelButoon, spaceButton, comformButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            for textfield in self.pickerTextfields {
                textfield.inputView = pickerView
                textfield.inputAccessoryView = toolBar
            }
        }
        
        @objc func comform() {
            switch pickerView.tag {
            case 1:
                pickerTextfields[0].text = Sagur.allCases[pickerView.selectedRow(inComponent: 0)].rawValue
                
            case 2:
                if OrderDetail.hot == nil {
                    pickerTextfields[1].text = nohot[pickerView.selectedRow(inComponent: 0)]
                } else {
                    pickerTextfields[1].text = normal[pickerView.selectedRow(inComponent: 0)]
                }
                
            case 3:
                pickerTextfields[2].text = Addtion.allCases[pickerView.selectedRow(inComponent: 0)].rawValue
                switch pickerView.selectedRow(inComponent: 0) {
                case 0:
                    addtionprice = 0
                    self.sendButton.setTitle("確認訂單 $\(self.totalprice)", for: .normal)
                case 1...7:
                    addtionprice = 10
                    self.sendButton.setTitle("確認訂單 $\(self.totalprice)", for: .normal)
                default:
                    addtionprice = 0
                    self.sendButton.setTitle("確認訂單 $\(self.totalprice)", for: .normal)
                }

            default:
                return
            }
            tableView.endEditing(true)
        }
        @objc func cancel() {
            tableView.endEditing(true)
        }
    }



extension OrderDetailInputTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Sagur.allCases.count
        case 2:
            if self.OrderDetail.hot != nil {
                return normal.count
            } else  {
                return nohot.count
            }
        case 3:
            return Addtion.allCases.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Sagur.allCases[row].rawValue
        case 2:
            if self.OrderDetail.hot != nil {
                return normal[row]
            } else {
                return nohot[row]
            }
        case 3:
            return Addtion.allCases[row].rawValue
            
        default:
            return "error"
        }
    
    }
    
    
}
