//
//  ProductsTableViewController.m
//  ShopifyTestTask
//
//  Created by SS D on 2017-12-17.
//  Copyright © 2017 SS D. All rights reserved.
//

#import "ProductsTableViewController.h"
#import "ProductsConnector.h"
#import "Product.h"
#import "ProductDetailViewController.h"

@interface ProductsTableViewController ()
@property ProductsConnector * fetcher;
@property NSArray <Product * > * products;
@property NSString * selectedProductId;
@property UIActivityIndicatorView * activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 30, 100, 100)];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.hidden = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //        self.products = self.fetcher.products;
    //        [self.tableView reloadData];
    //    }];
}


-(void)viewDidAppear:(BOOL)animated{
    if (!self.products){
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.fetcher = [[ProductsConnector alloc] init];
        [self.fetcher requestProductsWithError:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productListUpdated) name:[ProductsConnector responseReceived] object:nil];
    }
}


-(void)productListUpdated{
    self.products = self.fetcher.products;
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIViewController * detailViewController = [[UIViewController alloc]init];
    
//    UIStoryboardSegue * segue = [[UIStoryboardSegue  alloc]initWithIdentifier:@"ProtoSegue" source:self destination:detailViewController];
    self.selectedProductId = self.products[indexPath.row].productId;
    [self performSegueWithIdentifier:@"ProtoSegue" sender:nil];
    
//    [self presentViewController:detailViewController animated:YES completion:^{
//
//    }];
    
    //[UIStoryboardSegue segueWithIdentifier:nil source:self destination:detailViewController];
    
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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     ProductDetailViewController * detailViewController = (ProductDetailViewController *)segue.destinationViewController;
     detailViewController.productId = self.selectedProductId;
     detailViewController.fetcher = self.fetcher;
 }


@end
