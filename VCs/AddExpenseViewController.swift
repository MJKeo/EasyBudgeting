//
//  AddExpenseViewController.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/21/22.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var expenseLabelTF: UITextField!
    @IBOutlet weak var expenseAmountTF: UITextField!
    @IBOutlet weak var expenseDatePicker: UIDatePicker!
    @IBOutlet weak var addBtn: UIButton!
    
    var budgetGroup: BudgetGroup!
    
    var enableAddBtn: Bool {
        return (expenseLabelTF.text ?? "").count > 0
        && (expenseAmountTF.text ?? "0").toDouble() > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addTapToDismissKeyboard()
        self.expenseLabelTF.addTarget(self, action: #selector(updateAddBtn), for: .editingChanged)
        self.expenseAmountTF.addTarget(self, action: #selector(amountTFDidChange), for: .editingChanged)
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let expense = BudgetExpense(id: nil,
                                    groupName: self.budgetGroup.getName(),
                                    name: self.expenseLabelTF.text!,
                                    cost: self.expenseAmountTF.text!.toDouble() / 100,
                                    date: self.expenseDatePicker.date)
        expense.save()
        performSegue(withIdentifier: "unwindAddExpenseSegue", sender: self)
    }
    
    @objc func amountTFDidChange(_ textField: DollarTextField) {
        textField.convertToDollar()
        self.updateAddBtn()
    }
    
    @objc func updateAddBtn() {
        self.addBtn.isEnabled = enableAddBtn
    }
}
