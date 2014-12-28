//
//  searchViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()

@end

@implementation searchViewController
@synthesize popoverController,delegate;

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
    
    searchOptions = [[NSMutableArray alloc] init];
    [searchOptions addObject:@"Take a photo"];
    [searchOptions addObject:@"Choose from Album"];
    
    searchOptionsImage = [[NSMutableArray alloc] init];
    [searchOptionsImage addObject:@"86-camera.png"];
    [searchOptionsImage addObject:@"42-photos.png"];

    


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
     return [searchOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"search";
    //cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = [indexPath row];
    
    textsearch = [tableView dequeueReusableCellWithIdentifier:@"textsearch"];
    camerapicker = [tableView dequeueReusableCellWithIdentifier:@"camerapicker"];
    albumpicker = [tableView dequeueReusableCellWithIdentifier:@"albumpicker"];
    
    camerapicker.textLabel.text = @"Take a photo";
    albumpicker.textLabel.text = @"radius";
    
    UIImage * cameraimg = [UIImage imageNamed:@"86-camera.png"];
    camerapicker.imageView.image = cameraimg;
    
    UIImage * albumimg = [UIImage imageNamed:@"42-photos.png"];
    albumpicker.imageView.image = albumimg;


    
    
    // Configure the cell...
    
    //if (cell == nil) {
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    // Set up the cell...
    //NSString *searchOptionsLabels = [searchOptions objectAtIndex:indexPath.row];
    //cell.textLabel.text = searchOptionsLabels;
    //UIImage * img = [UIImage imageNamed:[searchOptionsImage objectAtIndex:indexPath.row]];
    //cell.imageView.image = img;
    
    return textsearch,camerapicker,albumpicker;
    

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
    // Create image picker controller
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBarHidden = YES;
    imagePicker.toolbarHidden = YES;
    [imagePicker setDelegate:self];
    
    if (indexPath.row == 1) {
    //enable cropping
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [popoverController setDelegate:self];
    [popoverController presentPopoverFromRect:album.bounds inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (indexPath.row == 0){
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMedia");
    if(imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
    [self.popoverController dismissPopoverAnimated:NO];
    }
    else
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [[self delegate] doImageSearch:image];
}


@end
