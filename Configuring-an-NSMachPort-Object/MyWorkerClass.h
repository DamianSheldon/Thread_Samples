//
//  MyWorkerClass.h
//  Thread_Samples
//
//  Created by DongMeiliang on 02/05/2017.
//  Copyright © 2017 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerClass : NSObject

+ (void)LaunchThreadWithPort:(id)inData;

- (BOOL)shouldExit;

@end
