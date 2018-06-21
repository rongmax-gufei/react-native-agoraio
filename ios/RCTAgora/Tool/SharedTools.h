//
//  SharedTools.h
//  RCTAgora
//  用于实现 Extension 和 Containing App 之间的数据共享
//  Created by Learnta on 2018/6/21.
//  Copyright © 2018年 Learnta Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedTools : NSObject

+ (void)storagedAgoraAppId:(NSString *)appid;

+ (void)storagedAgoraChannel:(NSString *)channel uid:(NSInteger)uid;

@end
