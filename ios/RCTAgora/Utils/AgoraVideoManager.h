//
//  AgoraVideoManager.h
//  RNAgoraExample
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AgoraVideoManager : NSObject

@property (nonatomic, strong) UIView *avRootView;

+ (instancetype)share;

@end
