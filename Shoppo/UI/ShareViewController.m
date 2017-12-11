//
//  ShareViewController.m
//  Shoppo
//
//  Created by Jey on 11/15/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

#import "ShareViewController.h"
#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController ()
{
    NSMutableArray *contacts;
    
    IBOutlet UITableView *contactsTableView;
}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    contacts = [NSMutableArray array];
    
    [self contactScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dimissView:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)contactScan
{
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
                    [self getAllContact];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            [self getAllContact];
        }
    }
}

- (void)getAllContact
{
    if([CNContactStore class])
    {
        //iOS 9 or later
        NSError* contactError;
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
            [self parseContactWithContact:contact];
        }];
        
        [contactsTableView reloadData];
    }
}

- (void)parseContactWithContact:(CNContact* )contact
{
    NSString *firstName =  contact.givenName;
    NSString *lastName =  contact.familyName;
    NSArray *phone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSString *email = [contact.emailAddresses valueForKey:@"value"];
    NSArray *addrArr = [self parseAddressWithContac:contact];
    
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    details[@"firstName"] = firstName;
    details[@"lastName"] = lastName;
    details[@"phone"] = phone;
    details[@"email"] = email;
    details[@"addrArr"] = addrArr;
    
    [contacts addObject:details];
}

- (NSMutableArray *)parseAddressWithContac:(CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return contacts.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            
            cell.backgroundColor = [UIColor darkTextColor];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.textColor = [UIColor lightTextColor];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            
            cell.imageView.image = [UIImage imageNamed:@"contact.png"];
        }
        
        NSDictionary *details = [contacts objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[details objectForKey:@"firstName"], [details objectForKey:@"lastName"]];
        
        NSArray *phonenos = [details objectForKey:@"phone"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",phonenos[0]];
        
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
        
        NSDictionary *details = [contacts objectAtIndex:indexPath.row];
        NSArray *phonenos = [details objectForKey:@"phone"];
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = [NSString stringWithFormat:@"%@ - %@, %@ @ price %@", self.product.categoryTitle, self.product.title, self.product.productDescription, self.product.price];
            controller.recipients = [NSArray arrayWithArray:phonenos];
            [self presentViewController:controller animated:NO completion:nil];
        }
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
