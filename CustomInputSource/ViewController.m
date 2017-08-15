//
//  ViewController.m
//  CustomInputSource
//
//  Created by Meiliang Dong on 15/08/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopSource.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)dispatchWork:(UIButton *)sender {
    static NSInteger count = 0;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    RunLoopContext *runLoopContext = delegate.sourcesToPing.firstObject;
    
    [runLoopContext.source addCommand:++count withData:sender];
    
    [runLoopContext.source fireAllCommandsOnRunLoop:runLoopContext.runLoop];
}

@end
