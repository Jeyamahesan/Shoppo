//
//  ObjectManager.h
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRequestor.h"

#define objectManager ([ObjectManager sharedManager])

@interface ObjectManager : NSObject

@property (nonatomic, strong) DataRequestor *dataRequestor;

+ (ObjectManager *)sharedManager;;

- (void)initiateDataRequestor;

@end
