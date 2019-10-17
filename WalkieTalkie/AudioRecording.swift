//
//  AudioRecording.swift
//  WalkieTalkie
//
//  Created by Kittiphong Xayasane on 2019-10-17.
//  Copyright © 2019 Kittiphong Xayasane. All rights reserved.
//

import UIKit

class AudioRecording: NSObject {
    var title: String?
    var filePath: URL?
    
    init(_ title: String?, filePath: URL?) {
        self.title = title
        self.filePath = filePath
    }
}
