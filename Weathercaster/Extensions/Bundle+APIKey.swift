//
//  Bundle.swift
//  Weathercaster
//
//  Created by Swain Yun on 2023/07/28.
//

import Foundation

extension Bundle {
    func getAPIKey(for openKey: String) -> String? {
        guard
            let url = self.url(forResource: "ApiKeys", withExtension: "plist"),
            let data = try? Data(contentsOf: url)
        else { print("Bundle 에서 ApiKeys.plist를 찾을 수 없습니다."); return nil }
        
        do {
            let plistData = try PropertyListSerialization.propertyList(from: data, format: nil)
            if let dict = plistData as? [String:String], let apiKey = dict[openKey] {
                return apiKey
            } else {
                print("ApiKeys[\(openKey)] 값을 찾을 수 없습니다."); return nil
            }
        } catch {
            print("ApiKeys 를 읽는 중 문제가 발생했습니다. \(error)")
            return nil
        }
    }
}
