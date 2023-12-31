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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AddImageTableViewCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "contentCell")
        tableView.register(UINib(nibName: "PriorityTableViewCell", bundle: nil), forCellReuseIdentifier: "priorityCell")
        tableView.register(UINib(nibName: "ProgressTableViewCell", bundle: nil), forCellReuseIdentifier: "progressCell")
        print("self", self.detailTodoViewModel.todo.value)
    }
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        guard let isNewTodo = self.detailTodoViewModel.isNewTodo else { return }
        if isNewTodo {
            self.detailTodoViewModel.postATodo()

        } else {
            self.detailTodoViewModel.updateATodo()
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailTodoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //MARK: - 제목 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! TitleTableViewCell
            cell.titleTextField.text = self.detailTodoViewModel.todo.value?.title ?? ""
            cell.titleTextField.addTarget(self, action: #selector(titleTextFieldChanged(sender:)), for: .editingChanged)
        
            cell.viewModel = detailTodoViewModel
            cell.configData()
            return cell
            
        case 1:
            //MARK: - 내용 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as! ContentTableViewCell
            if let content = self.detailTodoViewModel.todo.value?.content {
                cell.contentTextView.text = content
            }
            cell.contentTextView.delegate = self
            
            return cell
            
        case 2:
            //MARK: - 중요도 셀(빨, 노, 파)
            let cell = tableView.dequeueReusableCell(withIdentifier: "priorityCell", for: indexPath) as! PriorityTableViewCell
            //기존의 할일의 중요도를 그리는 부분
            if let colorCount = self.detailTodoViewModel.todo.value?.colorCount {
                cell.priorityButtons.forEach { button in
                    button.addTarget(self, action: #selector(priorityButtonClicked(sender:)), for: .touchUpInside)
                    if button.tag == (colorCount) + 200 { //red = 200, yellow = 201, blue = 202(colorCount를 버튼의 태그와 맞춤)
                        button.layer.borderWidth = 2
                        button.layer.borderColor = UIColor.white.cgColor
                        
                    }
                }
            }
            return cell
            
        case 3:
            //MARK: - 진행도 셀(1, 2, 3)
            let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as! ProgressTableViewCell
            // 기존의 할일의 진행도를 그리는 부분
            
            let progressCount = self.detailTodoViewModel.todo.value?.progressCount //1번개.tag = 100, 2번개.tag = 101, 3번개.tag = 102 (progressCount를 버튼의 태그와 맞춤)
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
            
            cell.progressButtons.forEach { button in
                button.addTarget(self, action: #selector(progressButtonClicked(sender:)), for: .touchUpInside)
            }
            
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}

extension DetailTodoViewController: UITableViewDelegate {
    
}


//MARK: - 각 셀의 버튼에서 실행할 함수 와 사진첩에 접근해 이미지를 선택하는 @objc func들
extension DetailTodoViewController: UITextViewDelegate {
   
    @objc func titleTextFieldChanged(sender: UITextField) {
        self.detailTodoViewModel.updateTitle(text: sender.text ?? "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.detailTodoViewModel.updateContent(text: textView.text)
    }
    
    @objc func priorityButtonClicked(sender: CustomButton) {
        guard let priorityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? PriorityTableViewCell else { return }
        if sender.tag == 200 {
            self.detailTodoViewModel.updateColorCount(colorCount: 0)

            priorityCell.priorityButtons.forEach { button in
                if button.tag == 200 {
                    selectedPriority(button: button)
                } else {
                    deSelectedPriority(button: button)
                }
            }
            
        } else if sender.tag == 201 {
            self.detailTodoViewModel.updateColorCount(colorCount: 1)

            priorityCell.priorityButtons.forEach { button in
                if button.tag == 201 {
                    selectedPriority(button: button)
                } else {
                    deSelectedPriority(button: button)
                }
            }
            
            
        } else {
            self.detailTodoViewModel.updateColorCount(colorCount: 2)
            
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
        guard let progressCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ProgressTableViewCell else { return }
        if sender.tag == 100 { //빨강
            self.detailTodoViewModel.updateProgressCount(progressCount: 0)
            
            progressCell.progressButtons.forEach { sender in
                if sender.tag <= 100 {
                    sender.tintColor = UIColor.importanceBlue
                } else {
                    sender.tintColor = UIColor.deselectedColor
                }
            }
            
            
        } else if sender.tag == 101 { //노랑
            self.detailTodoViewModel.updateProgressCount(progressCount: 1)
            
            progressCell.progressButtons.forEach { sender in
                if sender.tag <= 101 {
                    sender.tintColor = UIColor.importanceBlue
                } else {
                    sender.tintColor = UIColor.deselectedColor
                }
            }
            
        } else { //파랑
            self.detailTodoViewModel.updateProgressCount(progressCount: 2)
            
            progressCell.progressButtons.forEach { sender in
                sender.tintColor = UIColor.importanceBlue
                
            }
        }
    }
}




