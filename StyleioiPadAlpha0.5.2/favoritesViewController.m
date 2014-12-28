//
//  favoritesViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "favoritesViewController.h"

@interface favoritesViewController ()

@end

@implementation favoritesViewController
@synthesize favourites,favouritesdetails,favouritesimages,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //while (self.view.gestureRecognizers.count) {
    //    [self.view removeGestureRecognizer:[self.view.gestureRecognizers objectAtIndex:0]];
    //}
    
    NSLog(@"Favourites view loaded");
    favourites = [[NSMutableArray alloc] init];
    [favourites addObject:@"Malabar"];
    [favourites addObject:@"Pompeian"];
    [favourites addObject:@"Peach"];
    
    favouritesimages = [[NSMutableArray alloc] init];
    [favouritesimages addObject:@"http://www.styleio.se/beta4/img/wallpapers/PP49202.gif"];
    [favouritesimages addObject:@"http://www.styleio.se/beta4/img/wallpapers/ta_01806.gif"];
    [favouritesimages addObject:@"http://www.styleio.se/beta4/img/floors/100218.jpg"];

    
    favouritesdetails = [[NSMutableArray alloc] init];
    [favouritesdetails addObject:@"From a group of paisley inspired designs"];
    [favouritesdetails addObject:@"A modern botanical drawing of Orchid"];
    [favouritesdetails addObject:@"Paisley inspired with a twist"];



    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [favourites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favourite";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *favs = [favourites objectAtIndex:indexPath.row];
    cell.textLabel.text = favs;
    
    //NSDictionary *item = (NSDictionary *)[self.content objectAtIndex:indexPath.row];
    //cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    //cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    
    NSString *details= [favouritesdetails objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =  details;
    
    
    NSString *path = [favouritesimages objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    cell.imageView.image = img;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//-(void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    
//    [self.tableView setEditing:editing animated:animated];
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [favourites removeObjectAtIndex:indexPath.row];
        [favouritesimages removeObjectAtIndex:indexPath.row];
        [favouritesdetails removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadData];
    }   
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSLog(@"row pressed %i",indexPath.row);
    [[self delegate] favoritesSelected:[favouritesimages objectAtIndex:indexPath.row]];

}

@end
