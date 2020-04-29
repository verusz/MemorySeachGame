//
//  ViewController.swift
//  MemoryMatchingGame
//
//  Created by 朱继卿 on 2020-04-27.
//  Copyright © 2020 verus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var rowsTextField: UITextField!
    @IBOutlet weak var columnsTextField: UITextField!
    @IBOutlet weak var matchingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func inputValid() -> Bool {
        let row = rowsTextField.text ?? ""
        let column = columnsTextField.text ?? ""
        let matching = matchingTextField.text ?? ""
        
        let rowNum = Int(row) ?? 0
        let columnNum = Int(column) ?? 0
        let matchingNum = Int(matching) ?? 2
        
        if (rowNum > 0 && columnNum > 0 && ((rowNum * columnNum) % matchingNum == 0)) {
            return true
        } else {
            return false
        }
    }
 
    @IBAction func btnClicked(_ sender: Any) {
        if (inputValid()) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: GameController = storyboard.instantiateViewController(withIdentifier: "GameController") as! GameController
            vc.rows = Int(rowsTextField.text!)!
            vc.columns = Int(columnsTextField.text!)!
            vc.matchNumber = Int(matchingTextField.text ?? "") ?? 2
            self.present(vc, animated: true)
        } else {
            showAlert()
        }
    }
    
    func setupView() {
        confirmBtn.isEnabled = false
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.layer.masksToBounds = true
        confirmBtn.setBackgroundImage(UIImage(color: UIColor(red: 27/256, green: 136/256, blue: 238/256, alpha: 0.2)), for: .disabled)
        confirmBtn.setBackgroundImage(UIImage(color: UIColor(red: 27/256, green: 136/256, blue: 238/256, alpha: 1)), for: .normal)
        
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
        
        rowsTextField.delegate = self
        columnsTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func removeKeyboard() {
        rowsTextField.resignFirstResponder()
        columnsTextField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let row = rowsTextField.text ?? ""
        let column = columnsTextField.text ?? ""
        
        let rowText = textField == rowsTextField ? row + string : row
        let columnText = textField == columnsTextField ? column + string : column
        
        let rowNum = Int(rowText) ?? 0
        let columnNum = Int(columnText) ?? 0
        
        if (rowNum > 0 && columnNum > 0) {
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.isEnabled = false
        }
        
        return true
    }
    
}

extension ViewController {
    func showAlert() {// the reason why I did not create a util to handle alert is that this is a small project. It should not be overdesigned
        let confirmAction = UIAlertAction.init(title: "okay!", style: .`default`)
        
        let alertController = UIAlertController(title: "Input is not valid.", message: " Rules: (rows * columns) % matching number == 0 \r\n rows * columns <= \(50 ) * matching number ", preferredStyle: .alert)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIImage {
    convenience init?(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}



