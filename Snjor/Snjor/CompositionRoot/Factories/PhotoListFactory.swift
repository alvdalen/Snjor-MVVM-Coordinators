//
//  PhotoListFactory.swift
//  Snjor
//
//  Created by Адам on 16.06.2024.
//

import UIKit
import Combine

protocol PhotoListFactoryProtocol {
  func makeModule(
    delegate: any PhotoListViewControllerDelegate
  ) -> UIViewController
  func makeTabBarItem(navigation: any Navigable)
  func mekePhotoDetailCoordinator(
    photo: Photo,
    navigation: any Navigable,
    overlordCoordinator: any ParentCoordinator
  ) -> any Coordinatable
}

struct PhotoListFactory: PhotoListFactoryProtocol {
  // MARK: - Internal Methods
  func makeModule(
    delegate: any PhotoListViewControllerDelegate
  ) -> UIViewController {
    let apiClient = NetworkService()
    let state = PassthroughSubject<StateController, Never>()
    let photoRepository = PhotoListRepository(apiClient: apiClient)
    let lastPageValidationUseCase = LastPageValidationUseCase()
    let loadPhotoListUseCase = LoadPhotoListUseCase(
      photoListRepository: photoRepository
    )
    let viewModel = PhotoListViewModel(
      state: state, 
      loadPhotosUseCase: loadPhotoListUseCase,
      pagingGenerator: lastPageValidationUseCase
    )

    let defaultLayout = UICollectionViewLayout()
    let module = PhotoListCollectionViewController(
      viewModel: viewModel,
      delegate: delegate,
      layout: defaultLayout
    )
    let cascadeLayout = MultiColumnCascadeLayout(with: module)
    module.collectionView.collectionViewLayout = cascadeLayout
    module.collectionView.showsVerticalScrollIndicator = false
    module.collectionView.register(
      PhotoCell.self,
      forCellWithReuseIdentifier: PhotoCell.reuseID
    )
    return module
  }

  func makeTabBarItem(navigation: any Navigable) {
    makeTabBarItem(
      navigation: navigation,
      title: .photoListTitle,
      systemImageName: .photoListItemImage,
      selectedSystemImageName: .photoListSelectedItemImage
    )
  }

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

// MARK: - TabBarItemFactory
extension PhotoListFactory: TabBarItemFactory { }