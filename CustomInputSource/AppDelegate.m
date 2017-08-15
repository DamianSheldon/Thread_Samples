//
//  AppDelegate.m
//  CustomInputSource
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "AppDelegate.h"
#import "RunLoopSource.h"

@interface AppDelegate ()

@property (nonatomic) NSMutableArray *sourcesToPing;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread detachNewThreadSelector:@selector(secondaryThreadMainMethod) toTarget:self withObject:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)secondaryThreadMainMethod
{
    NSLog(@"%s", __func__);
    
    // Creating an Autorelease Pool
    @autoreleasepool {
        // Setting Up an Exception Handler
        @try {
#if defined(CORE_FOUNDATION_RUN_LOOP)
            BOOL done = NO;

            // Add your sources or timers to the run loop and do any other setup.
            RunLoopSource *runLoopSource = [[RunLoopSource alloc] init];
            [runLoopSource addToCurrentRunLoop];

            do {
                // Start the run loop but return after each source is handled.
                SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);

                // If a source explicitly stopped the run loop, or if there are no
                // sources or timers, go ahead and exit.
                if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished)) {
                    done = YES;
                }

                // Check for any other exit conditions here and set the
                // done variable as needed.
            }
            while (!done);
#else
            BOOL moreWorkToDo = YES;
            BOOL exitNow = NO;
            NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
            
            // Add the exitNow BOOL to the thread dictionary.
            NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
            [threadDict setValue:[NSNumber numberWithBool:exitNow] forKey:@"ThreadShouldExitNow"];
            
            // Install an input source.
            RunLoopSource *runLoopSource = [[RunLoopSource alloc] init];
            [runLoopSource addToCurrentRunLoop];
            
            while (moreWorkToDo && !exitNow)
            {
                // Do one chunk of a larger body of work here.
                // Change the value of the moreWorkToDo Boolean when done.
                
                // Run the run loop but timeout immediately if the input source isn't waiting to fire.
                [runLoop runUntilDate:[[NSDate date] dateByAddingTimeInterval:10]];
                
                // Check to see if an input source handler changed the exitNow value.
                exitNow = [[threadDict valueForKey:@"ThreadShouldExitNow"] boolValue];
            }
#endif
        }
        @catch (NSException *exception) {
            NSLog(@"%s:%@", __func__, exception);
        }
    }
}

- (void)registerSource:(RunLoopContext*)sourceInfo;
{
    NSLog(@"%s", __func__);
    [self.sourcesToPing addObject:sourceInfo];
}

- (void)removeSource:(RunLoopContext*)sourceInfo
{
    NSLog(@"%s", __func__);

    id    objToRemove = nil;
    
    for (RunLoopContext* context in self.sourcesToPing) {
        if ([context isEqual:sourceInfo]) {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove) {
        [self.sourcesToPing removeObject:objToRemove];
    }
}

#pragma mark - Getter

- (NSMutableArray *)sourcesToPing
{
    if (!_sourcesToPing) {
        _sourcesToPing = [NSMutableArray new];
    }
    return _sourcesToPing;
}

@end
