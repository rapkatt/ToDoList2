//
//  TodoList.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class TodoList {
  
  var todos: [ChecklistItem] = []
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    todos.append(item)
    item.checked = false
    return item
  }

}
