//
//  NSObject+Forwarding.m
//  HPSafety
//
//  Created by LeeHu on 2/22/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "NSObject+Forwarding.h"
#import "HPUnrecognizedSelectorSolveObject.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, HPUnrecognizedSelectorSolveScheme) {
    HPUnrecognizedSelectorSolveScheme1,
    HPUnrecognizedSelectorSolveScheme2
};

@implementation NSObject (Forwarding)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HPUnrecognizedSelectorSolveScheme scheme = HPUnrecognizedSelectorSolveScheme2;
        if (scheme == HPUnrecognizedSelectorSolveScheme1) {
            [[self class] swizzedMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(newForwardingTargetForSelector:)];
        } else if (scheme == HPUnrecognizedSelectorSolveScheme2) {
            [[self class] swizzedMethod:@selector(methodSignatureForSelector:) withMethod:@selector(newMethodSignatureForSelector:)];
            [[self class] swizzedMethod:@selector(forwardInvocation:) withMethod:@selector(newForwardInvocation:)];
        }
    });
}

+(void)swizzedMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Class cls = [self class];
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(swizzledMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark forwardTarget
- (id)newForwardingTargetForSelector:(SEL)selector {
    HPUnrecognizedSelectorSolveObject *obj = [HPUnrecognizedSelectorSolveObject shareInstance];
    return obj;
}

- (NSMethodSignature *)newMethodSignatureForSelector:(SEL)sel{
    HPUnrecognizedSelectorSolveObject *obj = [HPUnrecognizedSelectorSolveObject shareInstance];
    return [self newMethodSignatureForSelector:sel] ?: [obj newMethodSignatureForSelector:sel];
}

- (void)newForwardInvocation:(NSInvocation *)anInvocation {
    if ([self newMethodSignatureForSelector:anInvocation.selector]) {
        [self newForwardInvocation:anInvocation];
        return;
    }
    HPUnrecognizedSelectorSolveObject *obj = [HPUnrecognizedSelectorSolveObject shareInstance];
    if ([self methodSignatureForSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:obj];
    }
}

@end
