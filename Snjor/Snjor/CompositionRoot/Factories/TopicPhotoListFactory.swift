//
//  TopicsPhotoListFactory.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 25.07.2024.
//

import UIKit
import Combine

protocol TopicsPagePhotoListFactoryProtocol {
  func makeModule(
    delegate: any TopicPhotoListCollectionViewControllerDelegate
  ) -> UIViewController
//  func makeTabBarItem(navigation: any Navigable)
  func mekePhotoDetailCoordinator(
    photo: Photo,
    navigation: any Navigable,
    overlordCoordinator: any ParentCoordinator
  ) -> any Coordinatable
}

struct TopicsPagePhotoListFactory: TopicsPagePhotoListFactoryProtocol {
  
  let topic: Topic
  
  func makeModule(
    delegate: any TopicPhotoListCollectionViewControllerDelegate
  ) -> UIViewController {
    let networkService = NetworkService()
    let lastPageValidationUseCase = LastPageValidationUseCase()
    let state = PassthroughSubject<StateController, Never>()
    let repository = LoadPageTopicsPhotoListRepository(
      networkService: networkService
    )
    let loadUseCase = LoadTopicsPagePhotoListUseCase(
      repository: repository,
      topic: topic
    )
    let viewModel = TopicPhotoListViewModel(
      state: state,
      loadUseCase: loadUseCase,
      lastPageValidationUseCase: lastPageValidationUseCase
    )
    let defaultLayout = UICollectionViewLayout()
    let module = TopicPhotoListCollectionViewController(
      viewModel: viewModel,
      delegate: delegate,
      layout: defaultLayout
    )
    let cascadeLayout = SingleColumnCascadeLayout(with: module)
    module.collectionView.collectionViewLayout = cascadeLayout
    module.collectionView.showsVerticalScrollIndicator = false
    module.collectionView.register(
      PhotoCell.self,
      forCellWithReuseIdentifier: PhotoCell.reuseID
    )
    return module
  }
  
//  func makeTabBarItem(navigation: any Navigable) {
//    
//  }
  
  func mekePhotoDetailCoordinator(
    photo: Photo,
    navigation: any Navigable,
    overlordCoordinator: any ParentCoordinator
  ) -> any Coordinatable {
    let factory = PhotoDetailFactory(photo: photo)
    let coordinator = PhotoDetailCoordinator(
      factory: factory,
      navigation: navigation,
      overlordCoordinator: overlordCoordinator
    )
    return coordinator
  }
}