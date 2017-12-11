//
//  Category.m
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)initWithInfo:(NSDictionary *)info
{
    if (self = [super init])
    {
        self.categoryId = [info valueForKey:@"id"];
        self.title = [[info valueForKey:@"title"] uppercaseString];
        self.categoryDescription = [info valueForKey:@"description"];;
        
        NSArray *images = [info valueForKeyPath:@"images.url.https"];
        if (images.count > 0)
        {
            self.imageUrl = [images objectAtIndex:0];
        }
        else
        {
            self.imageUrl = @"";
        }
    }
    
    return self;
}

@end
