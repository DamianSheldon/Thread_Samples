//
//  ViewController.m
//  RunLoopObserver
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopObserverCallBack.h"

@interface ViewController ()
{
    CFRunLoopObserverRef    observer;
}

@end

@implementation ViewController

- (void)dealloc
{
    CFRelease(observer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    
    // Create a run loop observer and attach it to the run loop.
    CFRunLoopObserverContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    
    if (observer) {
        CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
}

@end
