//
//  HPUnrecognizedSelectorSolveObject.m
//  HPSafety
//
//  Created by LeeHu on 2/22/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "HPUnrecognizedSelectorSolveObject.h"
#import <objc/runtime.h>

@implementation HPUnrecognizedSelectorSolveObject


+ (instancetype)shareInstance {
    static HPUnrecognizedSelectorSolveObject *unrecognizedSelectorSolveObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unrecognizedSelectorSolveObject = [[HPUnrecognizedSelectorSolveObject alloc] init];
    });
    return unrecognizedSelectorSolveObject;
}

+ (BOOL)resolveInstanceMethod:(SEL)selector {
    class_addMethod([self class], selector, (IMP)autoAddMethod, "v@:@");
    return YES;
}

id autoAddMethod(id self, SEL _cmd) {
    return 0;
}

@end
