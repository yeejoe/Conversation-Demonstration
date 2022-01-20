//
//  FileUtils.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import Foundation

class FileUtils{
    static func readFileFromBundle(fileName : String) -> Any?{
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult
            } catch {
                   // handle error
            }
        }
        
        return nil
    }
}
