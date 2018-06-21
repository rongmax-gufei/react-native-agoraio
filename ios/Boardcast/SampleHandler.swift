//
//  SampleHandler.swift
//  Boardcast
//
//  Created by Learnta on 2018/6/7.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
//        if let setupInfo = setupInfo, let channel = setupInfo["channelName"] as? String, let uid = setupInfo["uid"] as? String {
        if let setupInfo = setupInfo, let channel = setupInfo["channel"] as? String, let uid = setupInfo["uid"] as? String {
            //In-App Screen Capture
            AgoraUploader.startBroadcast(to: channel, uid: uid)
        } else {
            //iOS Screen Record and Broadcast
            AgoraUploader.startBroadcast(to: "channel", uid: "0")
        }
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        AgoraUploader.stopBroadcast()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        DispatchQueue.main.async {
            switch sampleBufferType {
            case RPSampleBufferType.video:
                AgoraUploader.sendVideoBuffer(sampleBuffer)
                break
            case RPSampleBufferType.audioApp:
                AgoraUploader.sendAudioAppBuffer(sampleBuffer)
                break
            case RPSampleBufferType.audioMic:
                AgoraUploader.sendAudioMicBuffer(sampleBuffer)
                break
            }
        }
    }
}
