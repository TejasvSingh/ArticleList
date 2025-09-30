//
//  CountryViewModel.swift
//  ArticleList
//
//  Created by Tejasv Singh on 9/18/25.
//
import Foundation
struct Country: Decodable{
    let capital : String?
    let code : String?
    var name : String?
    let region : String?
}

@propertyWrapper
struct AppendComma {
    private var storage: String?

    var wrappedValue: String? {
        get { storage }
        set {
            if let value = newValue {
                storage = value + ","
            }
        }
    }

    init(wrappedValue: String?) {
        if let value = wrappedValue {
            self.storage = value + ","
        }
    }
}
