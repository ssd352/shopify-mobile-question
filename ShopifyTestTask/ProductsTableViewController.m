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
@property NSMutableArray <Product * > * products;
@property NSString * selectedProductId;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;
@end

@implementation ProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.searchBar.delegate = self;
    self.products = [[NSMutableArray alloc]init];
    //    self.activityIndicator.hidden = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //        self.products = self.fetcher.products;
    //        [self.tableView reloadData];
    //    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActivityIndicator{
    self.activityIndicator.hidden = NO;
    
    [self.view layoutIfNeeded];
    self.searchBarTopConstraint.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.activityIndicator startAnimating];
}

-(void)hideActivityIndicator{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    [self.view layoutIfNeeded];
    self.searchBarTopConstraint.constant = -20;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    if (self.products.count == 0){
        [self showActivityIndicator];
        self.fetcher = [[ProductsConnector alloc] init];
        [self.fetcher requestProductsWithFilter:nil andError:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productListUpdated) name:[ProductsConnector responseReceived] object:nil];
    }
}


-(void)productListUpdated{
    //TODO: check for errors first, if there are no errors the clear the array
    [self.products removeAllObjects];
    if (self.fetcher.products.count != 0)
        [self.products addObjectsFromArray:self.fetcher.products];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
        [self hideActivityIndicator];
    });
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText is %@", searchText);
    [self showActivityIndicator];
    [self.fetcher requestProductsWithFilter:searchBar.text andError:nil];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self resignFirstResponder];
    [self.searchBar endEditing:YES];
    
    
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
    if (product.image){
        cell.imageView.image = [UIImage imageWithData:product.image];
    }
    
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
//     detailViewController.fetcher = self.fetcher;
 }



@end
