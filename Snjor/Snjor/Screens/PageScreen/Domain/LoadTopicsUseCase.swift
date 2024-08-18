//
//  LoadTopicsUseCase.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 23.07.2024.
//

import Foundation

protocol LoadTopicsUseCaseProtocol {
  func execute() async -> Result<[Topic], any Error>
}

struct LoadTopicsUseCase: LoadTopicsUseCaseProtocol {
  // MARK: - Private Properties
  let repository: any LoadTopicsPageRepositoryProtocol
  
  // MARK: - Internal Methods
  func execute() async -> Result<[Topic], any Error> {
    do {
      let request = try RequestController.topicsTitleRequest()
      let topics = try await repository.fetchTopic(request: request)
      return .success(topics)
    } catch {
      return .failure(error)
    }
  }
}