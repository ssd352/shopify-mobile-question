//
//  ProductsTableViewController.m
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductsTableViewController.h"
#import "ProductFetcher.h"
#import "Product.h"

@interface ProductsTableViewController ()
@property ProductFetcher * fetcher;
@property NSArray <Product * > * products;
@end

@implementation ProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.fetcher = [[ProductFetcher alloc] init];
    [self.fetcher requestProducts];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productListUpdated) name:[ProductFetcher responseReceived] object:nil];
    //        self.products = self.fetcher.products;
    //        [self.tableView reloadData];
    //    }];
}

-(void)productListUpdated{
    self.products = self.fetcher.products;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProtoCell" forIndexPath:indexPath];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    //    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    Product * product = self.products[indexPath.row];
    cell.textLabel.text = product.title;
    cell.detailTextLabel.text = product.productDescription;
    
    
    CGRect frame = cell.imageView.frame;
    frame.size = CGSizeMake(100, 100);
    cell.imageView.frame = frame;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = [UIImage imageWithData:product.image];
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
