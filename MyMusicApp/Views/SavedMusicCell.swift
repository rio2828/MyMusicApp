//
//  SavedMusicCell.swift
//  MyMusicApp
//
//  Created by 김태현 on 2023/01/30.
//

import UIKit

final class SavedMusicCell: UITableViewCell {

    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var savedDateLabel: UILabel!
    @IBOutlet weak var commentMessageLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var musicSavedData: MusicSavedData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀 (자신)을 전달)
    var saveButtonPressed: ((SavedMusicCell) -> ()) = { (sender) in }
    
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정. 셀(자신)/텍스트도 전달)
    var updateButtonPressed: ((SavedMusicCell, String?) -> ()) = { (sender, text) in }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해 실행
        self.mainImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUpdateButton()
    }

    private func setupUpdateButton() {
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUIwithData() {
        guard let musicSavedData = musicSavedData else { return }
        loadImage(with: musicSavedData.imageUrl)
        songNameLabel.text = musicSavedData.songName
        artistNameLabel.text = musicSavedData.artistName
        albumNameLabel.text = musicSavedData.albumName
        releaseDateLabel.text = musicSavedData.releaseDate
        savedDateLabel.text = "Saved Date: \(musicSavedData.savedDateString ?? "")"
        commentMessageLabel.text = musicSavedData.myMessage
        setButtonStatus()
    }
    
    // URL ==> 이미지를 셋팅하는 메서드
    private func loadImage(with imageUrl: String?) {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // 자신 SavedMusicCell을 전달하면서 뷰컨트롤러에서 전달받은 클로저를 실행
        saveButtonPressed(self)
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self, musicSavedData?.myMessage)
    }
    
    func setButtonStatus() {
        saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        saveButton.tintColor = .red
    }
    
    
    
}
