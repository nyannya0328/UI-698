//
//  Card.swift
//  UI-698
//
//  Created by nyannyan0328 on 2022/10/15.
//

import SwiftUI

struct Card: Identifiable {
    
    var id = UUID().uuidString
    var imageName : String
    var isRotated : Bool = false
    var extractOffset : CGFloat = 0
    var scale : CGFloat = 1
    var zIndex : Double = 0
  
}

