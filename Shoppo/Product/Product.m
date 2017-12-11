//
//  Product.m
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init])
    {
        self.title = [info valueForKey:@"title"];
        self.price = [info valueForKeyPath:@"price.data.formatted.with_tax"];
        
        NSArray *images = [info valueForKeyPath:@"images.url.https"];
        if (images.count > 0)
        {
            self.imageUrl = [images objectAtIndex:0];
        }
        else
        {
            self.imageUrl = @"";
        }
        
        self.imagesUrl = [NSArray arrayWithArray:images];

        self.categoryTitle = [info valueForKeyPath:@"collection.data.title"];
        self.productDescription = [info valueForKey:@"description"];
    }
    
    return self;
}

@end
