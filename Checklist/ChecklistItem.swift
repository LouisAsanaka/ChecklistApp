//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Louis on 2019/6/10.
//  Copyright © 2019 Louis. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    @objc
    var text: String
    var checked: Bool
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    convenience override init() {
        self.init(text: "", checked: false)
    }
    
    public func toggleChecked() {
        self.checked = !self.checked
    }
}
