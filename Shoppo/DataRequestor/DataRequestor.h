//
//  DataRequestor.h
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataRequestor : NSObject

@property (nonatomic, strong) NSMutableArray *categoryCollection;
@property (nonatomic, strong) NSMutableDictionary *productCollection;

- (void)requestCategoryCollectionData;
- (NSArray *)getCategoryCollection;

- (void)requestProductsCollection:(NSString *)catgoryId;
- (NSDictionary *)getProductCollection;

@end
