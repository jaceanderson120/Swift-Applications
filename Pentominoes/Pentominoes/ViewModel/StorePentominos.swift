//
//  StorePentominos.swift
//  Pentominoes
//
//  Created by Jace Anderson on 9/22/24.
//


import Foundation

class StorePentominos<T : Codable> {
    var modelData : T?
    var fileName = "PentominoOutlines"
    
    init() {
        let fileUrl = URL.documentsDirectory.appendingPathComponent(fileName)
        
        if (FileManager.default.fileExists(atPath: fileUrl.path)) {
            do {
                let decoder = JSONDecoder()
                let content = try Data(contentsOf: fileUrl)
                modelData = try decoder.decode(T.self, from: content)
            } catch {
                print(error)
                modelData = nil
            }
            return
        }
        
        let bundle = Bundle.main
        let url = bundle.url(forResource: fileName, withExtension: "json")
        
        guard let url = url else {modelData = nil; return}
        
        do {
            let decoder = JSONDecoder()
            let content = try Data(contentsOf: url)
            modelData = try decoder.decode(T.self, from: content)
        } catch {
            modelData = nil
        }
    }
    
    func save(components: T) {
        let encoder = JSONEncoder()
        let url = URL.documentsDirectory.appendingPathComponent(fileName)
        do {
            let data = try encoder.encode(components)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
}
