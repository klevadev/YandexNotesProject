//
//  Note.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

enum Importance: Int {
    case insignificant = 0
    case common = 1
    case important = 2
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = .white, importance: Importance = .common, selfDestructionDate : Date? = nil) {
        
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}

extension Note {
    var json: [String: Any] {
        get {
            var dict : [String: Any] = [:]
            dict["uid"] = self.uid
            dict["title"] = self.title
            dict["content"] = self.content
            dict["color"] = self.color == .white ? nil : self.color.rgba
            // 1 - обычная важность.
            dict["importance"] = self.importance.rawValue == 1 ? nil : self.importance.rawValue
            
            if let date = self.selfDestructionDate?.timeIntervalSince1970 {
                dict["selfDestructionDate"] = Int(date)
            }
            return dict
        }
    }
    
    
    static func parse(json: [String: Any]) -> Note? {
        guard
            let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String else {
                return nil
            }
        
        return Note(uid: uid,
                    title: title,
                    content: content,
                    color: json["color"] == nil ? .white : UIColor.rgbaToUIColor(json["color"] as! [CGFloat]),
                    importance: Importance.init(rawValue: (json["importance"] as? Int ?? 1))!,
                    selfDestructionDate: json["selfDestructionDate"] == nil ? nil : Date.init(timeIntervalSince1970: Double(json["selfDestructionDate"] as! Int)))
    }
    
}
