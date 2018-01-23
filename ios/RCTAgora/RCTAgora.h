//
//  RCTAgora.h
//  RCTAgora
//
//  Created by Learnta on 2017/12/21.
//  Copyright © 2017年 Learnta Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface RCTAgora : NSObject<RCTBridgeModule, AgoraRtcEngineDelegate>

@end
