//
//  TodoListCellViewModel.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/06/05.
//

import Foundation

struct TodoListCellViewModel {
    private let todo: Todo
    
    var title: String {
        guard let title = self.todo.title else { return "제목없음"}
        return title
    }
    
    var id: Int {
        guard let id = self.todo.id else { return 0}
        return id
    }
    
    var progressCount: Int {
        guard let progressCount = self.todo.progressCount else { return 0 }
        return progressCount
    }
    
    var colorCount: Int {
        guard let colorCount = self.todo.colorCount else { return 0 }
        return colorCount
    }
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    
}
