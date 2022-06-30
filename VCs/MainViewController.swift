//
//  MainViewController.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/19/22.
//

import UIKit

var GROUPS: [BudgetGroup] = []
var EXPENSES: [BudgetExpense] = []

class MainViewController: UIViewController {
    
    // variables
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var budgetTable: UITableView!
    @IBOutlet weak var totalSpendingLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var newGroupBtn: UIButton!
    
    var shouldFetch = true
    
    // computed vars
    var totalSpending: Double {
        var total = 0.0
        for group in GROUPS {
            total += group.getTotalSpending()
        }
        return total
    }
    
    var totalRemaining: Double {
        var total = 0.0
        for group in GROUPS {
            total += group.getRemainingBudget()
        }
        return total
    }
    
    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupDatabase()
        self.budgetTable.delegate = self
        self.budgetTable.dataSource = self
        self.budgetTable.dragDelegate = self
        self.budgetTable.dragInteractionEnabled = true
        // style add btn
        self.newGroupBtn.titleLabel?.textColor = .fireOpal
        self.dateLabel.text = Date().toMonthYear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.shouldFetch {
            self.fetchData()
            self.shouldFetch = false
        } else {
            self.cleanExpenses()
            self.budgetTable.reloadData()
        }
        self.updateTotalsLabels()
    }
    
    private func setupDatabase() {
        openDatabase()
        createGroupsTable()
        createExpensesTable()
    }
    
    private func fetchData() {
        // Handle Expenses
        EXPENSES = getExpenses()
        // Handle Groups
        GROUPS = getBudgets()
        self.cleanExpenses()
        // Reflect new data in display
        self.budgetTable.reloadData()
    }
    
    private func updateTotalsLabels() {
        self.totalSpendingLabel.text = totalSpending.toDollar()
        self.remainingLabel.text = totalRemaining.toDollar()
    }
    
    private func cleanExpenses() {
        // organize expense by group
        var expenseDict: [String : [BudgetExpense]] = [:]
        for expense in EXPENSES {
            if Calendar.current.isDate(Date(), equalTo: expense.getDate(), toGranularity: .month) == false {
                continue
            }
            if var existingExpenses = expenseDict[expense.getGroupName()] {
                existingExpenses.append(expense)
                expenseDict[expense.getGroupName()] = existingExpenses
            } else {
                expenseDict[expense.getGroupName()] = [expense]
            }
        }
        // assign to groups
        for group in GROUPS {
            group.setExpenses(expenseDict[group.getName()] ?? [])
        }
        #warning("Account for fact that not all expenses have a group that exists, if I implement the ability to look back in time")
    }
    
    // actions
    @IBAction func newGroupBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createGroupSegue", sender: self)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateBudgetViewController,
           let group = sender as? BudgetGroup  {
            destination.editingGroup = group
        } else if let destination = segue.destination as? AddExpenseViewController,
                  let group = sender as? BudgetGroup {
            destination.budgetGroup = group
        }
    }
}

// MARK: - Table View Delegate / Datasource

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GROUPS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell")! as! BudgetGroupTableViewCell
        cell.setup(GROUPS[indexPath.row], index: indexPath.row, vc: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BudgetGroupTableViewCell
        tableView.beginUpdates()
        cell.click()
        tableView.endUpdates()
        // EDGE CASE: If we open the last cell, have the table view scroll down
        if (indexPath.row == (GROUPS.count - 1)) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GROUPS[indexPath.row].cellRowHeight
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = GROUPS[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingGroup = GROUPS.remove(at: sourceIndexPath.row)
        GROUPS.insert(movingGroup, at: destinationIndexPath.row)
    }
    
}
