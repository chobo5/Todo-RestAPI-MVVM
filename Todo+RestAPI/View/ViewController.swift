//
//  ViewController.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/01/11.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let todoListViewModel = TodoListViewModel()
    
    private var cellViewModel: TodoListCellViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupTableView()
        setupNavigationbar()
        setupSearchbar()
        setupAddButton()
        
        fetchTodos()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //todo의 isEdited = true인것 업데이트
        updateTodos()
    }
    
    //MARK: - UI Setting
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        self.tableView.sectionHeaderTopPadding = 0.0
    }
    
    private func setupNavigationbar() {
        //네비게이션바 색상 변경(스크롤시 투명하게 바뀌는현상 교정)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .black
        
        //네이게이션바의 타이틀색 변경
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.importanceBlue]
        navigationBarAppearance.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func setupSearchbar() {
        //서치바 UI변경
        self.searchBar.searchTextField.leftView?.tintColor = .white
        self.searchBar.searchTextField.superview?.backgroundColor = .black
        self.searchBar.searchTextField.backgroundColor = UIColor.lightDark
        self.searchBar.searchTextField.textColor = .white
        self.searchBar.showsCancelButton = false
    }
    
    private func setupAddButton() {
        //할일추가버튼 커스텀
        self.addButton.layer.cornerRadius = addButton.frame.size.width / 2
        self.addButton.clipsToBounds = true
        self.addButton.setGradiant(color1: UIColor.gradiant1 ?? UIColor.white, color2: UIColor.gradiant2 ?? UIColor.white, color3: UIColor.gradiant4 ?? UIColor.white, color4: UIColor.gradiant4 ?? UIColor.white)
    }
    
    //MARK: - 모든 할일 받아오기
    private func fetchTodos() {
        TodosAPI.fetchTodos { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todos):
//                print("affag",response)
                self.todoListViewModel.todos = todos.filter{ $0.progressCount != 2}
                self.todoListViewModel.completedTodos = todos.filter { $0.progressCount == 2}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch todos:", error)
            }
        }
    }
    
    //MARK: - 할일 업데이트 하기
    private func updateTodos() {
        self.todoListViewModel.editedTodos().forEach { todo in
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
    
    //MARK: - Action
    @IBAction func addButtonClicked(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailTodo") as? DetailTodoViewController else { return }
        
        let detailViewModel = DetailTodoViewModel(todo: Todo(colorCount: 1,
                                                             content: "",
                                                             createdDate: "", id: 0,
                                                             imageURL: "",
                                                             modifiedDate: "",
                                                             progressCount: 1,
                                                             title: "",
                                                             isEdited: false,
                                                             image: UIImage()),
                                                  isNewTodo: true)
        vc.detailTodoViewModel = detailViewModel
        navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: -talbeView section0: 할일, section1: 완료된 할일
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
        
        headerView.backgroundColor = .black
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        headerLabel.textColor = .white
        
        headerView.addSubview(headerLabel)
        headerLabel.text = todoListViewModel.headerTitle(section)
        return headerView
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print("fava134",todoListViewModel.numberOfTodos)
            return todoListViewModel.numberOfTodos
        } else {
            return todoListViewModel.numberOfCompletedTodos
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
            //뷰모델을 통한 cell에 데이터 적용
            guard let todo = todoListViewModel.todoAtIndex(indexPath.row) else { return UITableViewCell() }
            self.cellViewModel = TodoListCellViewModel(todo: todo)
            cell.configure(with: self.cellViewModel)
            
            cell.selectionStyle = .none
            cell.progressButtons.forEach { button in
                button.addTarget(self, action: #selector(tapProgressButton(sender:)), for: .touchUpInside)
            }
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
            //뷰모델을 통한 cell에 데이터 적용
            guard let todo = todoListViewModel.completedTodoAtIndex(indexPath.row) else { return UITableViewCell()}
            self.cellViewModel = TodoListCellViewModel(todo: todo)
            cell.configure(with: self.cellViewModel)
            
            cell.selectionStyle = .none
            cell.progressButtons.forEach { button in
                button.addTarget(self, action: #selector(tapProgressButton(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailTodo") as? DetailTodoViewController else { return }
        if indexPath.section == 0 {
            let detailViewModel = DetailTodoViewModel(todo: todoListViewModel.todoAtIndex(indexPath.row), isNewTodo: false)
            vc.detailTodoViewModel = detailViewModel
            vc.listViewModel = todoListViewModel
        } else {
            let detailViewModel = DetailTodoViewModel(todo: todoListViewModel.completedTodoAtIndex(indexPath.row), isNewTodo: false)
            vc.detailTodoViewModel = detailViewModel
            vc.listViewModel = todoListViewModel
        }
        
        navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - @objc func
extension ViewController {
    //MARK: - 완료되지 않은 todosArray에서 progressButton을 tap할때
    @objc func tapProgressButton(sender: UIButton) {
        let contentView = sender.superview?.superview //계층: button < stackview < cellView < cell
        guard let cell = contentView?.superview as? UITableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        guard let todoCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as? TodoTableViewCell else { return }
        
        //progressCount와 isEdit 변경
        //listViewModel.updateProgressCount(buttonTag: sender.tag, indexPath: indexPath)
        
        
        if sender.tag == 0 {
            //todoListViewModel의
            todoListViewModel.changeProgressCount(indexPath: indexPath, progressCount: 0)
            //progressCount UI변경
            todoCell.progressButtons.forEach { button in
                if button.tag <= 0 {
                    button.tintColor = UIColor.importanceBlue
                } else {
                    button.tintColor = UIColor.deselectedColor
                }
            }
            
        } else if sender.tag == 1 {
            todoListViewModel.changeProgressCount(indexPath: indexPath, progressCount: 1)
            //progressCount UI변경
            todoCell.progressButtons.forEach { button in
                if button.tag <= 1 {
                    button.tintColor = UIColor.importanceBlue
                } else {
                    button.tintColor = UIColor.deselectedColor
                }
            }
            
        } else {
            todoListViewModel.changeProgressCount(indexPath: indexPath, progressCount: 2)
            todoCell.progressButtons.forEach { button in
                button.tintColor = UIColor.importanceBlue
            }
        }
        //PrgressCount에 따라 배열 이동시켜주기
        self.todoListViewModel.moveTodoElement(indexPath: indexPath) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}



