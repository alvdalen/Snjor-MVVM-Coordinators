//
//  TopicPhotoCellDelegate.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 04.09.2024.
//

protocol TopicPhotoCellDelegate: AnyObject {
  func downloadTapped(_ cell: TopicPhotoCell)
}