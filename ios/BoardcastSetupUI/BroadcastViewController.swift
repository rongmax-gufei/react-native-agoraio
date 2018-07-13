//
//  BroadcastViewController.swift
//
//  Created by Learnta on 2018/6/20.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

import ReplayKit

class BroadcastViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userStartBroadcast(withChannel: get_channel(), uid: get_uid())
    }
    
    @IBAction func doCancelPressed(_ sender: UIButton) {
        userDidCancelSetup()
    }
}

func get_channel() -> String {
    let channel = UserDefaults.init(suiteName: "group.ilive.broadcast")?.string(forKey: "channel")
    if(channel != nil){
        return channel!
    } else {
        return ""
    }
}

func get_uid() -> String {
    let uid = UserDefaults.init(suiteName: "group.ilive.broadcast")?.string(forKey: "uid")
    if(uid != nil){
        return uid!
    } else {
        return ""
    }
}

private extension BroadcastViewController {
    func userStartBroadcast(withChannel channel: String?, uid: String?) {
        guard let channel = channel, !channel.isEmpty else {
            userDidCancelSetup()
            return
        }
        
        guard let uid = uid, !uid.isEmpty else {
            userDidCancelSetup()
            return
        }
        
        let setupInfo: [String: NSCoding & NSObjectProtocol] =  [ "channel" : channel as NSString, "uid" : uid as NSString]
        extensionContext?.completeRequest(withBroadcast: URL(string: "http://vid-130451.hls.fastweb.broadcastapp.agoraio.cn/live/\(channel)/index.m3u8")!, setupInfo: setupInfo)
    }
    
    func userDidCancelSetup() {
        let error = NSError(domain: "com.learnta.screenshare.BroadcastSetupUI", code: -1, userInfo: nil)
        extensionContext?.cancelRequest(withError: error)
    }
    
}
