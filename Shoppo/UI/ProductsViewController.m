//
//  ProductsViewController.m
//  Shoppo
//
//  Created by Jey on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ObjectManager.h"
#import "Product.h"
#import "ProductDetailsViewController.h"

@interface ProductsViewController ()
{
    IBOutlet UITableView *productsTableView;
}
@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Products";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dimissView:)];
    
    [self registerNotifications];
    
    [objectManager.dataRequestor requestProductsCollection:self.categoryId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dimissView:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark NSNotification Method

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"ProductsListReceived"
                                               object:nil];
}

- (void)refresh
{
    [productsTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDictionary *dict = [objectManager.dataRequestor getProductCollection];
    NSArray *products = [dict objectForKey:self.categoryId];
    return [products count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"ProductTableViewCell%ld",(long)indexPath.section];
        
        NSString *nibName = @"ProductTableViewCell";
        
        ProductTableViewCell *cell = (ProductTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (ProductTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        NSDictionary *dict = [objectManager.dataRequestor getProductCollection];
        NSArray *products = [dict objectForKey:self.categoryId];
        Product *product = [products objectAtIndex:indexPath.row];
        
        cell.productLabel.text = product.title;
        cell.priceLabel.text = product.price;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer new];
        [manager GET:product.imageUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            cell.productImageView.image = [UIImage imageWithData:responseObject];
        }failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        return cell;
    }
    @catch (NSException *exception)
    {
        
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        //deselect the row after it has been selected.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *dict = [objectManager.dataRequestor getProductCollection];
        NSArray *products = [dict objectForKey:self.categoryId];
        Product *product = [products objectAtIndex:indexPath.row];
        
        ProductDetailsViewController *productDetailsViewController = [[ProductDetailsViewController alloc] initWithProduct:product];
        
        [self.navigationController pushViewController:productDetailsViewController animated:NO];
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
