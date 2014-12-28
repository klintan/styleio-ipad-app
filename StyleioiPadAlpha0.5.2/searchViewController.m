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
@synthesize popoverController,delegate,mbProcess,tableView,indexPath,searchField;

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
    if (section == 0)
        return 1;
    if (section == 1)
        return 2;

    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"search";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    int row = [indexPath row];
//    
//    textsearch = [tableView dequeueReusableCellWithIdentifier:@"textsearch"];
//    camerapicker = [tableView dequeueReusableCellWithIdentifier:@"camerapicker"];
//    albumpicker = [tableView dequeueReusableCellWithIdentifier:@"albumpicker"];
//    
//    camerapicker.textLabel.text = @"Take a photo";
//    albumpicker.textLabel.text = @"radius";
//    
//    UIImage * cameraimg = [UIImage imageNamed:@"86-camera.png"];
//    camerapicker.imageView.image = cameraimg;
//    
//    UIImage * albumimg = [UIImage imageNamed:@"42-photos.png"];
//    albumpicker.imageView.image = albumimg;
//

    
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    if(indexPath.section == 0)
    {
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        //cell.textLabel.text = @"Text Search";
        //do stuff with second array and choose cell type x
        
        CGRect frame = CGRectMake (30, 0, 410, 44);
        searchField = [[UISearchBar alloc] initWithFrame:frame];
        //[searchField sizeToFit];
        [searchField setDelegate:self];
        searchField.placeholder = @"search";
        searchField.backgroundColor = [UIColor clearColor];
        searchField.barTintColor = NO;
        searchField.backgroundImage = NO;
        searchField.translucent = YES;
        searchField.autoresizingMask = YES;
        //[[searchField.subviews objectAtIndex:0] removeFromSuperview];
        [cell addSubview: searchField];
        

    }
    else if(indexPath.section == 1)
    {
        NSString *searchOptionsLabels = [searchOptions objectAtIndex:indexPath.row];
        cell.textLabel.text = searchOptionsLabels;
        UIImage * img = [UIImage imageNamed:[searchOptionsImage objectAtIndex:indexPath.row]];
        cell.imageView.image = img;
        
 //do stuff with first array and choose cell type y
               
//    CGRect frame = CGRectMake (30, 0, 410, 44);
//        
//    UIView *colorpicker = [[UIView alloc] initWithFrame:frame];
//        
//    HRRGBColor rgbColor;
//    RGBColorFromUIColor(color, &rgbColor);
//        
//    HRColorPickerStyle style;
//    style = [HRColorPickerView fitScreenStyle];
//        
//    HRColorPickerView *colorPickerView = [[HRColorPickerView alloc] initWithStyle:style defaultColor:rgbColor];
//        
//    [cell addSubview:colorPickerView];
        
    }
    return cell;
    

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Text change");
    NSLog(@"Searchtext: %@",searchText);
    [[self delegate]doTextSearch:searchText];
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
    imagePicker.wantsFullScreenLayout = YES;
    [imagePicker viewWillAppear:YES];
    [imagePicker viewDidAppear:YES];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NULL];
    

    [imagePicker setDelegate:self];
    
    if (indexPath.row == 1) {
    //enable cropping
    UITableViewCell *popcell = [tableView cellForRowAtIndexPath:indexPath];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [popoverController setDelegate:self];
    [popoverController presentPopoverFromRect:popcell.bounds inView:popcell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    //[[self delegate]getAlbumImage];
    }
    else if (indexPath.row == 0){
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //[self presentViewController:imagePicker animated:YES completion:nil];
        [[self delegate] takePicture];
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
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

    [[self delegate] doImageSearch:image];
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//[self.navigationController.view setFrame:CGRectMake(0, 0, 320,480)];
//}

@end
