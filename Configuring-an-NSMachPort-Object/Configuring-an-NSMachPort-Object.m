//
//  main.m
//  Configuring-an-NSMachPort-Object
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMLApplication.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[DMLApplication sharedApplication] launch];
        
        dispatch_main();
    }
    return 0;
}
