//
//  TodoListViewModel.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/05/25.
//

import Foundation
import UIKit

class TodoListViewModel {
    //    var todos: [Todo] = [Todo(content: "할일1", id: 1, imageURl: nil, modifiedDate: "", progressCount: 1, title: "할일1", colorCount: 1, createdDate: "", isEdited: false, image: UIImage())]
    //
    //    private var completedTodos: [Todo] = [Todo(content: "할일2", id: 2, imageURl: nil, modifiedDate: "", progressCount: 2, title: "할일2", colorCount: 2, createdDate: "", isEdited: false, image: UIImage())]
    
    var todos: [Todo]
    
    var completedTodos: [Todo]
    
    private let sections = ["할 일", "완료된 할 일"]
    
    init() {
        //초기 빈 배열 생성
        self.todos = []
        self.completedTodos = []
    }
    
    //var reloadTableview: (() -> Void)?
    
    var numberOfSections: Int {
        return self.sections.count
    }
    
    var numberOfTodos: Int {
        return self.todos.count
    }
    
    var numberOfCompletedTodos: Int {
        return self.completedTodos.count
    }
    
    
    func todoAtIndex(_ index:Int) -> Todo? {
        return self.todos[index]
    }
    
    func completedTodoAtIndex(_ index:Int) -> Todo? {
        return self.completedTodos[index]
    }
    
    func headerTitle(_ section: Int) -> String {
        return self.sections[section]
    }
    
    
    func changeProgressCount(indexPath: IndexPath, progressCount: Int) {
        if indexPath.section == 0 {
            self.todos[indexPath.row].progressCount = progressCount
            self.todos[indexPath.row].isEdited = true
            
        } else {
            self.completedTodos[indexPath.row].progressCount = progressCount
            self.completedTodos[indexPath.row].isEdited = true
        }
    }
    
    func editedTodos() -> [Todo] {
        let editedTodos = self.todos.filter {$0.isEdited == true }
        let editedCompletedTodos = self.completedTodos.filter { $0.isEdited == true}
        return editedTodos + editedCompletedTodos
    }
    
    //progressCount에 따라 todo를 todos -> completedTodos(또는 completedTodos -> todos)로 이동
    func moveTodoElement(indexPath: IndexPath, completion: @escaping () -> Void) {
        //todos에 있는 todo의 progressCount가 2로 변경
        if indexPath.section == 0 {
            let todo = todos[indexPath.row]
            guard let progressCount = todo.progressCount else { return }
            if progressCount == 2 {
                completedTodos.append(todo)
                todos.remove(at: indexPath.row)
                completion()
            }
            
        //completedTodos에 있는 todo의 progressCount가 2 미만으로 변경
        } else {
            let todo = completedTodos[indexPath.row]
            guard let progressCount = todo.progressCount else { return }
            if progressCount < 2 {
                todos.append(todo)
                completedTodos.remove(at: indexPath.row)
                completion()
            }
        }
    }
    
}

