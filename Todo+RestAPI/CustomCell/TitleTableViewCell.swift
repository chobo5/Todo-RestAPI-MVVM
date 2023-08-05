//
//  TitleTableViewCell.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/01/21.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    
    var viewModel: DetailTodoViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.setPlaceholderColor(.systemGray)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData() {
        
        titleTextField.text = viewModel?.todo.value?.title ?? ""
    }
    
    
}
