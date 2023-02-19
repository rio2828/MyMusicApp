//
//  NetworkManager.swift
//  MyMusicApp
//
//  Created by 김태현 on 2023/01/15.
//

import Foundation

//MARK: - 에러 정의
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신) 클래스 모델
final class NetworkManager {
    
    // 여러화면에서 통신한다면, 싱글톤으로 만듬
    static let shared = NetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    
    // 실제 Request하는 함수 (비동기적 실행 -> 클로저 방식으로 끝난 시점으로 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 데이터 분석하기
            if let musics = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
    private func parseJSON(_ musicData: Data) -> [Music]? {
        
        // 성공
        do {
            // 구조체(클래스)로 변환하는 메서드
            // JSON 데이터 -> MusicData 클래스
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
            
            // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
