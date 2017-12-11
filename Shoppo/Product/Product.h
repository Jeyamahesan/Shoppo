//
//  Product.h
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSArray *imagesUrl;
@property (nonatomic, strong) NSString *categoryTitle;

- (id)initWithInfo:(NSDictionary *)info;

@end
