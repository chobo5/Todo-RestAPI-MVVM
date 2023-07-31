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
