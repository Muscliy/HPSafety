//
//  NSObject+KVOProtect.m
//  HPSafety
//
//  Created by LeeHu on 2/23/18.
//  Copyright © 2018 LeeHu. All rights reserved.
//

#import "NSObject+KVOProtect.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

static const void *keypathMapKey=&keypathMapKey;


@implementation NSObject (KVOProtect)

- (NSMapTable <id, NSHashTable<NSString *> *> *)keypathMap {
    NSMapTable *keypathMap = objc_getAssociatedObject(self, &keypathMapKey);
    if (keypathMap) {
        return keypathMap;
    }
    keypathMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality  capacity:0];
    objc_setAssociatedObject(self, &keypathMapKey, keypathMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return keypathMap;
}


- (void)setKeypathMap: (id)map {
    if (map) {
        objc_setAssociatedObject(self, keypathMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] hp_swizzleMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(hp_addObserver:forKeyPath:options:context:)];
        [[self class] hp_swizzleMethod:@selector(removeObserver:forKeyPath:) withMethod:@selector(hp_removeObserver:forKeyPath:)];
        [[self class] hp_swizzleMethod:@selector(removeObserver:forKeyPath:context:) withMethod:@selector(hp_removeObserver:forKeyPath:context:)];
    });
}

- (void)hp_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    if (!observer || !keyPath || keyPath.length == 0) {
        return;
    }
    
    NSHashTable *table = [[self keypathMap] objectForKey:observer];
    if (!table) {
        table = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        [table addObject:keyPath];
        [[self keypathMap] setObject:table forKey:observer];
        [self hp_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    
    if ([table containsObject:keyPath]) {
        NSLog(@"%s ******* donot add the same observer and keypath %@ ",__FUNCTION__, self);
        return;
    }
    
    [table addObject:keyPath];
    
    [self hp_addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)hp_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (!observer || !keyPath) {
        return;
    }
    
    NSHashTable *table = [[self keypathMap] objectForKey:observer];
    if (!table) {
        return;
    }
    
    if (![table containsObject:keyPath]) {
        return;
    }
    [table removeObject:keyPath];
    [self hp_removeObserver:observer forKeyPath:keyPath];
}

- (void)hp_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    if (!observer || !keyPath) {
        return;
    }
    
    NSHashTable *table = [[self keypathMap] objectForKey:observer];
    if (!table) {
        return;
    }
    
    if (![table containsObject:keyPath]) {
        return;
    }
    [table removeObject:keyPath];
    [self hp_removeObserver:observer forKeyPath:keyPath context:context];
}

@end
