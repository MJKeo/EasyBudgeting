//
//  BudgetGroupTableViewCell.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/25/22.
//

import UIKit

class BudgetGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var optionsBtn: UIButton!
    @IBOutlet weak var drawerBtn: UIButton!
    
    @IBOutlet weak var expenseTableView: UITableView!
    
    private var vc: UIViewController!
    private var budgetGroup: BudgetGroup!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.expenseTableView.delegate = self
        self.expenseTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func click() {
        // animate rotation of the arrow
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.drawerBtn.transform = self.budgetGroup.getIsCellOpen()
            ? self.drawerBtn.transform.rotated(by: CGFloat.pi + 0.0001)
            :self.drawerBtn.transform.rotated(by: CGFloat.pi - 0.0001)
        }, completion: nil)
        // invert open status
        self.budgetGroup.toggleCellOpen()
    }
    
    func setup(_ group: BudgetGroup, index: Int, vc: UIViewController) {
        // variable saving
        self.budgetGroup = group
        self.nameLabel.text = group.getName()
        self.amountLabel.text = group.getBudget().toDollar()
        self.remainingLabel.text = group.getRemainingBudget().toDollar()
        self.vc = vc
        // styling
        self.mainView.layer.backgroundColor = group.getBGColor().cgColor
        self.expenseTableView.separatorColor = group.getBGColor()
        self.expenseTableView.reloadData()
    }
    
    @IBAction func addExpenseClicked(_ sender: Any) {
        self.vc.performSegue(withIdentifier: "addExpenseSegue", sender: self.budgetGroup)
    }
    
    @IBAction func optionsClicked(_ sender: Any) {
        vc.showActionSheet(controller: UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet), actions: [
            UIAlertAction(title: "Edit Group", style: .default) { _ in
                self.vc.performSegue(withIdentifier: "createGroupSegue", sender: self.budgetGroup)
            },
            UIAlertAction(title: "Delete Group", style: .destructive) { _ in
                self.budgetGroup.delete()
                self.vc.viewDidAppear(false)
            },
            UIAlertAction(title: "cancel", style: .cancel)
        ])
    }

}

// MARK: - UITableView Delegate / Datasource

extension BudgetGroupTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.budgetGroup.getExpenses().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseTableViewCell
        let expense = self.budgetGroup.getExpenses()[indexPath.row]
        cell.dateLabel.text = expense.getDate().toMMDD()
        cell.nameLabel.text = expense.getName()
        cell.costLabel.text = "- \(expense.getCost().toDollar())"
        cell.contentView.backgroundColor = self.budgetGroup.getBGColor().withAlphaComponent(0.33)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            self.budgetGroup.removeExpense(self.budgetGroup.getExpenses()[indexPath.row])
            self.vc.viewDidAppear(false)
        }])
    }
    
}
