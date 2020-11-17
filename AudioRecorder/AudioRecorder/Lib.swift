//
//  Lib.swift
//  AudioRecorder
//
//  Created by akrolayer on 2020/11/18.
//  Copyright © 2020 akrolayer. All rights reserved.
//

import Foundation

class Lib{
    func getAudioFileUrl(FileName:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        
        let audioUrl = docsDirect.appendingPathComponent(FileName)

        return audioUrl
    }
}
