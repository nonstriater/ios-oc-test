//
//  Bar.m
//  iOSTest
//
//  Created by ranwenjie on 17/3/20.
//  Copyright © 2017年 ranwenjie. All rights reserved.
//

#import "Bar.h"

@implementation Bar

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        NSLog(@"%@",NSStringFromClass(Bar.class));
        NSLog(@"%@",NSStringFromClass(Foo.class));
        
        
        NSLog(@"%@",NSStringFromClass( [self class]));
        NSLog(@"%@",NSStringFromClass( [super class]));
        
    }
    
    return self;
}

@end
