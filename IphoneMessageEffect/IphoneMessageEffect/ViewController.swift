//
//  ViewController.swift
//  IphoneMessageEffect
//
//  Created by 刘晓晨 on 2017/5/9.
//  Copyright © 2017年 刘晓晨. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblDamping: UILabel!
    
    @IBOutlet weak var lblFreq: UILabel!
    
    @IBOutlet weak var lblResist: UILabel!
    
    @IBOutlet weak var sliderDamping: UISlider!
    
    @IBOutlet weak var sliderFreq: UISlider!
    
    @IBOutlet weak var sliderResist: UISlider!
    
    lazy var layout:IMEFlowLayout = {
        let flowlayout:IMEFlowLayout = IMEFlowLayout()
        
        return flowlayout
    }()
    
    static let reuseId = "collectionViewCellReuseId"
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let collectionView:UICollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewController.reuseId)

        
        collectionView.dataSource = self;
        
        view .insertSubview(collectionView, at: 0)
        
        updateLabelNumber()
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabelNumber() {
        self.lblDamping.text = String(format: "%.1f", sliderDamping.value)
        
        self.lblFreq.text = String(format: "%.1f", sliderFreq.value)
        
        self.lblResist.text = String(format: "%.1f", sliderResist.value)
        
    }
    
    @IBAction func dampingValueChanged(_ sender: UISlider) {
        
        layout.springDamping = CGFloat(sender.value)
        updateLabelNumber()
    }
   
    @IBAction func freqValueChanged(_ sender: UISlider) {
        
        layout.springFrequency = CGFloat(sender.value)
        updateLabelNumber()
    }

    @IBAction func resistValueChanged(_ sender: UISlider) {
        
        layout.resistanceFactor = CGFloat(sender.value)
        updateLabelNumber()
    }

}


extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.reuseId, for: indexPath)
        
        cell.backgroundColor = UIColor.groupTableViewBackground
        
        return cell
        
    }
    
    
    
}










