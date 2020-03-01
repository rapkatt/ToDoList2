//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Brian on 6/19/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {

    var text: String?
    var extraText: String?
    var checked: Bool?
    
    func toggleChecked() {
        checked = !checked!
    }
    
    init(text: String = "", extraText: String = "", checked: Bool = false) {
        self.text = text
        self.extraText = extraText
        self.checked = checked
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.text, forKey: "text")
        coder.encode(self.extraText, forKey: "extraText")
        coder.encode(checked, forKey: "checked")
    }
    
    
    init(json: [String: Any]) {
        self.text = json["text"] as? String
        self.checked = json["checked"] as? Bool
        self.extraText = json["extraText"] as? String
    }

    
    required init?(coder aDecoder: NSCoder)
    {
        self.text = aDecoder.decodeObject(forKey: "text") as? String
        self.checked = aDecoder.decodeObject(forKey: "checked") as? Bool
        self.extraText = aDecoder.decodeObject(forKey: "extraText") as? String
    }

}


