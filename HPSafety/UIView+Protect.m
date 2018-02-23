//
//  UIView+Protect.m
//  HPSafety
//
//  Created by LeeHu on 2/23/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "UIView+Protect.h"
#import "NSObject+Swizzle.h"

@implementation UIView (Protect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] hp_swizzleMethod:@selector(setNeedsLayout) withMethod:@selector(hp_setNeedsLayout)];
        [[self class] hp_swizzleMethod:@selector(setNeedsDisplay) withMethod:@selector(hp_setNeedsDisplay)];
        [[self class] hp_swizzleMethod:@selector(setNeedsDisplayInRect:) withMethod:@selector(hp_setNeedsDisplayInRect:)];
        [[self class] hp_swizzleMethod:@selector(setNeedsUpdateConstraints) withMethod:@selector(hp_setNeedsUpdateConstraints)];
    });
}

- (void)hp_setNeedsLayout {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hp_setNeedsLayout];
    });
}

- (void)hp_setNeedsDisplay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hp_setNeedsDisplay];
    });
}

- (void)hp_setNeedsDisplayInRect:(CGRect)rect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hp_setNeedsDisplayInRect: rect];
    });
}

- (void)hp_setNeedsUpdateConstraints {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hp_setNeedsUpdateConstraints];
    });
}


@end
