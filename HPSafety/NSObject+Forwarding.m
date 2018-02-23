//
//  NSObject+Forwarding.m
//  HPSafety
//
//  Created by LeeHu on 2/22/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "NSObject+Forwarding.h"
#import "HPUnrecognizedSelectorSolveObject.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, HPUnrecognizedSelectorSolveScheme) {
    HPUnrecognizedSelectorSolveScheme1,
    HPUnrecognizedSelectorSolveScheme2
};

@implementation NSObject (Forwarding)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] hp_swizzleMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(hp_forwardingTargetForSelector:)];
    });
}


+ (BOOL)hp_isWhiteListClass:(Class)cls {
    NSString *classString = NSStringFromClass(cls);
    BOOL isInternal = [classString hasPrefix:@"_"];
    if (isInternal) {
        return NO;
    }
    BOOL isNull = [classString isEqualToString:NSStringFromClass([NSNull class])];
    BOOL isMyClass = [classString hasPrefix:@"HP"];
    return isNull || isMyClass;
}

#pragma mark forwardTarget
- (id)hp_forwardingTargetForSelector:(SEL)selector {
    id result = [self hp_forwardingTargetForSelector:selector];
    if (result) {
        return result;
    }
    BOOL isWhiteClass = [[self class] hp_isWhiteListClass:[self class]];
    if (!isWhiteClass) {
        return nil;
    }
    if (!result) {
        result = [HPUnrecognizedSelectorSolveObject shareInstance];
    }
    return result;
}


@end
