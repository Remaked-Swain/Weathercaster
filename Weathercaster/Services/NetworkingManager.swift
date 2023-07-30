//
//  NetworkingManager.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/30.
//

import Foundation
import Combine

class NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "URL: \(url) 의 응답에 문제가 있습니다."
            case .unknown: return "알 수 없는 에러."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        // Working on DispatchQueue.global
            .subscribe(on: DispatchQueue.global())
        // 서버 응답 체크
            .tryMap({ try handleURLResponse(output: $0, url: url) })
        // Working on DispatchQueue.main
            .receive(on: DispatchQueue.main)
        // 게시자를 지워서 타입 간결하게 하기
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else { throw NetworkingError.badURLResponse(url: url) }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: break
        case .failure(let error): print("Completion Error: \(error)")
        }
    }
}
