//
//  ThreadWrapper.m
//  Thread_Samples
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "ThreadManager.h"

@implementation ThreadManager

+ (instancetype)sharedManager
{
    static ThreadManager *sThreadManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sThreadManager = [ThreadManager new];
    });
    
    return sThreadManager;
}

- (void)threadMainRoutine
{
    // Set up an autorelease pool here if not using garbage collection.
    @autoreleasepool {
        BOOL done = NO;
        
        // Add your sources or timers to the run loop and do any other setup.
        NSMachPort *port = [NSMachPort port];
        [port scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        do
        {
            // Start the run loop but return after each source is handled.
            SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
            
            // If a source explicitly stopped the run loop, or if there are no
            // sources or timers, go ahead and exit.
            if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished)) {
                done = YES;
            }
            
            // Check for any other exit conditions here and set the
            // done variable as needed.
        }
        while (!done);
        
        // Clean up code here. Be sure to release any allocated autorelease pools.
    }
}

@end
