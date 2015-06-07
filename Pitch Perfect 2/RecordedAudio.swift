//
//  RecordedAudio.swift
//  Pitch Perfect 2
//
//  Created by Kenji Golimlim on 5/14/15.
//  Copyright (c) 2015 Kenji Golimlim. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
  var filePathUrl: NSURL!
  var title: String!
  
  // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html
  
  init(filePathUrl: NSURL!, title: String!){
    self.filePathUrl = filePathUrl
    self.title = title
  }
}