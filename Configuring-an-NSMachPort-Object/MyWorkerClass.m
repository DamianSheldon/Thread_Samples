//
//  MyWorkerClass.m
//  Thread_Samples
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "MyWorkerClass.h"
#import "Constants.h"

@interface MyWorkerClass ()<NSPortDelegate>

@property NSPort *remotePort;
@property NSTimer *exitTimer;
@property BOOL exit;
@property NSPort* myPort;

@end

@implementation MyWorkerClass

+ (void)LaunchThreadWithPort:(id)inData
{
    @autoreleasepool {
        NSLog(@"Launch thread with port ...");
        // Set up the connection between this thread and the main thread.
        NSPort* distantPort = (NSPort*)inData;
        
        MyWorkerClass*  workerObj = [[self alloc] init];
        [workerObj sendCheckinMessage:distantPort];
        
        // Let the run loop process things.
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate distantFuture]];
        }
        while (![workerObj shouldExit]);
    }
}

- (BOOL)shouldExit
{
    return self.exit;
}

- (void)sendCheckinMessage:(NSPort*)outPort
{
    NSLog(@"sendCheckinMessage ...");

    // Retain and save the remote port for future use.
    [self setRemotePort:outPort];
    
    // Create and configure the worker thread port.
    NSPort* myPort = [NSMachPort port];
    [myPort setDelegate:self];
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    
    self.myPort = myPort;
    
    // Create the check-in message.
    NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
                                                            receivePort:myPort components:nil];

    if (messageObj) {
        // Finish configuring the message and send it immediately.
        [messageObj setMsgid:DMLCheckinMessage];
        BOOL result = [messageObj sendBeforeDate:[NSDate date]];
        
        if (!result) {
            NSLog(@"send checkin message timeout!");
        }
        else {
            NSLog(@"send checkin message successfully!");

            __weak typeof(self) weakSelf = self;
            
            [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
                NSLog(@"prepare send shutdown message!");

                __strong typeof(self) strongSelf = weakSelf;
                
                NSPortMessage *msgObj = [[NSPortMessage alloc] initWithSendPort:strongSelf.remotePort
                                                                        receivePort:strongSelf.myPort components:nil];
                msgObj.msgid = DMLCheckinMessage + 1;
                
                BOOL ret = [msgObj sendBeforeDate:[NSDate date]];
                
                if (!ret) {
                    NSLog(@"send shutdown message timeout!");
                }
                else {
                    NSLog(@"send shutdown message successfully!");
                    strongSelf.exit = YES;
                }
            }];
        }
    }
    else {
        NSLog(@"Instance messageObj failed!");
    }
}

- (void)handlePortMessage:(NSPortMessage *)portMessage
{
    NSLog(@"%s:%@", __func__, portMessage);

}

@end
