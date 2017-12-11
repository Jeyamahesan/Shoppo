//
//  Category.h
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *categoryDescription;
@property (nonatomic, strong) NSString *imageUrl;

- (id)initWithInfo:(NSDictionary *)info;

@end
