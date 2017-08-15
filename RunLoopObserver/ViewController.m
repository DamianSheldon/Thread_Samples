//
//  ViewController.m
//  RunLoopObserver
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "ViewController.h"

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
    
    // The application uses garbage collection, so no autorelease pool is needed.
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

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSString *activityName;
    
    switch (activity) {
        case kCFRunLoopEntry:
            activityName = @"kCFRunLoopEntry";
            break;
            
        case kCFRunLoopBeforeTimers:
            activityName = @"kCFRunLoopBeforeTimers";
            break;
            
        case kCFRunLoopBeforeSources:
            activityName = @"kCFRunLoopBeforeSources";
            break;
            
        case kCFRunLoopBeforeWaiting:
            activityName = @"kCFRunLoopBeforeWaiting";
            break;
            
        case kCFRunLoopAfterWaiting:
            activityName = @"kCFRunLoopAfterWaiting";
            break;
            
        case kCFRunLoopExit:
            activityName = @"kCFRunLoopExit";
            break;
            
        case kCFRunLoopAllActivities:
            activityName = @"kCFRunLoopAllActivities";
            break;
    }
    
    NSLog(@"%@\n", activityName);
}

@end
