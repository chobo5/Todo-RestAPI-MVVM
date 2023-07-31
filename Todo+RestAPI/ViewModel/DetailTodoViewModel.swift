//
//  DetailTodoViewModel.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/05/31.
//
import UIKit

class DetailTodoViewModel {
    
    var isNewTodo: Bool?
    var todo: Todo?
    
    init(todo: Todo?, isNewTodo: Bool) {
        self.todo = todo
        self.isNewTodo = isNewTodo
    }
    
    
    func updateTitle(text: String) {
        self.todo?.title = text
    }
    
    func updateContent(text: String) {
        self.todo?.content = text
    }
    
    func updateProgressCount(progressCount: Int) {
        self.todo?.progressCount = progressCount
    }
    
    func updateColorCount(colorCount: Int) {
        self.todo?.colorCount = colorCount
    }
    
    func getIsNewTodo() -> Bool {
        return self.isNewTodo ?? true
    }
    
    func getID() -> Int {
        return self.todo?.id ?? 0
    }
    
    func getTitle() -> String {
        return self.todo?.title ?? "제목이 없습니다."
    }
    
    func getContent() -> String {
        return self.todo?.content ?? "내용이 없습니다."
    }
    
    func getProgressCount() -> Int {
        return self.todo?.progressCount ?? 0
    }
    
    func getColorCount() -> Int {
        return self.todo?.colorCount ?? 0
    }
//    func downloadImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
//        guard let imageURL = self.todo?.imageURl else { return }
//
//        FirebaseStorageManager.downloadImage(
//            urlString: String(imageURL)) { result in
//                switch result {
//                case .success(let image):
//                    self.todo?.image = image
//                    completion(.success(image ?? UIImage()))
//                case .failure(let error):
//                    print("downoadImageError", error)
//                }
//            }
//
//    }
}
