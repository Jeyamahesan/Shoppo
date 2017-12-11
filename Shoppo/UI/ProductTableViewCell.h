//
//  ProductTableViewCell.h
//  Shoppo
//
//  Created by Jey on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *productLabel;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@end
