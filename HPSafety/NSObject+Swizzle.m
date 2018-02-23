//
//  NSObject+Swizzle.m
//  HPSafety
//
//  Created by LeeHu on 2/23/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+(void)hp_swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
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


@end
