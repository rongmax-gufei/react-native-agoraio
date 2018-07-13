//
//  AgoraScreenShareManager.h
//  RNAgoraExample
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AgoraScreenShareManager : NSObject

@property (nonatomic, strong) UIView *sharedView;

+ (instancetype)share;

@end
