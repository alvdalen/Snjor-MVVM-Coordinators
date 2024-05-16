//
//  OverlordCoordinator.swift
//  Snjor
//
//  Created by Адам on 16.05.2024.
//

protocol OverlordCoordinator: AnyObject {
  var childCoordinators: [Coordinatable] { get set }
}

// MARK: - Default Methods
extension OverlordCoordinator {
  func addAndStartChildCoordinator(
    _ coordinator: Coordinatable?
  ) {
    guard let childCoordinator = coordinator else { return }
    childCoordinators.append(childCoordinator)
    childCoordinator.start()
  }

  func removeChildCoordinator(
    _ coordinator: Coordinatable
  ) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }

  func removeAllChildCoordinators() {
    childCoordinators = []
  }
}
