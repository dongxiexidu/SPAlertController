//
//  PickerView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/13.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

class PickerView: UIView, Nibloadable {

    @IBOutlet weak var pickView: UIPickerView!
    
    var cancelClickedClosure: (()->Void)?
    var doneClickedClosure: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickView.delegate = self
        pickView.dataSource = self
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        cancelClickedClosure?()
    }
    
    @IBAction func doneClick(_ sender: Any) {
        doneClickedClosure?()
    }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["男","女"][row]
    }
}
