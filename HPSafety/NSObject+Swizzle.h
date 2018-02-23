//
//  NSObject+Swizzle.h
//  HPSafety
//
//  Created by LeeHu on 2/23/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+(void)hp_swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end
