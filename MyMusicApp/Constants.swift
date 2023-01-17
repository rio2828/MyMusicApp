//
//  Constants.swift
//  MyMusicApp
//
//  Created by 김태현 on 2023/01/15.
//

import Foundation

//MARK: - Name Space 만들기

// 데이터 영역에 저장되는 API 문자열 묶음
public enum MusicApi {
    static let requestUrl = "https://itunes.apple.com/search?"
    static let mediaParam = "media=music"
}

// 사용하게될 Cell 문자열 묶음
public struct Cell {
    static let musicCellIdentifier = "MusicCell"
    static let musicColletionViewCellIdentifier = "MusicCollectionViewCell"
    private init() {}
}

// 컬렉션뷰 구성을 위한 설정
public struct CVCell {
    static let spacingWidth: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}
