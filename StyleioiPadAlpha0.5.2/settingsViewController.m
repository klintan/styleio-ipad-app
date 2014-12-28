//
//  settingsViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-20.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "settingsViewController.h"

@interface settingsViewController ()

@end

@implementation settingsViewController
@synthesize database,delegate;

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
    
    NSLog(@"Settings view loaded");
    database = [[NSMutableArray alloc] init];
    [database addObject:@"Wallpapers"];
    [database addObject:@"Floors"];
    [database addObject:@"Tiles"];
    [database addObject:@"Textiles"];
    


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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [database count];
    if (section == 1)
        return 1;
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"db";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"db"];
    //[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  
    if(indexPath.section == 0)
    {
    // Set up the cell...
    NSString *dbs = [database objectAtIndex:indexPath.row];
    cell.textLabel.text = dbs;
        if(indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
    NSString *logout = @"Logout";
    cell.textLabel.text = logout;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *indexPathOld = [NSIndexPath indexPathForRow:selectedRow inSection:indexPath.section];
    UITableViewCell *cellold = [tableView cellForRowAtIndexPath:indexPathOld];
    
    //NSLog(@"Touched row %d",indexPath.row);
    //NSLog(@"Old row %d",indexPathOld.row);
    //NSLog(@"Selectrow variable: %d",indexPathOld.row);
    NSLog(@"%@",cell.textLabel.text);
    [[self delegate] selectedDatabase:cell.textLabel.text];
    
    //if (indexPath.row!=selectedRow) {
    cellold.accessoryType = UITableViewCellAccessoryNone;
    //}
    //else
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    selectedRow = indexPath.row;
}

@end
