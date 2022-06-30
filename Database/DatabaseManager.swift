//
//  DatabaseManager.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/19/22.
//

import Foundation
import SQLite3

var db: OpaquePointer?

func openDatabase() {
    let dbURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("Database.sqlite")

    guard let dbPath = dbURL?.path else {
        print("Error getting database file path")
        return
    }
    
    if sqlite3_open(dbPath, &db) == SQLITE_OK {
        print("Successfully opened connection to database at \(dbPath)")
        return
    }
    
    print("Unable to open database")
}

// MARK: - Creating / Deleting tables

func createGroupsTable() {
    let createTableString = """
    CREATE TABLE IF NOT EXISTS BudgetGroups(
    Id Int PRIMARY KEY NOT NULL,
    Name CHAR(255),
    Budget DOUBLE,
    BackgroundColor Int)
    """
    
    createTable(createTableString)
}

func createExpensesTable() {
    let createTableString = """
    CREATE TABLE IF NOT EXISTS Expenses(
    Id INT PRIMARY KEY NOT NULL,
    GroupName CHAR(255),
    Name CHAR(255),
    Cost DOUBLE,
    Date CHAR(255))
    """
    
    createTable(createTableString)
}

private func createTable(_ createTableString: String) {
    var createTableStatement: OpaquePointer?
    if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
            print("Table created!")
        } else {
            print("Unable to create table")
        }
    } else {
        print("Create table statement not able to be prepared")
    }
    
    sqlite3_finalize(createTableStatement)
}

func deleteGroupsTable() {
    let deleteTableString = """
    DROP TABLE BudgetGroups
    """
    
    deleteTable(deleteTableString)
}

func deleteExpensesTable() {
    let deleteTableString = """
    DROP TABLE Expenses
    """
    
    deleteTable(deleteTableString)
}

private func deleteTable(_ deleteTableString: String) {
    var deleteTableStatement: OpaquePointer?
    if sqlite3_prepare_v2(db, deleteTableString, -1, &deleteTableStatement, nil) == SQLITE_OK {
        if sqlite3_step(deleteTableStatement) == SQLITE_DONE {
            print("Table deleted!")
        } else {
            print("Unable to delete table")
        }
    } else {
        print("Delete table statement not able to be prepared")
    }
    
    sqlite3_finalize(deleteTableStatement)
}

// MARK: - Saving Data

func saveBudgetGroup(_ group: BudgetGroup) {
    let saveBudgetGroupString = """
    INSERT INTO BudgetGroups (Id, Name, Budget, BackgroundColor)
    VALUES (\(group.getId()), \"\(group.getName())\", \(group.getBudget()), \(group.getBGIndex()))
    """
    executeInsertStatement(saveBudgetGroupString)
}

func saveExpense(_ expense: BudgetExpense) {
    let saveExpenseString = """
    INSERT INTO Expenses (Id, GroupName, Name, Cost, Date)
    VALUES (\(expense.getId()), \"\(expense.getGroupName())\", \"\(expense.getName())",
    \(expense.getCost()), \"\(expense.getDate().toYYYYMMDD())\")
    """
    executeInsertStatement(saveExpenseString)
}

private func executeInsertStatement(_ query: String) {
    var statement: OpaquePointer?
    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data saved!")
        } else {
            print("Error saving data")
        }
    } else {
        print("Error preparing data save statement")
    }
    
    sqlite3_finalize(statement)
}

// MARK: - Reading data

func getBudgets() -> [BudgetGroup] {
    let getGroupsString = """
    SELECT * FROM BudgetGroups
    """
    
    var groups: [BudgetGroup] = []
    var queryStatement: OpaquePointer?
    if sqlite3_prepare_v2(db, getGroupsString, -1, &queryStatement, nil) == SQLITE_OK {
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(queryStatement, 0))
            let name = String(cString: sqlite3_column_text(queryStatement, 1))
            let budgetLimit = sqlite3_column_double(queryStatement, 2)
            let bgColorIndex = Int(sqlite3_column_int(queryStatement, 3))
            groups.append(BudgetGroup(id: id, name: name, budget: budgetLimit, expenses: nil, bgcolorIndex: bgColorIndex))
        }
    }
    
    sqlite3_finalize(queryStatement)
    return groups
}

func getExpenses() -> [BudgetExpense] {
    let getExpensesString = """
    SELECT * FROM Expenses
    """
    
    var expenses: [BudgetExpense] = []
    var queryStatement: OpaquePointer?
    if sqlite3_prepare_v2(db, getExpensesString, -1, &queryStatement, nil) == SQLITE_OK {
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(queryStatement, 0))
            let groupName = String(cString: sqlite3_column_text(queryStatement, 1))
            let expenseName = String(cString: sqlite3_column_text(queryStatement, 2))
            let cost = sqlite3_column_double(queryStatement, 3)
            let date = String(cString: sqlite3_column_text(queryStatement, 4)).dateFromYYYYMMDD()
            let expense = BudgetExpense(id: id, groupName: groupName, name: expenseName, cost: cost, date: date)
            expenses.append(expense)
        }
    }
    
    sqlite3_finalize(queryStatement)
    return expenses
}

// MARK: - Updating Data

func updateExpense(_ expense: BudgetExpense) {
    let updateString = """
    UPDATE Expenses
    SET GroupName = "\(expense.getGroupName())", Name = "\(expense.getName())", Cost = \(expense.getCost()), Date = "\(expense.getDate().toYYYYMMDD())"
    WHERE Id = \(expense.getId())
    """
    
    executeUpdateStatement(updateString)
}

func updateBudgetGroup(_ group: BudgetGroup) {
    let updateString = """
    UPDATE BudgetGroups
    SET Name = "\(group.getName())", Budget = \(group.getBudget()), BackgroundColor = \(group.getBGIndex())
    WHERE Id = "\(group.getId())"
    """
    
    executeUpdateStatement(updateString)
}

private func executeUpdateStatement(_ query: String) {
    var statement: OpaquePointer?
    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data successfully updated!")
        } else {
            print("Error updating data :(")
        }
    } else {
        print("Error preparing update statement")
    }
    
    sqlite3_finalize(statement)
}

// MARK: - Delete Data

func deleteBudgetGroup(_ group: BudgetGroup) {
    let deleteString = """
    DELETE FROM BudgetGroups WHERE Id = \"\(group.getId())\"
    """
    
    executeDeleteStatement(deleteString)
}

func deleteExpense(_ expense: BudgetExpense) {
    let deleteString = """
    DELETE FROM Expenses WHERE Id = \(expense.getId())
    """
    
    executeDeleteStatement(deleteString)
}

private func executeDeleteStatement(_ query: String) {
    var statement: OpaquePointer?
    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
        if sqlite3_step(statement) == SQLITE_DONE {
            print("Data deleted!")
        } else {
            print("Error deleting data")
        }
    } else {
        print("Error preparing data delete statement")
    }
    
    sqlite3_finalize(statement)
}
