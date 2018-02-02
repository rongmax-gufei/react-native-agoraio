//
//  AGVideoPreProcessing.h
//  OpenVideoCall
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGRenderManager.h"

@class AgoraRtcEngineKit;

@interface AGVideoPreProcessing : NSObject

+ (void)setViewControllerDelegate:(id)viewController;
+ (int) registerVideoPreprocessing:(AgoraRtcEngineKit*) kit;
+ (int) deregisterVideoPreprocessing:(AgoraRtcEngineKit*) kit;

@end
		
