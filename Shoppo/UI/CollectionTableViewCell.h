//
//  CollectionTableViewCell.h
//  Shoppo
//
//  Created by Jey on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *collectionImageView;

@end
