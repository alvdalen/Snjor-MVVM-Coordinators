//
//  lastPageValidationUseCaseProtocol.swift
//  Snjor
//
//  Created by Адам on 15.06.2024.
//

protocol lastPageValidationUseCaseProtocol {
  var lastPage: Bool { get }
  mutating func updateLastPage(itemsCount: Int)
  func checkAndLoadMoreItems(
    at itemIndex: Int,
    actualItems: Int,
    action: () -> Void
  )
}