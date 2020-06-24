//
//  Storage.swift
//  IOS-MyNoteBook-week7
//
//  Created by Rasmus Knoth Nielsen on 24/06/2020.
//  Copyright © 2020 Rasmus Knoth Nielsen. All rights reserved.
//

import Foundation

class Storage {
    
    private static var _list = read()
    
    static var filename = "MyNoteBook.txt"
    
    static func read() -> [String] {
        let path = getDocumentDir().appendingPathComponent(filename)
        if let arr = NSArray(contentsOf: path) as? [String] {
            return arr
        }
        return [String]()
    }
    
    static func addItem(str:String) {
        _list.append(str)
        save()
    }
    
    static func getItem(index: Int) -> String {
        return _list[index]
    }
    
    private static func save() {
        let nsArr = _list as NSArray
        let path = getDocumentDir().appendingPathComponent(filename)
        nsArr.write(to: path, atomically: true)
    }
    
    static func remove(index: Int) {
        _list.remove(at: index)
        save()
    }
    
    static func update(str: String, index: Int) {
        _list[index] = str
        save()
    }
    
    static func count() -> Int {
        return _list.count
    }
    

    
    // Function used to get the correct location on the operating system
    static func getDocumentDir() -> URL
    {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDir[0]
    }

    
}
