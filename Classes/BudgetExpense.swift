//
//  BudgetItem.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/19/22.
//

import Foundation

public class BudgetExpense {
    
    // instance variables
    private var id: Int;
    private var groupName: String;
    private var name: String;
    private var cost: Double;
    private var date: Date;
    
    init (id: Int?, groupName: String, name: String, cost: Double, date: Date) {
        self.id = id ?? Int(Date().timeIntervalSince1970);
        self.groupName = groupName;
        self.name = name;
        self.cost = cost;
        self.date = date;
    }
    
    // MARK: - Accessor Methods
    
    public func getId() -> Int {
        return self.id;
    }
    
    public func getGroupName() -> String {
        return self.groupName;
    }
    
    public func getName() -> String {
        return self.name;
    }
    
    public func getCost() -> Double {
        return self.cost;
    }
    
    public func getDate() -> Date {
        return self.date;
    }
    
    public func toString() -> String {
        return "[ID: \(self.id), Group Name: \(self.groupName), Name: \(self.name), Cost: \(self.cost.toDollar()), Date: \(self.date.toYYYYMMDD())]";
    }
    
    // MARK: - Mutator Methods
    
    public func setGroupName(_ groupName: String) {
        self.groupName = groupName;
        self.update();
    }
    
    private func update() {
        updateExpense(self)
    }
    
    // MARK: - Saving & Deleting
    
    public func save() {
        EXPENSES.append(self)
        saveExpense(self)
    }
    
    public func delete() {
        deleteExpense(self)
    }
}
