//
//  ViewController.m
//  iOSTest
//
//  Created by ranwenjie on 16/11/22.
//  Copyright © 2016年 ranwenjie. All rights reserved.
//

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <objc/runtime.h>
#import "Foo.h"
#import "Bar.h"
#import "Mem.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Bar *barObject;

@end

@implementation ViewController

+ (void)load{
    NSLog(@"vc load");
}

__weak NSString *ref = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSMutableString *ms = [NSMutableString string];
    [ms appendString:@"\n"];
    NSLog(@"ms:%@",ms);
    
    NSString *s = [[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding];
    NSLog(@"2222%@",s);
    
    NSString *str = [NSString stringWithFormat:@"hello"];
    ref = str;
    
    Bar *b = [Bar new];
    NSLog(@"%@",b);
    
    NSArray *arr = @[@"1",@"3"];
    NSString *item = nil;
    if ([arr containsObject:item]) {
        NSLog(@"item nil will crash");
    }
    
   // NSMutableString *ms = [NSMutableString new];
    //[ms appendString:nil];
    
    [self testTimerEvent];
    
    [self testInvocation];
    
    [self addCrashButton];
    
    [self testBlockMem];
    
    [self testGCD];
    
    Method m = class_getInstanceMethod(self.class, @selector(barWithBaz:));
    NSLog(@"type encode: %s",method_getTypeEncoding(m));
    
    self.timer =[NSTimer timerWithTimeInterval:1 target:self selector:@selector(logCount:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"退到了后台");
    });
    
   // [self testFoo];
}


- (void)allocateTINY_SMALL_LARGE:(id)sender{    
    NSMutableSet *objs = [NSMutableSet new];
    @autoreleasepool {
        for (int i = 0; i < 100; ++i) {
            Mem *obj = [Mem new];
            [objs addObject:obj];
        }
        sleep(100000);
    }
}


- (void)logCount:(NSTimer *)timer{
    static int i = 0;
    NSLog(@"count:%d",i++);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"ref=%@",ref);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"ref=%@",ref);
}

- (void)testFoo{
    Foo *f = [Foo new];
    [f performSelector:@selector(noFunc)];
}

- (void)testGCD{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"do sth");
    });
}

- (void)testBlockMem{

    
}

- (void)multithreadCrashTap:(id)sender{
    
    for (int i = 0; i < 10000; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.barObject = [Bar new];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.barObject = [Bar new];
        });
    }
}


- (void)usingFreedObject:(id)sender{
    
    for (int i = 0; i < 10000; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.barObject = [Bar new];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.barObject = [Bar new];
        });
    }
}

- (void)addCrashButton{
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 50, 100, 30);
        [button setTitle:@"Crash" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(150, 50, 150, 30);
        [button setTitle:@"Multithread Crash" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(multithreadCrashTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(150, 100, 250, 30);
        [button setTitle:@"Use Freed Object Crash" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(usingFreedObject:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(150, 180, 250, 30);
        [button setTitle:@"Heap Allcation" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(allocateTINY_SMALL_LARGE:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (IBAction)crashButtonTapped:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"growing.b2289a17272224e4"]];
    
    //strcpy(0, "hello");
    //[[Crashlytics sharedInstance] crash];
}

- (void)testInvocation{
    NSInvocation *inv = [NSInvocation new];
    inv.target = self;
    inv.selector = @selector(print);
    [inv invoke];
}

- (void)testTimerEvent{
    [self performSelector:@selector(print) withObject:nil];
    [self performSelector:@selector(print) withObject:nil afterDelay:0];
    [self performSelector:@selector(print) withObject:nil afterDelay:15];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self print];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self print];
    });
}

- (void)print{
    NSLog(@"hello,world");
}

- (int)barWithBaz:(double)baz{
    return 0;
}

@end
