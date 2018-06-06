//
//  BroadcastSetupViewController.m
//  BroadcastSetupUI
//
//  Created by Apple on 2018/6/6.
//  Copyright © 2018年 Syan. All rights reserved.
//

#import "BroadcastSetupViewController.h"

@implementation BroadcastSetupViewController

- (IBAction)doStartBoardcastPressed:(id)sender {
    [self userDidFinishSetup];
}

- (IBAction)doCancelPressed:(id)sender {
    [self userDidCancelSetup];
}

// Call this method when the user has finished interacting with the view controller and a broadcast stream can start
- (void)userDidFinishSetup {

    NSString *channel = self.channelTextField.text;
    NSString *userId = self.userIDTextField.text;
    
    // URL of the resource where broadcast can be viewed that will be returned to the application
    NSURL *broadcastURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://vid-130451.hls.fastweb.broadcastapp.agoraio.cn/live/%@/index.m3u8", channel]];

    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    NSDictionary *setupInfo = @{ @"channelName" : channel, @"userId" : userId };

    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    if (@available(iOS 11.0, *)) {
        [self.extensionContext completeRequestWithBroadcastURL:broadcastURL setupInfo:setupInfo];
    } else {
        // Fallback on earlier versions
        // Set broadcast settings
        RPBroadcastConfiguration *broadcastConfig = [[RPBroadcastConfiguration alloc] init];
        broadcastConfig.clipDuration = 1.0; // deliver movie clips every 5 seconds
        
        // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
        [self.extensionContext completeRequestWithBroadcastURL:broadcastURL broadcastConfiguration:broadcastConfig setupInfo:setupInfo];
    }
}

- (void)userDidCancelSetup {
    // Tell ReplayKit that the extension was cancelled by the user
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:@"com.wilder.ilive.BroadcastSetupUI" code:-1 userInfo:nil]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self userDidFinishSetup];
    return YES;
}

@end
