//
//  RunLoopObserverCallBack.c
//  Thread_Samples
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "RunLoopObserverCallBack.h"

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

