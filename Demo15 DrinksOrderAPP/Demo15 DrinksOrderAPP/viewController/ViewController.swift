//
//  ViewController.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/18.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var CollectionViewPageControl: UIPageControl!
    var CollectionView: UICollectionView!
    var imageindex = 0
    
    
    //func for CollectionViewFlowLayout
    func setUpCollectionView() {
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 390, height: 200)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = CGFloat(integerLiteral: Int(0))
        let CollectionViewRcet = CGRect(x: 0, y: 100, width: 390, height: 200)
        self.CollectionView = UICollectionView(frame: CollectionViewRcet, collectionViewLayout: flowLayout)
        self.CollectionView.showsHorizontalScrollIndicator = false
        self.CollectionView.isPagingEnabled = true
        self.CollectionView.backgroundColor = .clear
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        self.CollectionView.register(Mycell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(CollectionView)
        
    }
    
    //BannerPicArray
    let imageArray: [UIImage] =
    {
        var arr = [UIImage]()
        for i in 1...6
        {
        let image = UIImage(named: "banner\(i)")
        arr.append(image!)
        }
        arr.append(UIImage(named: "banner1")!)
        return arr
    }()
    
    //AutoplayBannerWith
    @objc func changebanner() {
        
        let indexPath: IndexPath = IndexPath(item: imageindex, section: 0)
        
        imageindex += 1
        
        if imageindex < imageArray.count  {
            
            CollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            CollectionViewPageControl.currentPage = imageindex - 1
            
        }else if imageindex == imageArray.count {
            print("scroll to zero")
            imageindex = 0
            CollectionViewPageControl.currentPage = imageindex
            CollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as! Mycell
       
        cell.imageView.image = imageArray[indexPath.item]
        return cell
        
    }
    
    class Mycell: UICollectionViewCell {
        var imageView = UIImageView()
        func setupImageView() {
            imageView.frame = CGRect(x:10, y:0, width: 370, height: 180)
            imageView.backgroundColor = .lightGray
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
            self.addSubview(imageView)
        }
        override func layoutSubviews() {
            setupImageView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changebanner), userInfo: nil, repeats: true)
        CollectionViewPageControl.numberOfPages = imageArray.count - 1
        
    }


}

