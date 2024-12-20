//
//  TopicsPhotoListFactory.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 25.07.2024.
//

import UIKit
import Combine

struct PageScreenTopicPhotosFactory: PageScreenTopicPhotosFactoryProtocol {
  // MARK: Internal Properties
  let topic: Topic
  
  // MARK: Internal Methods
  func makeController(
    delegate: any PageScreenPhotosViewControllerDelegate
  ) -> UIViewController {
    let viewModel = createViewModel()
    let controller = createViewController(viewModel: viewModel, delegate: delegate)
    configureLayout(for: controller)
    return controller
  }
  
  // MARK: Private Methods
  private func createViewModel() -> TopicPhotosViewModel {
    let networkService = NetworkService()
    let lastPageValidationUseCase = LastPageValidationUseCase()
    let state = PassthroughSubject<StateController, Never>()
    let repository = LoadTopicPhotosRepository(networkService: networkService)
    let requestController = RequestController()
    let loadUseCase = LoadTopicPhotosUseCase(
      repository: repository,
      requestController: requestController,
      topic: topic
    )
    return TopicPhotosViewModel(
      loadUseCase: loadUseCase,
      lastPageValidationUseCase: lastPageValidationUseCase,
      state: state
    )
  }
  
  private func createViewController(
    viewModel: TopicPhotosViewModel,
    delegate: any PageScreenPhotosViewControllerDelegate
  ) -> PageScreenPhotosViewController {
    let defaultLayout = UICollectionViewLayout()
    let controller = PageScreenPhotosViewController(
      viewModel: viewModel,
      delegate: delegate,
      layout: defaultLayout
    )
    controller.rootView.pageScreenPhotosCollectionView.showsVerticalScrollIndicator = false
    return controller
  }
  
  private func configureLayout(
    for controller: PageScreenPhotosViewController
  ) {
    let cascadeLayout = SingleColumnCascadeLayout(with: controller)
    controller.rootView.pageScreenPhotosCollectionView.collectionViewLayout = cascadeLayout
  }
}
