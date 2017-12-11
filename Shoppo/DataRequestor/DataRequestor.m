//
//  DataRequestor.m
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "DataRequestor.h"
#import <Moltin/Moltin.h>
#import "Category.h"
#import "Product.h"

#define MOLTIN_API_KEY @"umRG34nxZVGIuCSPfYf8biBSvtABgTR8GMUtflyE"

@implementation DataRequestor
{
    NSArray *productListCollection;
}

- (id)init
{
    if (self = [super init])
    {
        [[Moltin sharedInstance] setPublicId:MOLTIN_API_KEY];
        [[Moltin sharedInstance] setLoggingEnabled:YES];
        
        self.categoryCollection = [NSMutableArray new];
        
        self.productCollection = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)requestCategoryCollectionData
{
    [[Moltin sharedInstance].collection listingWithParameters:@{@"status" : @1, @"limit": @20} success:^(NSDictionary *response) {
        [self fillCategoryCollectionData:response];
        [self postNotification:@"CategoriesReceived"];
    } failure:^(NSDictionary *response, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)fillCategoryCollectionData:(NSDictionary *)info
{
    NSArray *results = [info objectForKey:@"result"];
    
    for (NSDictionary *result in results)
    {
        Category *category = [[Category alloc] initWithInfo:result];
        [self.categoryCollection addObject:category];
    }
}

- (NSArray *)getCategoryCollection
{
    return self.categoryCollection;
}

#pragma mark -
#pragma mark Notification Methods

- (void)postNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

- (void)requestProductsCollection:(NSString *)catgoryId
{
    if (![self.productCollection objectForKey:catgoryId])
    {
        [[Moltin sharedInstance].product listingWithParameters:@{@"collection" : catgoryId,
                                                                 @"limit" : @3,
                                                                 @"offset" : @1
                                                                 }
                                                       success:^(NSDictionary *response)
         {
             [self fillProductsCollectionData:response category:catgoryId];
             [self postNotification:@"ProductsListReceived"];
             
         } failure:^(NSDictionary *response, NSError *error) {
             NSLog(@"Error %@", error);
         }];
    }
}

- (void)fillProductsCollectionData:(NSDictionary *)info category:(NSString *)catgoryId
{
    NSArray *results = [info objectForKey:@"result"];
    
    NSMutableArray *products = [NSMutableArray array];
    for (NSDictionary *result in results)
    {
        Product *product = [[Product alloc] initWithInfo:result];
        [products addObject:product];
    }
    
    [self.productCollection setObject:products forKey:catgoryId];
}

- (NSDictionary *)getProductCollection
{
    return self.productCollection;
}

@end
