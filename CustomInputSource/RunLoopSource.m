//
//  RunLoopSource.m
//  ThreadSamples
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "RunLoopSource.h"
#import "AppDelegate.h"

@interface Command : NSObject

- (instancetype)initWithNo:(NSInteger)commandNo data:(id)data;

@property (nonatomic, readonly) NSInteger commandNo;
@property (nonatomic, readonly) id data;

@end

@interface Command ()

@property (nonatomic) NSInteger commandNo;
@property (nonatomic) id data;

@end

@implementation Command

- (instancetype)initWithNo:(NSInteger)commandNo data:(id)data
{
    self = [super init];
    if (self) {
        _commandNo = commandNo;
        _data = data;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithNo:NSIntegerMin data:nil];
}

@end

@implementation RunLoopSource

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    CFRunLoopSourceContext    context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine};
    
    runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    commands = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate
{
    CFRunLoopSourceInvalidate(runLoopSource);
}

- (void)sourceFired
{
    NSLog(@"%s", __func__);
    
    @autoreleasepool {
        NSArray *tmpArray;
        
        @synchronized (self) {
            tmpArray = [NSArray arrayWithArray:commands];
            
            [commands removeAllObjects];
        }
        
        for (Command *command in tmpArray) {
            NSLog(@"Command No:%ld, data pointer address:%@", command.commandNo, command.data);
        }
        
    }
}

- (void)addCommand:(NSInteger)command withData:(id)data
{
    NSLog(@"%s", __func__);
    
    Command *cmd = [[Command alloc] initWithNo:command data:data];
    
    @synchronized (self) {
        [commands addObject:cmd];
    }
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}

- (void)dealloc
{
    CFRelease(runLoopSource);
}

@end

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"%s", __func__);

    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    AppDelegate*  del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}

void RunLoopSourcePerformRoutine (void *info)
{
    NSLog(@"%s", __func__);
    
    RunLoopSource*  obj = (__bridge RunLoopSource*)info;
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"%s", __func__);
    
    RunLoopSource* obj = (__bridge RunLoopSource*)info;
    AppDelegate*  del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation RunLoopContext

@synthesize runLoop = runLoop;
@synthesize source = source;

- (id)initWithSource:(RunLoopSource*)src andLoop:(CFRunLoopRef)loop
{
    self = [super init];
    if (self) {
        source = src;
        runLoop = loop;
    }
    return self;
}

@end
