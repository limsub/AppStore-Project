//
//  BasicAPIManager.swift
//  AppStoreProject
//
//  Created by 임승섭 on 2023/11/08.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknown
    case statusError
}

class BasicAPIManager {
    
    static func fetchInitialData(_ term: String) -> Observable<SearchAppModel> {
        
        return Observable<SearchAppModel>.create { value in
            
            guard let txt = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return Disposables.create() }
            
            let urlString = "https://itunes.apple.com/search?term=\(txt)&country=KR&media=software&lang=ko_KR&limit=30"
            
            guard let url = URL(string: urlString) else {
                value.onError(APIError.invalidURL) // 에러 전달 -> dispose
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data , response , error  in
                print("URLSession Success")
                
                if let _ = error {
                    value.onError(APIError.unknown)
                    return  // 컴플리션핸들러의 리턴 타입은 void. (여긴 create의 리턴이 아니다)
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self , from: data) {
                    value.onNext(appData)
                }
            }.resume()
            
            return Disposables.create()
        }
    }
    
    
    
    static func appendData(_ term: String, offset: Int, completionHandler: @escaping (Result<SearchAppModel, APIError>) -> Void) {
        
        guard let txt = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let urlString = "https://itunes.apple.com/search?term=\(txt)&country=KR&media=software&lang=ko_KR&limit=30&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data , response , error  in
            print("URLSession Success")
            
            if let _ = error {
                completionHandler(.failure(.unknown))
                return  // 컴플리션핸들러의 리턴 타입은 void. (여긴 create의 리턴이 아니다)
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.statusError))
                return
            }
            
            if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self , from: data) {
                completionHandler(.success(appData))
                return
            }
        }.resume()
    }
}
