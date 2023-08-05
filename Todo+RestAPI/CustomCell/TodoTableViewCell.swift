//
//  TodoTableViewCell.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/01/11.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet weak var importanceColorBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var progressButtons: [UIButton]!
    
    var cellViewModel: TodoListCellViewModel?
    var listViewModel: TodoListViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 5
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    @IBAction func TabProgressButtons(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        let contentView = button.superview?.superview
        
        guard let cell = contentView?.superview as? UITableViewCell else { return }
        
        let tableView = cell.superview as! UITableView
        
        if let indexPath = tableView.indexPath(for: cell) {
            if button.tag == 0 {
                //todoListCellViewModel의 progressCount변경
                self.cellViewModel?.changeProgressCount(progressCount: 0)
                //progressCount UI변경
                self.progressButtons.forEach { button in
                    if button.tag <= 0 {
                        button.tintColor = UIColor.importanceBlue
                    } else {
                        button.tintColor = UIColor.deselectedColor
                    }
                }
                
            } else if button.tag == 1 {
                //todoListCellViewModel의 progressCount변경 & 전달
                self.cellViewModel?.changeProgressCount(progressCount: 1)
                //progressCount UI변경
                self.progressButtons.forEach { button in
                    if button.tag <= 1 {
                        button.tintColor = UIColor.importanceBlue
                    } else {
                        button.tintColor = UIColor.deselectedColor
                    }
                }
                
            } else {
                //todoListCellViewModel의 progressCount변경 & 전달
                self.cellViewModel?.changeProgressCount(progressCount: 2)
                //progressCount UI변경
                self.progressButtons.forEach { button in
                    button.tintColor = UIColor.importanceBlue
                }
            }
    
            self.listViewModel?.updateTodoArray(todo: self.cellViewModel?.todo, indexPath: indexPath)
        }
        
    }
    
//     Cell 데이터 적용
    func configure(with viewModel: TodoListCellViewModel) {
        let id: Int = viewModel.id
        let title: String = viewModel.title
        let progressCount: Int = viewModel.progressCount
        let importanceColor: Int = viewModel.colorCount

        //할일 ID와 제목 설정
        self.titleLabel.text = "ID: \(id) - \(title)"

        //할일 진행도(번개모양) 설정 0 - 1개, 1 - 2개, 2 - 3개
        switch progressCount {
        case 0:
            progressButtons[0].tintColor = UIColor.importanceBlue
            progressButtons[1].tintColor = UIColor.deselectedColor
            progressButtons[2].tintColor = UIColor.deselectedColor
        case 1:
            progressButtons[0].tintColor = UIColor.importanceBlue
            progressButtons[1].tintColor = UIColor.importanceBlue
            progressButtons[2].tintColor = UIColor.deselectedColor
        case 2:
            progressButtons[0].tintColor = UIColor.importanceBlue
            progressButtons[1].tintColor = UIColor.importanceBlue
            progressButtons[2].tintColor = UIColor.importanceBlue
        default:
            progressButtons[0].tintColor = UIColor.deselectedColor
            progressButtons[1].tintColor = UIColor.deselectedColor
            progressButtons[2].tintColor = UIColor.deselectedColor
        }

        //할일 중요도 설정 0 - 빨강, 1 - 노랑, 2 - 파랑
        switch importanceColor {
        case 0:
            importanceColorBar.backgroundColor = UIColor.importanceRed
        case 1:
            importanceColorBar.backgroundColor = UIColor.importanceYellow
        case 2:
            importanceColorBar.backgroundColor = UIColor.importanceBlue
        default:
            importanceColorBar.backgroundColor = UIColor.white
        }
    }

}
