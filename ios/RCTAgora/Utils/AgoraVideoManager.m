//
//  AgoraVideoManager.m
//  RNAgoraExample
//
//  Created by Learnta on 2018/2/1.
//  Copyright © 2018年 Learnta. All rights reserved.
//

#import "AgoraVideoManager.h"

@implementation AgoraVideoManager

static AgoraVideoManager *_agoraVideoManager;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    _agoraVideoManager = [super allocWithZone:zone];
  });
  return _agoraVideoManager;
}

+ (instancetype)share {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _agoraVideoManager = [[self alloc]init];
  });
  return _agoraVideoManager;
}

- (id)copyWithZone:(NSZone *)zone {
  return _agoraVideoManager;
}

@end
