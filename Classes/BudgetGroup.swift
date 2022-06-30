//
//  BudgetGroup.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/19/22.
//

import Foundation
import UIKit

public class BudgetGroup {
    
    // instance variables
    private var id: Int;
    private var name: String;
    private var budget: Double;
    private var expenses: [BudgetExpense];
    private var bgColorIndex: Int;
    
    private var isCellOpen = false;

    var cellRowHeight: CGFloat {
        return CGFloat(110 + (self.isCellOpen ? 45 * self.expenses.count : 0));
    }
    
    init (id: Int?, name: String, budget: Double, expenses: [BudgetExpense]?, bgcolorIndex: Int) {
        self.id = id ?? Int(Date().timeIntervalSince1970)
        self.name = name;
        self.budget = budget;
        self.expenses = expenses?.sorted(by: { exp1, exp2 in
                return exp1.getDate() > exp2.getDate()
            }) ?? [];
        self.bgColorIndex = bgcolorIndex
    }
    
    // MARK: - Accessor Methods
    
    public func getId() -> Int {
        return self.id;
    }
    
    public func getName() -> String {
        return self.name;
    }
    
    public func getBudget() -> Double {
        return self.budget;
    }
    
    public func getIsCellOpen() -> Bool {
        return self.isCellOpen;
    }
    
    public func getExpenses() -> [BudgetExpense] {
        return self.expenses;
    }
    
    public func getBGIndex() -> Int {
        return self.bgColorIndex;
    }
    
    public func getBGColor() -> UIColor {
        return UIColor.backgroundColors[self.bgColorIndex]
    }
    
    public func getTotalSpending() -> Double {
        var total = 0.0
        for expense in self.expenses {
            total += expense.getCost()
        }
        return total
    }
    
    public func getRemainingBudget() -> Double {
        return self.budget - self.getTotalSpending()
    }
    
    public func toString() -> String {
        var builtString = "Name: \(self.name), Budget: $\(self.budget), Items: "
        for expense in self.expenses {
            builtString.append("\n=== \(expense.toString()), ")
        }
        
        return builtString;
    }
    
    // MARK: - Mutator Methods
    
    public func setName(_ newName: String) {
        self.name = newName;
        updateBudgetGroup(self);
    }
    
    public func setBudget(_ newBudget: Double) {
        self.budget = newBudget;
        updateBudgetGroup(self);
    }
    
    public func setExpenses(_ expenses: [BudgetExpense]) {
        // sort the expenses by date (desc)
        self.expenses = expenses.sorted(by: { exp1, exp2 in
            return exp1.getDate() > exp2.getDate()
        });
    }
    
    public func setBGColorIndex(_ index: Int) {
        self.bgColorIndex = index;
        updateBudgetGroup(self)
    }
    
    public func addExpense(_ expense: BudgetExpense) {
        self.expenses.append(expense);
        self.expenses = self.expenses.sorted(by: { exp1, exp2 in
            return exp1.getDate() > exp2.getDate()
        });
    }
    
    public func removeExpense(_ expense: BudgetExpense) {
        // remove from current data structures
        EXPENSES.removeAll(where: { expense2 in
            expense2.getId() == expense.getId()
        })
        self.expenses.removeAll(where: { expense2 in
            expense2.getId() == expense.getId()
        })
        #warning("Restructure EXPENSES as dictionary to make this process easier")
        // remove from database
        expense.delete()
    }
    
    public func toggleCellOpen() {
        self.isCellOpen = !self.isCellOpen
    }
    
    // MARK: - Saving & Deleting
    
    func save() {
        GROUPS.append(self)
        saveBudgetGroup(self)
    }
    
    func update(name: String?, budget: Double?, bgColorIndex: Int?) {
        self.name = name ?? self.name
        self.budget = budget ?? self.budget
        self.bgColorIndex = bgColorIndex ?? self.bgColorIndex
        // update all expenses in the database as well
        if name != nil {
            for expense in self.expenses {
                expense.setGroupName(self.name)
            }
        }
        // actually update in database
        updateBudgetGroup(self)
    }
    
    func delete() {
        // remove all its expenses
        for expense in self.expenses {
            self.removeExpense(expense)
        }
        // remove from groups
        GROUPS.removeAll(where: { group2 in
            group2.getId() == self.getId()
        })
        // remove from database
        deleteBudgetGroup(self)
    }
}
