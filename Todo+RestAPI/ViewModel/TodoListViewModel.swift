//
//  TodoListViewModel.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/05/25.
//

import Foundation
import UIKit

class TodoListViewModel {
    
    var todos: Observable<[Todo]> 
    
    var completedTodos: Observable<[Todo]>
    
    var cellViewModel: TodoListCellViewModel?
    
    private let sections = ["할 일", "완료된 할 일"]
    
    init() {
        //초기 빈 배열 생성
        self.todos = Observable([])
        self.completedTodos = Observable([])
    }
    
    //var reloadTableview: (() -> Void)?
    
    var numberOfSections: Int {
        return self.sections.count
    }
    
    var numberOfTodos: Int {
        return self.todos.value?.count ?? 0
    }
    
    var numberOfCompletedTodos: Int {
        return self.completedTodos.value?.count ?? 0
    }
    
    
    func todoAtIndex(_ index:Int) -> Todo? {
        return self.todos.value?[index]
    }
    
    func completedTodoAtIndex(_ index:Int) -> Todo? {
        return self.completedTodos.value?[index]
    }
    
    func headerTitle(_ section: Int) -> String {
        return self.sections[section]
    }
    
    func editedTodos() -> [Todo] {
        let editedTodos = self.todos.value?.filter {$0.isEdited == true } ?? []
        let editedCompletedTodos = self.completedTodos.value?.filter { $0.isEdited == true} ?? []
        return editedTodos + editedCompletedTodos
    }
    
    //progressCount에 따라 todo를 todos -> completedTodos(또는 completedTodos -> todos)로 이동
    func updateTodoArray(todo: Todo?, indexPath: IndexPath) {
        
        guard let todo = todo else { return }
        guard let progressCount = todo.progressCount else { return }
        
        // 변경된 Todo 객체를 받아서 리스트를 업데이트하고, 필요에 따라 tableView를 리로드합니다.
        //todos에 있는 todo의 progressCount가 2로 변경
        if indexPath.section == 0 {
            
            if progressCount == 2 {
                self.completedTodos.value?.append(todo)
                self.todos.value?.remove(at: indexPath.row)
            } else {
                self.todos.value?[indexPath.row] = todo
            }
            
            //completedTodos에 있는 todo의 progressCount가 2 미만으로 변경
        } else {
            if progressCount < 2 {
                self.todos.value?.append(todo)
                self.completedTodos.value?.remove(at: indexPath.row)
            }else {
                self.completedTodos.value?[indexPath.row] = todo
            }
        }
    }

    
    //MARK: - 모든 할일 받아오기
     func fetchTodos() {
        TodosAPI.fetchTodos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todos):
                self.todos.value = todos.filter{ $0.progressCount != 2}
                self.completedTodos.value = todos.filter { $0.progressCount == 2}
               
            case .failure(let error):
                print("Failed to fetch todos:", error)
            }
        }
    }
    
    //MARK: - 할일 업데이트 하기
     func updateTodos() {
        self.editedTodos().forEach { todo in
            TodosAPI.updateATodo(id: todo.id ?? 1,
                                 title: todo.title ?? "제목이 없습니다.",
                                 content: todo.content ?? "내용이 없습니다.",
                                 imageURl: todo.imageURL ?? "",
                                 progressCount: todo.progressCount ?? 0,
                                 colorCount: todo.colorCount ?? 0) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let id):
                    if let id = id {
                        print("id: \(id) todo is updated")
                    }
                case .failure(let failure):
                    print("ViewController - Failed to update a todo",failure)
                }
                
                
            }
        }
    }
    
    func deleteATodo(indexPath: IndexPath) {
        //MARK: - 할일 삭제 하기
        if indexPath.section == 0 {
            guard let id = self.todos.value?[indexPath.row].id else { print("return"); return }
            TodosAPI.deleteATodo(id: id) { [weak self] result in
                guard let self = self else { print("self"); return }
                switch result {
                case .success(let deletedTodoID):
                    self.todos.value?.remove(at: indexPath.row)
                    print("successfully deleted Todo \(deletedTodoID)")
                 
                case .failure(let failure):
                    print("Failed to Delete Todo: \(failure)")
                }
            }
        }else {
                guard let id = self.completedTodos.value?[indexPath.row].id else { return }
                TodosAPI.deleteATodo(id: id) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let deletedTodoID):
                        self.completedTodos.value?.remove(at: indexPath.row)
                        print("successfully delete Todo \(deletedTodoID)")
                        
                    case .failure(let failure):
                        print("Failed to Delete Todo: \(failure)")
                    }
                    
                }
            
            
            }
        
    }
}

