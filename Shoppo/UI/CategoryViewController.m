//
//  CategoryViewController.m
//  Shoppo
//
//  Created by Jeyamahesan on 11/14/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "CategoryViewController.h"
#import "ObjectManager.h"
#import "CollectionTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "Category.h"
#import "ProductsViewController.h"

@interface CategoryViewController ()
{
    IBOutlet UITableView *categoriesTableView;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark NSNotification Method

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"CategoriesReceived"
                                               object:nil];
}

- (void)refresh
{
    [categoriesTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *categories = [objectManager.dataRequestor getCategoryCollection];
    return [categories count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        NSString *cellIdentifier = [NSString stringWithFormat:@"CollectionTableViewCell%ld",(long)indexPath.section];
        
        NSString *nibName = @"CollectionTableViewCell";
        
        CollectionTableViewCell *cell = (CollectionTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (CollectionTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        NSArray *categories = [objectManager.dataRequestor getCategoryCollection];
        Category *category = [categories objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = category.title;
        
        cell.descriptionLabel.text = category.categoryDescription;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer new];
        
        [manager GET:category.imageUrl parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            cell.collectionImageView.image = [UIImage imageWithData:responseObject];
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
        
        NSArray *categories = [objectManager.dataRequestor getCategoryCollection];
        Category *category = [categories objectAtIndex:indexPath.row];
        
        //Present products view
        ProductsViewController *productsViewController = [[ProductsViewController alloc] initWithNibName:@"ProductsViewController" bundle:nil];
        productsViewController.categoryId = category.categoryId;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:productsViewController];
        navController.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:navController animated:NO completion:nil];
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
