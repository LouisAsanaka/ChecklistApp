//
//  TodoList.swift
//  Checklist
//
//  Created by Louis on 2019/6/10.
//  Copyright © 2019 Louis. All rights reserved.
//

import Foundation

class TodoList {
    
    var todos: [ChecklistItem]
    
    init() {
        todos = []
    }
    
    public func getItem(at index: Int) -> ChecklistItem? {
        return todos[index]
    }
    
    public func getItems() -> [ChecklistItem] {
        return todos
    }
    
    public func getItemCount() -> Int {
        return todos.count
    }
    
    public func createItem() -> ChecklistItem {
        return ChecklistItem()
    }
    
    public func addItem(_ item: ChecklistItem) {
        todos.append(item)
    }
    
    public func insertItem(_ item: ChecklistItem, at index: Int) {
        todos.insert(item, at: index)
    }
    
    public func removeItem(at itemIndex: Int) {
        todos.remove(at: itemIndex)
    }
    
    public func removeItems(_ items: [ChecklistItem]) {
        for item in items {
            if let itemIndex = index(of: item) {
                removeItem(at: itemIndex)
            }
        }
    }
    
    public func index(of item: ChecklistItem) -> Int? {
        return todos.index(of: item)
    }
    
    public func move(item: ChecklistItem, to index: Int) {
        guard let currentIndex = self.index(of: item) else {
            return
        }
        removeItem(at: currentIndex)
        insertItem(item, at: index)
    }
}
