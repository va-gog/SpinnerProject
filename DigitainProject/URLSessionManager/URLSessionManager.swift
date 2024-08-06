//
//  URLSessionManager.swift
//  DigitainProject
//
//  Created by Gohar Vardanyan on 8/2/24.
//

import Foundation
import Combine

struct URLSessionManager: URLSessionManagerProtocol {
    func dataTaskPublisher(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map {
                $0.data
            }
           .mapError { error in 
               error
           }
           .eraseToAnyPublisher()
    }
    
    func dataFrom(url: URL)  async throws -> (Data, URLResponse) {
       try await URLSession.shared.data(from: url)
    }
}
