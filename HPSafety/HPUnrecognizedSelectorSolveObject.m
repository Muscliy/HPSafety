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
    NSLog(@"%@", NSStringFromSelector(selector));
    class_addMethod([self class], selector, (IMP)autoAddMethod, "@@:");
    [super resolveInstanceMethod:selector];
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id result = [super forwardingTargetForSelector:aSelector];
    return result;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id result = [super methodSignatureForSelector:aSelector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

id autoAddMethod(id self, SEL _cmd) {
    return [NSNull null];
}

@end
