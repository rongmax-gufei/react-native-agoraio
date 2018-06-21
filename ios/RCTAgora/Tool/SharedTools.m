//
//  SharedTools.m
//  RCTAgora
//
//  Created by Learnta on 2018/6/21.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#import "SharedTools.h"

@implementation SharedTools

+ (void)storagedAgoraAppId:(NSString *)appid {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroups];
    [sharedDefaults setObject:appid forKey:kAppid];
}

+ (void)storagedAgoraChannel:(NSString *)channel uid:(NSInteger)uid {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroups];
    [sharedDefaults setObject:channel forKey:kChannel];
    [sharedDefaults setObject:[@(uid) stringValue] forKey:kUid];
}

@end
