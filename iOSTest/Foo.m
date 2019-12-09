//
//  Foo.m
//  iOSTest
//
//  Created by ranwenjie on 16/11/24.
//  Copyright © 2016年 ranwenjie. All rights reserved.
//

#import "Foo.h"

@implementation Foo

+ (void)load{
    NSLog(@"foo +load");
}

+ (Foo *)createFoo{
    id tmp = [self new];
    return tmp;
}

- (void)func{
    NSLog(@"do func");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [NSMethodSignature methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
}

@end
