//
//  DMLApplication.m
//  Thread_Samples
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "DMLApplication.h"
#import "MyWorkerClass.h"
#import "Constants.h"

@interface DMLApplication ()<NSMachPortDelegate>

@property NSPort* myPort;

@end

@implementation DMLApplication

+ (instancetype)sharedApplication
{
    static DMLApplication *sApplication = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sApplication = [DMLApplication new];
    });
    
    return sApplication;
}

- (void)launch
{
    NSLog(@"Launch application ...");

    NSPort* myPort = [NSMachPort port];
    if (myPort) {
        self.myPort = myPort;
        
        // This class handles incoming port messages.
        [myPort setDelegate:self];
        
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        // Detach the thread. Let the worker release the port.
        [NSThread detachNewThreadSelector:@selector(LaunchThreadWithPort:)
                                 toTarget:[MyWorkerClass class] withObject:myPort];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"di da ...\n");
        }];
        
        [[NSRunLoop currentRunLoop] run];
    }
}

// Handle responses from the worker thread.
- (void)handlePortMessage:(NSPortMessage *)portMessage
{
    NSLog(@"%s:%@", __func__, portMessage);
    
    unsigned int message = [portMessage msgid];
    NSPort* distantPort = nil;
    
    if (message == DMLCheckinMessage) {
        NSLog(@"Recieve checkin messaages!");
        // Get the worker thread’s communications port.
        distantPort = [portMessage sendPort];
        
        // Retain and save the worker port for later use.
//        [self storeDistantPort:distantPort];
        
        // Reply checkin message
        NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:distantPort
                                                                receivePort:self.myPort components:nil];
        if (messageObj) {
            // Finish configuring the message and send it immediately.
            [messageObj setMsgid:DMLCheckinMessage + 2];
            BOOL result = [messageObj sendBeforeDate:[NSDate date]];
            
            if (!result) {
                NSLog(@"reply checkin message timeout!");
            }
            else {
                NSLog(@"reply checkin message successfully!");
            }
        }
        else {
            NSLog(@"Reply Instance messageObj failed!");
        }
    }
    else {
        // Handle other messages.
        NSLog(@"Recieve other messaages!");
        
        exit(0);
    }
}

@end
