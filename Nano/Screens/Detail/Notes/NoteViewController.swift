//
//  NotesViewController.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-17.
//

import Foundation
import UIKit

class NoteViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        navigationItem.title = "New Note"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .secondarySystemGroupedBackground
        appearance.shadowImage = UIImage()
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.label
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(TextViewCell.self, forCellReuseIdentifier: "textViewCell")
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: view.bounds.width,
                                                         height: .leastNormalMagnitude))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = "Title"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! TextViewCell
            return cell
        }
    }
    
    
}

class TextFieldCell:UITableViewCell {
    
    var textField:UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textField = UITextField()
        contentView.addSubview(textField)
        textField.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: true)
        textField.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        textField.autocapitalizationType = .words
    }
}

class TextViewCell:UITableViewCell {
    
    var textView:UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textView = UITextView()
        contentView.addSubview(textView)
        textView.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: true)
        textView.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        textView.backgroundColor = UIColor.clear
        textView.constraintHeight(to: 52)
    }
}

