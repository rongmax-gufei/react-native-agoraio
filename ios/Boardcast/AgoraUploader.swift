//
//  AgoraUploader.swift
//
//  Created by Learnta on 2018/6/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

import Foundation
import CoreMedia

class AgoraUploader {
    private static let videoResolution : CGSize = {
        let width : CGFloat
        let height : CGFloat
        let screenSize = UIScreen.main.currentMode!.size
        if screenSize.width <= screenSize.height {
            if screenSize.width * 16 <= screenSize.height * 9 {
                width = 640 * screenSize.width / screenSize.height
                height = 640
            }
            else {
                width = 360
                height = 360 * screenSize.height / screenSize.width
            }
        }
        else {
            if screenSize.width * 9 <= screenSize.height * 16 {
                width = 360 * screenSize.width / screenSize.height
                height = 360
            }
            else {
                width = 640
                height = 640 * screenSize.height / screenSize.width
            }
        }

        return CGSize(width: width, height: height)
    }()
    
    private static let sharedAgoraEngine: AgoraRtcEngineKit = {
        let kit = AgoraRtcEngineKit.sharedEngine(withAppId: get_appid(), delegate: nil)
        kit.setChannelProfile(.liveBroadcasting)
        kit.setClientRole(.broadcaster)

        kit.enableVideo()
        kit.setExternalVideoSource(true, useTexture: true, pushMode: true)
        kit.setVideoResolution(videoResolution, andFrameRate:15, bitrate:400)
        kit.setParameters("{\"che.hardware_encoding\":0}")
        kit.setParameters("{\"che.video.compact_memory\":true}")

        AgoraAudioProcessing.registerAudioPreprocessing(kit)
        kit.setRecordingAudioFrameParametersWithSampleRate(44100, channel: 1, mode: .readWrite, samplesPerCall: 1024)
        kit.setParameters("{\"che.audio.external_device\":true}")

        kit.muteAllRemoteVideoStreams(true)
        kit.muteAllRemoteAudioStreams(true)

        return kit
    }()

    static func startBroadcast(to channel: String, uid: String) {
        sharedAgoraEngine.joinChannel(byToken: nil, channelId: channel, info: nil, uid: UInt(uid)!, joinSuccess: nil)
    }

    static func sendVideoBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard let videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer)
             else {
            return
        }

        let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        let frame = AgoraVideoFrame()
        frame.format = 12
        frame.time = time
        frame.textureBuf = videoFrame
        sharedAgoraEngine.pushExternalVideoFrame(frame)
    }

    static func sendAudioAppBuffer(_ sampleBuffer: CMSampleBuffer) {
        AgoraAudioProcessing.pushAudioAppBuffer(sampleBuffer)
    }

    static func sendAudioMicBuffer(_ sampleBuffer: CMSampleBuffer) {
        AgoraAudioProcessing.pushAudioMicBuffer(sampleBuffer)
    }

    static func stopBroadcast() {
        sharedAgoraEngine.leaveChannel(nil)
    }
    
    static func get_appid() -> String {
        let appid = UserDefaults.init(suiteName: "group.ilive.broadcast")?.string(forKey: "appid")
        if(appid != nil){
            return appid!
        } else {
            return ""
        }
    }
}
