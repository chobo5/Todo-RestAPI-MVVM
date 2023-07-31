//
//  AddTodoViewController.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/01/14.
//

import UIKit
import AVFoundation
import PhotosUI //ios14버전 이상부터, PHPicker를 사용하며, multiselect / zoom in or out / search 지원 https://zeddios.tistory.com/1052
import FirebaseStorage


class DetailTodoViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var detailTodoViewModel: DetailTodoViewModel!
    var listViewModel: TodoListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AddImageTableViewCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "contentCell")
        tableView.register(UINib(nibName: "PriorityTableViewCell", bundle: nil), forCellReuseIdentifier: "priorityCell")
        tableView.register(UINib(nibName: "ProgressTableViewCell", bundle: nil), forCellReuseIdentifier: "progressCell")
        print("fgsa",self.detailTodoViewModel.todo)
    }
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        
        guard let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TitleTableViewCell else { return }
        
        guard let contentCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? ContentTableViewCell else { return }
        
        guard let priorityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? PriorityTableViewCell else { return }
        
        guard let progressCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ProgressTableViewCell else { return }
        
        
        let newTitle = titleCell.titleTextField.text
        let newContent = contentCell.contentTextView.text
        
        
        self.detailTodoViewModel.todo?.title = newTitle
        self.detailTodoViewModel.todo?.content = newContent
       
//        listViewModel.test123(todo: self.viewModel.todo ?? Todo()) {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
}

extension DetailTodoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //MARK: - 이미지 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! AddImageTableViewCell
//            cell.addImageButton.addTarget(self, action: #selector(addImageButtonClicked(sender:)), for: .touchUpInside)
            
            cell.addedImage.image = self.detailTodoViewModel.todo?.image
            return cell
        case 1:
            //MARK: - 제목 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleTableViewCell
            cell.titleTextField.text = self.detailTodoViewModel.todo?.title
            return cell
            
        case 2:
            //MARK: - 내용 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! ContentTableViewCell
            
            cell.contentTextView.text = self.detailTodoViewModel.todo?.content
            
            return cell
            
        case 3:
            //MARK: - 중요도 셀(빨, 노, 파)
            let cell = tableView.dequeueReusableCell(withIdentifier: "priorityCell", for: indexPath) as! PriorityTableViewCell
            //기존의 할일의 중요도를 그리는 부분
            let colorCount = self.detailTodoViewModel.todo?.colorCount
            cell.priorityButtons.forEach { button in
                if button.tag == (colorCount ?? 0) + 200 { //red = 200, yellow = 201, blue = 202(colorCount를 버튼의 태그와 맞춤)
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor.white.cgColor
                }
            }
            
            //각각의 중요도 버튼에 액션 추가해주기
//            for index in cell.priorityButtons.indices {
//                cell.priorityButtons[index].addTarget(self, action: #selector(priorityButtonClicked(sender:)), for: .touchUpInside)
//            }
            return cell
            
        case 4:
            //MARK: - 진행도 셀(1, 2, 3)
            let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressTableViewCell
            // 기존의 할일의 진행도를 그리는 부분
            
            let progressCount = self.detailTodoViewModel.todo?.progressCount //1번개.tag = 100, 2번개.tag = 101, 3번개.tag = 102 (progressCount를 버튼의 태그와 맞춤)
            switch progressCount {
            case 0:
                cell.progressButtons[0].tintColor = UIColor.importanceBlue
                cell.progressButtons[1].tintColor = UIColor.deselectedColor
                cell.progressButtons[2].tintColor = UIColor.deselectedColor
            case 1:
                cell.progressButtons[0].tintColor = UIColor.importanceBlue
                cell.progressButtons[1].tintColor = UIColor.importanceBlue
                cell.progressButtons[2].tintColor = UIColor.deselectedColor
            case 2:
                cell.progressButtons[0].tintColor = UIColor.importanceBlue
                cell.progressButtons[1].tintColor = UIColor.importanceBlue
                cell.progressButtons[2].tintColor = UIColor.importanceBlue
            default:
                cell.progressButtons[0].tintColor = UIColor.deselectedColor
                cell.progressButtons[1].tintColor = UIColor.deselectedColor
                cell.progressButtons[2].tintColor = UIColor.deselectedColor
            }
            
            
            
            //각각의 진행도 버튼에 액션 추가해주기
            //            for index in cell.progressButtons.indices {
            //
            //                cell.progressButtons[index].addTarget(self, action: #selector(progressButtonClicked(sender:)), for: .touchUpInside)
            //            }
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}
    
    extension DetailTodoViewController: UITableViewDelegate {
        
        
        
        
    }
    
    
//MARK: - 각 셀의 버튼에서 실행할 함수 와 사진첩에 접근해 이미지를 선택하는 @objc func들
extension DetailTodoViewController/*: PHPickerViewControllerDelegate */{
    
    @objc func priorityButtonClicked(sender: CustomButton) {
        guard let priorityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? PriorityTableViewCell else { return }
        if sender.tag == 200 {
            priorityCell.priorityCount = 0
            priorityCell.priorityButtons.forEach { sender in
                if sender.tag == 200 {
                    selectedPriority(button: sender)
                } else {
                    deSelectedPriority(button: sender)
                }
            }
            
        } else if sender.tag == 201 {
            priorityCell.priorityCount = 1
            priorityCell.priorityButtons.forEach { sender in
                if sender.tag == 201 {
                    selectedPriority(button: sender)
                } else {
                    deSelectedPriority(button: sender)
                }
            }
            
            
        } else {
            priorityCell.priorityCount = 2
            priorityCell.priorityButtons.forEach { sender in
                if sender.tag == 202 {
                    selectedPriority(button: sender)
                } else {
                    deSelectedPriority(button: sender)
                }
            }
        }
    }
    
    func selectedPriority(button: CustomButton) {
        //클릭한 버튼 UI변경
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    func deSelectedPriority(button: CustomButton) {
        button.layer.borderWidth = 0
    }
    
    
    @objc func progressButtonClicked(sender: UIButton) {
        guard let progressCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? ProgressTableViewCell else { return }
        if sender.tag == 100 { //빨강
            progressCell.progressCount = 0
            progressCell.progressButtons.forEach { sender in
                if sender.tag <= 100 {
                    sender.tintColor = UIColor.importanceBlue
                } else {
                    sender.tintColor = UIColor.deselectedColor
                }
            }
            
        } else if sender.tag == 101 { //노랑
            progressCell.progressCount = 1
            progressCell.progressButtons.forEach { sender in
                if sender.tag <= 101 {
                    sender.tintColor = UIColor.importanceBlue
                } else {
                    sender.tintColor = UIColor.deselectedColor
                }
            }
            
        } else { //파랑
            progressCell.progressCount = 2
            progressCell.progressButtons.forEach { sender in
                sender.tintColor = UIColor.importanceBlue
                
            }
        }
    }
    
    @objc func addImageButtonClicked(sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 //default가 1, 이외 여러개의 사진을 선택 할 수 있다.
        configuration.filter = .any(of: [.images]) //기본값은 nil 즉, 모든 asset들(images, videos, livePhotos)을 선택할 수 있다.
        
        let picker = PHPickerViewController(configuration: configuration)
        //        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    //    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    //
    //        picker.dismiss(animated: true) //1.
    //
    //        let itemProvider = results.first?.itemProvider //2. itemProvider생성(선택된 asset의 Representation)
    //
    //        if let itemProvider = itemProvider,
    //           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3. provider가 내가 지정한 타입을 로드할 수 있는지 먼저 체크를 한 뒤
    //            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4. 로드 할 수 있으면 로드를 합니다
    //
    //                DispatchQueue.main.async {
    //                    guard let imageCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddImageTableViewCell else { return }
    //                    self.viewModel.image = image as? UIImage
    //                    print("self.todo.image", self.todo.image)
    //                    imageCell.addedImage.image = image as? UIImage // 5. loadObject는 completionHandler로 NSItemProviderReading과 error를 줍니다.
    //                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    //                }
    //            }
    //        } else {
    //            // TODO: Handle empty results or item provider not being able load UIImage
    //        }
    //
}




