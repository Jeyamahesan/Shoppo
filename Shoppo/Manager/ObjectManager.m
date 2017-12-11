//
//  ObjectManager.m
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "ObjectManager.h"

@implementation ObjectManager

#pragma mark Singleton Methods

+ (ObjectManager *)sharedManager
{
    static ObjectManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Alloc/Init

- (void)initiateDataRequestor
{
    @autoreleasepool
    {
        @try
        {
            self.dataRequestor = [[DataRequestor alloc] init];
        }
        @catch (NSException *exception)
        {
            
        }
    }
}

@end
