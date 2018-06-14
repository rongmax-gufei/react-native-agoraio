//
//  AgoraScreenShareManager.m
//  RNAgoraExample
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import "AgoraScreenShareManager.h"

@implementation AgoraScreenShareManager

static AgoraScreenShareManager *_agoraScreenShareManager;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    _agoraScreenShareManager = [super allocWithZone:zone];
  });
  return _agoraScreenShareManager;
}

+ (instancetype)share {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _agoraScreenShareManager = [[self alloc]init];
  });
  return _agoraScreenShareManager;
}

- (id)copyWithZone:(NSZone *)zone {
  return _agoraScreenShareManager;
}

@end
