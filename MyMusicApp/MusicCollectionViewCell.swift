//
//  MusicCollectionViewCell.swift
//  MyMusicApp
//
//  Created by 김태현 on 2023/01/16.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var mainImageView: UIImageView!
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // URL -> 이미지를 셋팅
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        // 오래걸리는 작업을 동시성 처리 (다른 쓰레드로)
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드
            // 일반적으로 이미지를 가져올 때 많이 사용
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래 걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard self.imageUrl! == url.absoluteString else { return }
            
            // 작업의 결과물을 이미지로 표시 (메인큐)
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data:data)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageView.image = nil
    }
}
