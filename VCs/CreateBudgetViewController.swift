//
//  CreateBudgetViewController.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/20/22.
//

import UIKit

class CreateBudgetViewController: UIViewController {
    
    @IBOutlet weak var groupNameTF: UITextField!
    @IBOutlet weak var budgetLimitTF: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var backgroundColorCV: UICollectionView!
    
    var editingGroup: BudgetGroup? // if nil then we're creating, if not then we're editing
    var selectedColorIndex = 0
    
    var shouldEnableCreateBtn: Bool {
        return (groupNameTF.text ?? "").count > 0
        && (budgetLimitTF.text ?? "0").toDouble() > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addTapToDismissKeyboard()
        self.groupNameTF.addTarget(self, action: #selector(updateCreateBtn), for: .editingChanged)
        self.budgetLimitTF.addTarget(self, action: #selector(limitTFDidChange), for: .editingChanged)
        self.backgroundColorCV.delegate = self
        self.backgroundColorCV.dataSource = self
        
        // alternate setup if we're editing
        if (self.editingGroup != nil) {
            self.groupNameTF.text = self.editingGroup!.getName()
            self.budgetLimitTF.text = self.editingGroup!.getBudget().toDollar()
            self.selectedColorIndex = self.editingGroup!.getBGIndex()
            self.createBtn.setTitle("Save Changes", for: .normal)
            self.updateCreateBtn()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createNewGroup(_ sender: Any) {
        // if editing, go to that function
        if (self.editingGroup != nil) {
            self.updateGroup()
            return
        }
        let groupName = groupNameTF.text!
        let budgetLimit = budgetLimitTF.text!.toDouble() / 100
        // check to see if main view already has this name
        for group in GROUPS {
            if group.getName() == groupName {
                self.showOkAlert("A budget with that name already exists", message: nil)
                return
            }
        }
        // create the new budget group
        let budgetGroup = BudgetGroup(id: nil, name: groupName, budget: budgetLimit, expenses: nil, bgcolorIndex: selectedColorIndex)
        budgetGroup.save()
        performSegue(withIdentifier: "unwindCreateBudget", sender: self)
    }
    
    private func updateGroup() {
        self.editingGroup?.update(name: self.groupNameTF.text, budget: self.budgetLimitTF.text!.toDouble() / 100, bgColorIndex: selectedColorIndex)
        performSegue(withIdentifier: "unwindCreateBudget", sender: self)
    }
    
    @objc func limitTFDidChange(_ textField: DollarTextField) {
        textField.convertToDollar()
        self.updateCreateBtn()
    }
    
    @objc func updateCreateBtn() {
        self.createBtn.isEnabled = shouldEnableCreateBtn
    }
    
}

// MARK: - UICollectionView Delegate / Datasource

extension CreateBudgetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIColor.backgroundColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundColorCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.backgroundColors[indexPath.row]
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = self.selectedColorIndex == indexPath.row
            ? UIColor.carolinaBlue.cgColor
            : UIColor.white.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedColorIndex = indexPath.row
        collectionView.reloadData()
    }
    
}
