//
//  BundleTools.m
//  RCTAgora
//
//  Created by Apple on 2018/2/9.
//  Copyright © 2018年 Syan. All rights reserved.
//

#import "BundleTools.h"

@implementation BundleTools

+ (NSBundle *)getBundle {
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: BUNDLE_NAME ofType: @"bundle"]];
}

+ (NSString *)getBundlePath: (NSString *) assetName{
    NSBundle *myBundle = [BundleTools getBundle];
    if (myBundle && assetName) {
        return [[myBundle resourcePath] stringByAppendingPathComponent: assetName];
    }
    return nil;
}

@end
