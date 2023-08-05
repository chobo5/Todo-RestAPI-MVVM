//
//  DetailTodoViewModel.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/05/31.
//
import UIKit

class DetailTodoViewModel {
    
    var indexPath: IndexPath?
    var isNewTodo: Bool?
    var todo: Observable<Todo>
    var listViewModel: TodoListViewModel?
    
    init(todo: Todo?, isNewTodo: Bool, listViewModel: TodoListViewModel, indexPath: IndexPath) {
        self.todo = Observable(todo)
        self.isNewTodo = isNewTodo
        self.listViewModel = listViewModel
        self.indexPath = indexPath
    }
    
    
    func updateTitle(text: String) {
        self.todo.value?.title = text
    }
    
    func updateContent(text: String) {
        self.todo.value?.content = text
    }
    
    func updateProgressCount(progressCount: Int) {
        self.todo.value?.progressCount = progressCount
    }
    
    func updateColorCount(colorCount: Int) {
        self.todo.value?.colorCount = colorCount
    }
    
    
    func notifyTodoList() {
        guard let todo = self.todo.value else { return }
        //새로운 할일 일때
        if let isNewTodo =  self.isNewTodo {
            //새로운 할일의 prgressCount = 2 일때
            
        //기존의 할일을 업데이트 했을때
        }else {
            
        }
    }

    func postATodo() {
        guard let todo = self.todo.value else { return }
        TodosAPI.addATodo(title: todo.title ?? "무제",
                          content: todo.content ?? "내용을 입력해주세요",
                          imageURl: todo.imageURL ?? "",
                          progressCount: todo.progressCount ?? 0,
                          colorCount: todo.colorCount ?? 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todo):
                if todo.progressCount == 2 {
                    self.listViewModel?.completedTodos.value?.append(todo)
                //새로운 할일의 prgressCount가 2가 아닐떄(2보다 작을때)
                }else {
                    self.listViewModel?.todos.value?.append(todo)
                }
            case .failure(let error):
                print("Error posting todo \(error)")
            }
        }
    }
    
    func updateATodo() {
        guard let todo = self.todo.value else { return }
        TodosAPI.updateATodo(id: todo.id ?? 0,
                             title: todo.title ?? "무제",
                             content: todo.content ?? "내용을 입력해주세요",
                             imageURl: todo.imageURL ?? "",
                             progressCount: todo.progressCount ?? 0,
                             colorCount: todo.progressCount ?? 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let id):
                if let id = id {
                    print("sucessfully updated todo ID:\(id)")
                }
                //할일 배열
                guard let indexPath = self.indexPath else { return }
                if indexPath.section == 0 {
                    self.listViewModel?.todos.value?[indexPath.row] = todo
                    
                //완료된 할일 배열
                } else {
                    self.listViewModel?.completedTodos.value?[indexPath.row] = todo
                }
            case .failure(let error):
                print("Error updating todo \(error)")
            }
        }
    }
}
