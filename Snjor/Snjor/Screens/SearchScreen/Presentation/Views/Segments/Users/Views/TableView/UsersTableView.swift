//
//  UsersTableView.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 09.09.2024.
//

import UIKit

final class UsersTableView: UITableView {
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    registerCells()
  }
  
  required init?(coder: NSCoder) {
    fatalError(ErrorMessage.initCoderNotImplementedError)
  }
  
  private func registerCells() {
    self.register(
      UserTableViewCell.self,
      forCellReuseIdentifier: UserTableViewCell.reuseID
    )
  }
}
