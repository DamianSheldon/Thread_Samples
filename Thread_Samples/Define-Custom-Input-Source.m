//
//  main.m
//  Thread_Samples
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThreadManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Creating a thread
        [NSThread detachNewThreadSelector:@selector(threadMainMethod:) toTarget:[ThreadManager sharedManager] withObject:nil];
    }
    return 0;
}
