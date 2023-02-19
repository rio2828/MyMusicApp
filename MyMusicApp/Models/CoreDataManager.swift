//
//  CoreDataManager.swift
//  MyMusicApp
//
//  Created by 김태현 on 2023/01/30.
//

import UIKit
import CoreData

final class CoreDataManager {
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔티티 이름 (코어데이터에 저장된 객체)
    let modelName: String = "MusicSavedData"
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getMusicSavedArrayFromCoreData() -> [MusicSavedData] {
        var savedMusicList: [MusicSavedData] = []
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 정렬순서를 정해서 요청서에 넘겨주기
            let savedDate = NSSortDescriptor(key: "savedDate", ascending: true)
            request.sortDescriptors = [savedDate]
            
            do {
                // 임시저장소에서 요청을 통해 데이터 가져오기
                if let fetchedMusicList = try context.fetch(request) as? [MusicSavedData] {
                    savedMusicList = fetchedMusicList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }
        
        return savedMusicList
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기 (Music ===> MusicSavedData)
    func saveMusic(with music: Music, message: String?, completion: @escaping () -> Void) {
        // 임시저장소 확인
        if let context = context {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                
                //임시저장소에 올라가게할 객체 만들기 (NSManagedObject ===> MusicSavedData)
                if let musicSavedData = NSManagedObject(entity: entity, insertInto: context) as? MusicSavedData {
                    
                    // MARK: - MusicSavedData에 실제 데이터 할당
                    musicSavedData.songName = music.songName
                    musicSavedData.artistName = music.artistName
                    musicSavedData.albumName = music.albumName
                    musicSavedData.imageUrl = music.imageUrl
                    musicSavedData.releaseDate = music.releaseDateString
                    musicSavedData.savedDate = Date()    // 날짜는 저장하는 순간의 날짜로 생성
                    musicSavedData.myMessage = message   // 추가적으로 저장할 메세지
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 삭제)
    func deleteMusic(with music: MusicSavedData, completion: @escaping () -> Void) {
        // 날짜 옵셔널 바인딩
        guard let savedDate = music.savedDate else {
            completion()
            return
        }
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch 메서드)
                if let fetchedMusicList = try context.fetch(request) as? [MusicSavedData] {
                    
                    // 임시저장소에서 요청을 통해 데이터 삭제하기 (delete 메서드)
                    if let targetMusic = fetchedMusicList.first {
                        context.delete(targetMusic)
                        
                        //appDelegate?.saveContext() - 앱델리게이트의 메서드로도 가능
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
    
    //MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 -> 수정)
    func updateMusic(with music: MusicSavedData, completion: @escaping () -> Void) {
        // 날짜 옵셔널 바인딩
        guard let savedDate = music.savedDate else {
            completion()
            return
        }
        
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedMusicList = try context.fetch(request) as? [MusicSavedData] {
                    // 배열의 첫번째
                    if var targetMusic = fetchedMusicList.first {
                        
                        // MARK: - ToDoData에 실제 데이터 재할당(바꾸기)
                        targetMusic = music
                        
                        //appDelegate?.saveContext() 로도 가능
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                        
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
}
