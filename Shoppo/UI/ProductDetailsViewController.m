//
//  ProductDetailsViewController.m
//  Shoppo
//
//  Created by Jey on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShareViewController.h"

@interface ProductDetailsViewController ()
{
    IBOutlet UIImageView *imageView;
    IBOutlet NSLayoutConstraint *imagesScrollViewHeightConstraint;
    IBOutlet UIScrollView *imagesScrollView;
    IBOutlet UILabel *collectionTitleLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UIButton *addToCartButton;
    IBOutlet UIButton *shareButton;
}

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ProductDetailsViewController

static NSInteger ScrollingImageViewTag = 99;
static NSInteger ScrollingImageViewHeight = 65;

- (id)initWithProduct:(Product *)product
{
    self = [super initWithNibName:@"ProductDetailsViewController" bundle:nil];
    if (self)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _product = product;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"PRODUCT";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    
    // Rounded borders
    addToCartButton.layer.cornerRadius = 4.0f;
    addToCartButton.clipsToBounds = YES;
    
    shareButton.layer.cornerRadius = 4.0f;
    shareButton.clipsToBounds = YES;
    
    self.images = [NSMutableArray array];
    
    [self configureWithProduct:_product];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dimissView:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)configureWithProduct:(Product *)product
{
    [self.images removeAllObjects];
    
    collectionTitleLabel.text = product.categoryTitle;
    titleLabel.text = product.title;
    priceLabel.text = product.price;
    descriptionLabel.text = product.productDescription;
    
    [self.images addObjectsFromArray:product.imagesUrl];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    [manager GET:product.imageUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        imageView.image = [UIImage imageWithData:responseObject];
    }failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    if (self.images.count > 1) {
        for (UIView *view in imagesScrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && view.tag == ScrollingImageViewTag) {
                [view removeFromSuperview];
            }
        }
        
        imagesScrollViewHeightConstraint.constant = 75;
        int i = 0;
        for (NSString *imageUrl in self.images) {
            UIImageView *smallImage = [[UIImageView alloc] initWithFrame:CGRectMake((i * ScrollingImageViewHeight), 0, imagesScrollViewHeightConstraint.constant, imagesScrollViewHeightConstraint.constant)];
            smallImage.userInteractionEnabled = YES;
            smallImage.tag = ScrollingImageViewTag; // tag t know which ImageViews to remove from "imagesScrollView"
            [smallImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            
            [imagesScrollView addSubview:smallImage];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallImageViewTap:)];
            [smallImage addGestureRecognizer:tapGesture];
            
            i++;
        }
        imagesScrollView.contentSize = CGSizeMake((i* ScrollingImageViewHeight), ScrollingImageViewHeight);
    }
    else{
        imagesScrollViewHeightConstraint.constant = 0;
    }
}

- (void)smallImageViewTap:(UITapGestureRecognizer *) sender{
    if ([sender.view isKindOfClass:[UIImageView class]]) {
        imageView.image = [(UIImageView*)sender.view image];
    }
}

- (IBAction)share:(id)sender
{
    NSArray *activityItems = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@ - %@, %@ @ price %@", self.product.categoryTitle, self.product.title, self.product.productDescription, self.product.price]];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

- (IBAction)sharetoContacts:(id)sender
{
    ShareViewController *shareViewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.product = self.product;
    [self presentViewController:shareViewController animated:NO completion:nil];
}

@end
