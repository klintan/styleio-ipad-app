//
//  sidebarViewController.m
//  StyleioiPadAlpha0.5.2
//
//  Created by admin on 2012-12-18.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "PSStackedViewController.h"
#import "UIViewController+PSStackedView.h"
#import "sidebarViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface sidebarViewController ()

@end

@implementation sidebarViewController
@synthesize resultsVC,searchVC,mapsVC,detailsVC,favoritesVC,sideVC,settingsVC;
@synthesize slider,sourceImage,sourcePopoverController,searchButton,settingsButton,favouriteButton,resultsButton,selectedDB,popoverSet,selectedDB1,serverhost,indexNumber,albumPopoverController,test1,labels,jsonobjects,name,articleno,manufacturer,collection,noOFobjects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)takePicture {
    NSLog(@"show modal from rootcontroller");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.navigationBarHidden = YES;
    imagePicker.toolbarHidden = YES;
    imagePicker.wantsFullScreenLayout = YES;
    
    [imagePicker setDelegate:self];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.stackController presentViewController:imagePicker animated:YES completion:nil];
}
- (void)getAlbumImage {
    NSLog(@"show album popover from rootcontroller");
    //enable cropping
    //UITableViewCell *popcell = [searchVC.tableView cellForRowAtIndexPath:searchVC.indexPath];
    //imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //albumPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    //[albumPopoverController setDelegate:self];
    //[albumPopoverController presentPopoverFromRect:popcell.bounds inView:popcell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"didFinishPickingMedia");
    if(imagePicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        [self.albumPopoverController dismissPopoverAnimated:NO];
    }
    else
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self doImageSearch:image];
}

//show views
- (IBAction)searchView:(id)sender{
    
    [favouriteButton setSelected:NO];
    [searchButton setSelected:YES];
    [resultsButton setSelected:NO];
    
    
    PSStackedViewController* stack = [self stackController];
    
    [stack pushViewController:searchVC fromViewController:self animated:YES];
    [stack pushViewController:resultsVC fromViewController:searchVC animated:YES];
    
    NSLog(@"%u",[stack.viewControllers count]);
}
- (IBAction)favouritesView:(id)sender{
    
    
    [favouriteButton setSelected:YES];
    [searchButton setSelected:NO];
    [resultsButton setSelected:NO];
    
    
    PSStackedViewController* stack = [self stackController];
    //[stack viewControllers];
    
    //UIViewController *fav = [[stack viewControllers] objectAtIndex:0];
    //indexNumber = [stack.viewControllers count];
    
    //[favoritesVC setPanEnabled:NO];
    [stack pushViewController:favoritesVC fromViewController:self animated:YES];
    //[favoritesVC.view removeGestureRecognizer:stack.panRecognizer];
    [stack pushViewController:detailsVC fromViewController:favoritesVC animated:YES];
    NSLog(@"%u",[stack.viewControllers count]);
}
- (IBAction)resultsView:(id)sender{
    
    [favouriteButton setSelected:NO];
    [searchButton setSelected:NO];
    [resultsButton setSelected:YES];
    PSStackedViewController* stack = [self stackController];
    
    [stack pushViewController:resultsVC fromViewController:self animated:YES];
    [stack pushViewController:detailsVC fromViewController:resultsVC animated:YES];
    
    NSLog(@"%u",[stack.viewControllers count]);
}
- (IBAction)settingsView{
    
    popoverSet= [[UIPopoverController alloc] initWithContentViewController:settingsVC];
    [popoverSet setDelegate:self];
    [popoverSet presentPopoverFromRect:settingsButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

//general functions
-(IBAction)slideChange:(id)sender{
    //NSLog(@"slide change");
    if ([resultsVC.patarray count] != 0) {
    [resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //NSLog(@"changeImage method being called!!!!");
    NSMutableArray *newvalues=[[NSMutableArray alloc]init];
    NSMutableArray *positions =[[NSMutableArray alloc]init];
        
    //int sizecol = [resultsVC.colarray count];
    //int sizepat = [resultsVC.patarray count];
    int counter = 0;
        
    //NSLog(@"Size of colarray: %d", sizecol);
    //NSLog(@"Size of patarray: %d", sizepat);
    //NSLog(@"Color array: %@",resultsVC.colarray);
    //NSLog(@"Pattern array: %@",resultsVC.patarray);
    

        NSString * IMGINDEX      = @"index";
        NSString * PATTERN   = @"pattern";
        NSString * COLOR = @"color";
        NSString * VALUE = @"value";
        
        NSMutableArray * array = [NSMutableArray array];
        
        NSDictionary * dict;
        


    //create a array of weighted values [values] from pattern array and color array
    for (int i=0; i<[resultsVC.colarray count]; i++){
        
        NSString *col1 = [resultsVC.colarray objectAtIndex:i];
        NSString *pat1 = [resultsVC.patarray objectAtIndex:i];
        float col = [col1 floatValue];
        float pat = [pat1 floatValue];
        
        //NSNumber *pat2 = [NSNumber numberWithFloat:pat];
        //NSNumber *col2 = [NSNumber numberWithFloat:col];

        float f = slider.value;
        //NSLog(@"slider: %f",f);
        
        float value = ((f*pat)+((1-f)*col));
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:i], IMGINDEX,  [NSNumber numberWithFloat:pat], PATTERN,
                [NSNumber numberWithFloat:col], COLOR,
                [NSNumber numberWithFloat:value], VALUE, nil];
        [array addObject:dict];
        
        
        counter = counter + 1;
        //NSLog(@"%d",counter);
        
       
        
        if( (slider.value + 0.2) > value && (slider.value - 0.2) < value) {
            //NSLog(@"Slider Value: %f ",slider.value);
            //NSLog(@"Color array: %f",col);
            //NSLog(@"Pattern array: %f",pat);
            //NSLog(@"Value %f",value);
            
            NSNumber *val = [NSNumber numberWithFloat:value];
            [newvalues addObject:val];
            NSNumber *position = [NSNumber numberWithInt:counter];
            [positions addObject:position];
            
        }
        
        //NSLog(@"%@",positions);

        
        //NSLog(@"value: %f",value);
        
        
        //[values addObject:val];
        
        
        //NSSortDescriptor *sortDescriptor;
        //sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"birthDate" ascending:YES] autorelease];
        //NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        //NSArray *sortedArray;
        //sortedArray = [drinkDetails sortedArrayUsingDescriptors:sortDescriptors]
        
    }
        
    NSSortDescriptor *valueDescriptor =[[NSSortDescriptor alloc] initWithKey:VALUE ascending:YES];
        
        id obj;
        NSEnumerator * enumerator = [array objectEnumerator];
        while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
        
        NSArray * descriptors =
        [NSArray arrayWithObjects:valueDescriptor, nil];
        NSArray * sortedArray =
        [array sortedArrayUsingDescriptors:descriptors];
        
        NSLog(@"\nSorted ...");
        
        enumerator = [sortedArray objectEnumerator];
        while ((obj = [enumerator nextObject])) NSLog(@"%@", obj);
        
        
    //NSLog(@"%@",dict);
    //NSLog(@"%@",array);
    //iterate through values array and see which to pick out for the present slidervalue. (Can be done earlier???)
    
    //if ([values objectAtIndex:i] < f+15 && [values objectAtIndex:i] > f-15){
    //       [values addObject:val];
    //   }
    
    //calculate mean value and select all that are above that mean value?
    
    //NSArray *sorted = [values sortedArrayUsingSelector:@selector(compare:)];  // Sort the array by value
    //NSUInteger middle = [sorted count] / 2;                            // Find the index of the middle element
    //NSNumber *median =[sorted objectAtIndex:middle];                      // Get the middle element
    
        
//    NSUInteger middle = [values count] / 2;                            // Find the index of the middle element
//    NSNumber *median =[values objectAtIndex:middle];                      // Get the middle element
//
//    NSLog(@"median: %@",median);
//    
//    
//    NSMutableArray *newvalues=[[NSMutableArray alloc]init];
//    NSMutableArray *positions =[[NSMutableArray alloc]init];
//        
//    int counter = 0;
//    for(int i=0; i<[values count]; i++){
//        counter = counter+1;
//        //[numInArray compare:newNum] == NSOrderedSame
//        //(val < sliderVal+0.3 && val > sliderVal-0.3)
//        if( (slider.value + 0.3) > [[values objectAtIndex:i] floatValue] && (slider.value - 0.3) < [[values objectAtIndex:i] floatValue]) {
//            [newvalues addObject:[values objectAtIndex:i]];
//            NSNumber *position = [NSNumber numberWithInt:counter];
//            [positions addObject:position];
//            
//            
//        }
//    }
    
    //NSLog(@"positions: %@",positions);
    
    
    //Number of rows in the list of images
    int numImagesPerColumn = 3;
        int numrows = round([resultsVC.imgarray count]/numImagesPerColumn);
    
    //Number of images in these two rows, that is the length of the results divided by number of rows

    
    int initialXPos = 0;
    int initialYPos = 0;
    //float x = 0;
    int arraycounter=0;
    UIImageView *tempImageView;
        
       
    //NSLog(@"Pattern array values: %@",resultsVC.patarray);
    //NSLog(@"Color array values: %@",resultsVC.colarray);
    
    for (int i=0; i<numrows; i++)
    {
        for (int j=0; j<numImagesPerColumn; j++)
        {
            //NSLog(@"i = %d , j = %d",i, j);
            NSString *test = [serverhost stringByAppendingString:@"/img/"];
            
            
            //Pick out the positions in the original JSON each img that corresponds to the new values
            //x = [[positions objectAtIndex:arraycounter]intValue];
            
            //display images sorted after new value instead.
            NSDictionary *tests = [sortedArray objectAtIndex:arraycounter];
            //NSLog(@"Sorted Array test: %@",tests);
            int tests2 = [[tests objectForKey:IMGINDEX] intValue];
            //NSLog(@"Value test: %d",tests2);
            
            //Pick the imgs out from the original array
            NSString *test1 = [test stringByAppendingString:[resultsVC.imgarray objectAtIndex:tests2]];
            NSURL *imgurl=[NSURL URLWithString:test1];
            
            //Set a unique name to each created UIimageview to enable each image to get a unique tap recognizer?
            
            //create a image object for each img in the array and put in the scrollable view.
            UIImage *image1;
            CGRect image1Frame;
            image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
            
            //create a frame to be 80x80 in size and get position from Xpos and Ypos
            image1Frame = CGRectMake(initialXPos,initialYPos, 145, 145);
            tempImageView = [[UIImageView alloc] initWithFrame:image1Frame];
            //put the image in the created frame
            [tempImageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            //tempImageView.image=image1;
            
            [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
            [tempImageView.layer setBorderWidth: 1.0];
            //give the image a unique tag
            tempImageView.tag = tests2;
            //make the image clickable for more information
            tempImageView.userInteractionEnabled = YES;
            initialXPos = initialXPos + 145 + 9;
            //finally add the frame with the image to the scrollview for each iteration
            [resultsVC.resultsScroll addSubview:tempImageView];
            [resultsVC.resultsScroll setNeedsDisplay];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [tempImageView addGestureRecognizer:tap];
            arraycounter=arraycounter+1;
            
        }
        initialXPos=0;
        initialYPos = initialYPos + (145 + 9);
        
    }
    
    int contsize = numrows * (145+9) + 10;
    //NSLog(@"Content size: %i",contsize);
    
    [resultsVC.resultsScroll setContentSize:CGSizeMake(0,contsize)];
    resultsVC.resultsScroll.maximumZoomScale = 4.0;
    resultsVC.resultsScroll.minimumZoomScale = 0.75;
    resultsVC.resultsScroll.showsVerticalScrollIndicator = YES;
    resultsVC.resultsScroll.clipsToBounds = YES;
    
    //NSLog(@"newvalues: %@",newvalues);
    }
}
- (void)selectedDatabase:(NSString *)db{
     NSLog(@"Selected database:");
    selectedDB = [[db stringByAppendingString:@".mat"] lowercaseString];
    selectedDB1 = [db lowercaseString];
    //selectedDB = db;
    NSLog(@"%@",selectedDB);
}
- (void)tapImage:(id)sender {
    NSLog(@"%d", ((UIGestureRecognizer *)sender).view.tag);
    int tag = ((UIGestureRecognizer *)sender).view.tag;
    [self tapDetails:(NSInteger *)tag];
}
- (void)goBack {
    NSLog(@"goBack called, expandstack");
    // Show the HUD while the provided method executes in a new thread
       [[self stackController] expandStack:1 animated:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request {
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    //NSData *responseData = [request responseData];
    
    if(self.stackController.firstViewController == favoritesVC){
        NSLog(@"success!!");
        [self resultsView:nil];
    }

    //if(self.stackController.visibleViewControllers.0 == self.view){
    //   [self resultsView:nil];
    //}
	// Show the HUD while the provided method executes in a new thread
    //mbProcess = [MBProgressHUD showHUDAddedTo:sideVC.view animated:YES];
    //mbProcess.mode = MBProgressHUDModeAnnularDeterminate;
    //mbProcess.labelText = @"Loading";
    
    //[mbProcess setDelegate:self];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        //NSData *imageData = UIImageJPEGRepresentation(image,1);
        
        //set source image:
        //sourceImage.image = detailsVC.mainImage.image;
        //        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:5000/search"];
        //
        //        // to make a successful foursquare api request, add your own api credentials here.
        //        // for more information see: https://developer.foursquare.com/overview/auth
        //
        //        NSDictionary *parameters =
        //        [NSDictionary dictionaryWithObjectsAndKeys:
        //         imgfile,   @"img", // lat/lon
        //         [NSString stringWithFormat:@"%@",selectedDB],  @"database",
        //         nil];
        //
        //        return [FSNConnection withUrl:url
        //                           method:FSNRequestMethodGET
        //                           headers:nil
        //                           parameters:parameters
        //                           parseBlock:^id(FSNConnection *c, NSError **error) {
        //                               NSDictionary *d = [c.responseData dictionaryFromJSONWithError:error];
        //                               if (!d) return nil;
        //
        //                               // example error handling.
        //                               // since the demo ships with invalid credentials,
        //                               // running it will demonstrate proper error handling.
        //                               // in the case of the 4sq api, the meta json in the response holds error strings,
        //                               // so we create the error based on that dictionary.
        //                               if (c.response.statusCode != 200) {
        //                                   *error = [NSError errorWithDomain:@"FSAPIErrorDomain"
        //                                                                code:1
        //                                                            userInfo:[d objectForKey:@"meta"]];
        //                               }
        //
        //                               return d;
        //                           }
        //                      completionBlock:^(FSNConnection *c) {
        //                          NSLog(@"complete: %@\n\nerror: %@\n\n", c, c.error);
        //                          self.textView.text = [c.parseResult description];
        //                          self.cancelButton.enabled = NO;
        //
        //                      }
        //                        progressBlock:^(FSNConnection *c) {
        //                            NSLog(@"progress: %@: %.2f/%.2f", c, c.uploadProgress, c.downloadProgress);
        //                        }];
        
        
        //The POST request is created
        //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //[request setURL:[NSURL URLWithString:urlString]];
        //[request setHTTPMethod:@"POST"];
        
        /*
         Boundary is a must when sending a file, representing the start and the end, random generated.
         */
        //NSString *boundary = @"---------------------------14737809831466499882746641449";
        //NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        //        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        //
        //
        //        NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
        //
        //        NSString *eid = [NSString stringWithFormat:@"%@", email];
        //        //NSString *patternVal = [NSString stringWithFormat:@"%.1f", pattern.value];
        //        //NSString *colorVal = [NSString stringWithFormat:@"%.1f", color.value];
        //
        //        /*
        //         Create the setHTTPBody (UTF8 encoding)
        //         */
        //        NSMutableData *body = [NSMutableData data];
        //
        //        [body appendData:[@"Content-Disposition: form-data; name=\"database\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //        [body appendData:[[NSString stringWithFormat:@"%@",selectedDB] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //
        //        [body appendData:[@"Content-Disposition: form-data; name=\"img\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //        [body appendData:[[NSString stringWithFormat:@"%@",imgfile] dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //
        //        // setting the body of the post to the reqeust
        //        [request setHTTPBody:body];
        //
        //        // Create a connection
        //        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        // Store incoming data into a string
        NSData *returnData = [request responseData];
        NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
        
        NSError *e = nil;
        
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        NSLog(@"%@", json);
        
        for (id key in json) {
            
            //NSLog(@"key: %@", key);
            //NSLog(@"key: %@", [jsonArray valueForKey: @"img"]);
            
            
            
            resultsVC.imgarray = [json valueForKey: @"img"];
            resultsVC.colarray = [json valueForKey: @"color"];
            resultsVC.patarray = [json valueForKey: @"pattern"];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        
        //Number of images in these two rows, that is the length of the results divided by number of rows
        int numImagesPerColumn = 3;
        
        //Number of rows in the list of images
        int numrows = round([resultsVC.imgarray count]/numImagesPerColumn);
        
        
        int initialXPos = 0;
        int initialYPos = 0; //30 to begin with
        
        int arraycounter=0;
        UIImageView *tempImageView;
        
        for (int i=0; i<numrows; i++)
        {
            for (int j=0; j<numImagesPerColumn; j++)
            {
                NSString *test = [serverhost stringByAppendingString:@"/img/"];
                test1 = [test stringByAppendingString:[resultsVC.imgarray objectAtIndex:arraycounter]];
                
                
                NSURL *imgurl=[NSURL URLWithString:test1];
                //NSLog(@"key: %@", imgurl);
                //NSLog(@"key: %@", test1);
                //NSSet * imgURL = [NSSet setWithArray:[jsonArray valueForKey:@"img"]];
                
                //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
                
                //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
                
                //Set a unique name to each created UIimageview to enable each image to get a unique tap recognizer?
                
                UIImage *image1;
                CGRect image1Frame;
                image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
                
                image1Frame = CGRectMake(initialXPos,initialYPos, 145, 145);
                tempImageView = [[UIImageView alloc] initWithFrame:image1Frame];
                //tempImageView.image=image1;
                [tempImageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                tempImageView.tag = arraycounter;
                
                tempImageView.layer.shouldRasterize = YES;
                [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
                [tempImageView.layer setBorderWidth: 1.0];
                //tempImageView.layer.borderColor = [[UIColor grayColor] CGColor];
                //tempImageView.layer.borderWidth = 1.2f;
                NSLog(@"%d", tempImageView.tag);
                tempImageView.userInteractionEnabled = YES;
                initialXPos = initialXPos + 145 + 9;
                [resultsVC.resultsScroll addSubview:tempImageView];
                arraycounter=arraycounter+1;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [tempImageView addGestureRecognizer:tap];
                // UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(tapped:)];
                //[tapRecognizer setNumberOfTapsRequired:1];
                
                //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(imageTapped:)];
                
                //[tempImageView addGestureRecognizer:tapRecognizer];
                
            }
            initialXPos=0;
            initialYPos = initialYPos + 145 + 9;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:resultsVC.view animated:YES];
            int contsize = numrows * (145 + 9) + 10;
            [resultsVC.resultsScroll setContentSize:CGSizeMake(0, contsize)];
            resultsVC.resultsScroll.maximumZoomScale = 4.0;
            resultsVC.resultsScroll.minimumZoomScale = 0.75;
            resultsVC.resultsScroll.showsVerticalScrollIndicator = YES;
            [resultsVC.resultsScroll flashScrollIndicators];
            resultsVC.resultsScroll.clipsToBounds = YES;
            [resultsVC.resultsScroll setContentOffset:CGPointMake(0, 0) animated:NO];
            //resultsScroll.delegate = self;
            //[resultsVC.resultsScroll setDelegate:self];
            NSString *imagename = [resultsVC.imgarray objectAtIndex:0];
            NSString *test = [serverhost stringByAppendingString:@"/img/"];
            imagename = [test stringByAppendingString:imagename];
            NSURL *imgurl=[NSURL URLWithString:imagename];
            NSLog(@"imagename %@",imagename);
            NSData *imaged = [[NSData alloc] initWithContentsOfURL:imgurl];
            detailsVC.mainImage.image = [UIImage imageWithData: imaged];
            detailsVC.imageName = imagename;
            [slider setValue:0.5];
            //[mbProcess hide:YES];
            [self resultsView:nil];
        });
    });
    

}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"%@",error);
    [MBProgressHUD hideHUDForView:resultsVC.view animated:YES];
}

- (void)doDBSearch:(NSString *)image{
    if(self.stackController.firstViewController == favoritesVC){
        NSLog(@"sucess!!");
        [self resultsView:nil];
    }

    
    NSLog(@"%@",image);
    
    NSLog(@"%@",selectedDB1);
    
    NSLog(@"%@",image);
    NSURL *url1 = [NSURL URLWithString:image];
    NSData *data = [NSData dataWithContentsOfURL:url1];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [sourceImage setImage:img];
    
    NSString *imgfile =  [image substringFromIndex:27];
    //sideVC.sourceImage.image = image;
    //NSString *urlString = [serverhost stringByAppendingString:@"/search"];
    //NSURL *url = [NSURL URLWithString:[serverhost stringByAppendingString:@"/search"]];
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-217-184-143.eu-west-1.compute.amazonaws.com/static"];

    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setShouldAttemptPersistentConnection:YES];
    [request setPostValue:imgfile forKey:@"img"];
    [ASIHTTPRequest setDefaultTimeOutSeconds:300];
    [request setPostValue:[NSString stringWithFormat:@"%@",selectedDB1] forKey:@"database"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    mbProcess=[[MBProgressHUD alloc] initWithView:self.view];
    mbProcess.labelText=@"Loading Data";
    [resultsVC.view addSubview:mbProcess];
    [mbProcess setDelegate:self];
    [mbProcess show:YES];
    }
- (void)doImageSearch:(UIImage *)image{
    NSLog(@"%@",image);
    
    if(self.stackController.firstViewController == favoritesVC){
        NSLog(@"sucess!!");
        [self resultsView:nil];
    }
        mbProcess=[[MBProgressHUD alloc] initWithView:self.view];
        mbProcess.labelText=@"Loading Data";
        [resultsVC.view addSubview:mbProcess];
        [mbProcess setDelegate:self];
        [mbProcess show:YES];
    //if(self.stackController.visibleViewControllers.0 == self.view){
    //   [self resultsView:nil];
    //}
	// Show the HUD while the provided method executes in a new thread
    //mbProcess = [MBProgressHUD showHUDAddedTo:sideVC.view animated:YES];
    //mbProcess.mode = MBProgressHUDModeAnnularDeterminate;
    //mbProcess.labelText = @"Loading";

    //[mbProcess setDelegate:self];
    [sourceImage setImage:image];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
         NSData *imageData = UIImageJPEGRepresentation(image,1);
    
    //sideVC.sourceImage.image = image;
        
    NSURL *url = [NSURL URLWithString:[serverhost stringByAppendingString:@"/php/mobilesearch.php"]];
    NSString *urlString = [serverhost stringByAppendingString:@"/php/mobilesearch.php"];
        NSLog(@"%@",urlString);
    //set source image:
    //sourceImage.image = detailsVC.mainImage.image;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setShouldAttemptPersistentConnection:YES];
    //[request setPostValue:imgfile forKey:@"img"];
    [ASIHTTPRequest setDefaultTimeOutSeconds:300];
    [request setPostValue:[NSString stringWithFormat:@"%@",selectedDB1] forKey:@"database"];
    [request setData:imageData withFileName:@"temp.jpg" andContentType:@"image/jpeg" forKey:@"userfile"];
    [request setDelegate:self];
    [request startAsynchronous];


    //The POST request is created
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setURL:[NSURL URLWithString:urlString]];
    //[request setHTTPMethod:@"POST"];
    
    
    /*
     Boundary is a must when sending a file, representing the start and the end, random generated.
     */
    //NSString *boundary = @"---------------------------14737809831466499882746641449";
    //NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    //NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    
    //NSString *eid = [NSString stringWithFormat:@"%@", email];
    //NSString *patternVal = [NSString stringWithFormat:@"%.1f", pattern.value];
    //NSString *colorVal = [NSString stringWithFormat:@"%.1f", color.value];
    
    
    //NSString *imageName = @"AATW535.jpg";
    
    
    /*
     Create the setHTTPBody (UTF8 encoding)
     */
    //NSMutableData *body = [NSMutableData data];
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[NSData dataWithData:imageData]];
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"Content-Disposition: form-data; name=\"database\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"%@",selectedDB1] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // setting the body of the post to the reqeust
    //[request setHTTPBody:body];
    
    // Create a connection
    //NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // Store incoming data into a string
    
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    NSLog(@"%@",responseString);
//    // Use when fetching binary data
//    NSData *returnData = [request responseData];
//    NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    [jsonString substringToIndex:[jsonString length]-1];
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",jsonString);
//    
//    NSError *e = nil;
//    
//    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
//    NSLog(@"%@", json);
//    
//    for (id key in json) {
//        
//        //NSLog(@"key: %@", key);
//        //NSLog(@"key: %@", [jsonArray valueForKey: @"img"]);
//        
//        
//        
//        resultsVC.imgarray = [json valueForKey: @"img"];
//        resultsVC.colarray = [json valueForKey: @"color"];
//        resultsVC.patarray = [json valueForKey: @"pattern"];
//    }
//    
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    
//    //Number of images in these two rows, that is the length of the results divided by number of rows
//    int numImagesPerColumn = 3;
//    
//    //Number of rows in the list of images
//    int numrows = round([resultsVC.imgarray count]/numImagesPerColumn);
//    
//    
//    
//    int initialXPos = 0;
//    int initialYPos = 0; //30 to begin with
//    
//    int arraycounter=0;
//    UIImageView *tempImageView;
//    
//    for (int i=0; i<numrows; i++)
//    {
//        for (int j=0; j<numImagesPerColumn; j++)
//        {
//            NSString *test = [serverhost stringByAppendingString:@"/visual/"];
//            NSString *test1 = [test stringByAppendingString:[resultsVC.imgarray objectAtIndex:arraycounter]];
//            
//            
//            NSURL *imgurl=[NSURL URLWithString:test1];
//            NSLog(@"%@",imgurl);
//            //NSLog(@"key: %@", imgurl);
//            //NSLog(@"key: %@", test1);
//            //NSSet * imgURL = [NSSet setWithArray:[jsonArray valueForKey:@"img"]];
//            
//            //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
//            
//            //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
//            
//            //Set a unique name to each created UIimageview to enable each image to get a unique tap recognizer?
//            
//            UIImage *image1;
//            CGRect image1Frame;
//            image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
//            
//            image1Frame = CGRectMake(initialXPos,initialYPos, 145, 145);
//            tempImageView = [[UIImageView alloc] initWithFrame:image1Frame];
//            tempImageView.image=image1;
//            tempImageView.tag = arraycounter;
//            
//            tempImageView.layer.shouldRasterize = YES;
//            [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
//            [tempImageView.layer setBorderWidth: 1.0];
//            //tempImageView.layer.borderColor = [[UIColor grayColor] CGColor];
//            //tempImageView.layer.borderWidth = 1.2f;
//            NSLog(@"%d", tempImageView.tag);
//            tempImageView.userInteractionEnabled = YES;
//            initialXPos = initialXPos + 145 + 9;
//            [resultsVC.resultsScroll addSubview:tempImageView];
//            arraycounter=arraycounter+1;
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//            [tempImageView addGestureRecognizer:tap];
//            // UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(tapped:)];
//            //[tapRecognizer setNumberOfTapsRequired:1];
//            
//            //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(imageTapped:)];
//            
//            //[tempImageView addGestureRecognizer:tapRecognizer];
//            
//        }
//        initialXPos=0;
//        initialYPos = initialYPos + 145 + 9;
//    }
//   
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:resultsVC.view animated:YES];
//        int contsize = numrows * (145 + 9) + 10;
//        [resultsVC.resultsScroll setContentSize:CGSizeMake(0, contsize)];
//        resultsVC.resultsScroll.maximumZoomScale = 4.0;
//        resultsVC.resultsScroll.minimumZoomScale = 0.75;
//        resultsVC.resultsScroll.clipsToBounds = YES;
//        [resultsVC.resultsScroll setContentOffset:CGPointMake(0, 0) animated:NO];
//        //resultsScroll.delegate = self;
//        //[resultsVC.resultsScroll setDelegate:self];
//        NSString *imagename = [resultsVC.imgarray objectAtIndex:0];
//        NSString *test = [serverhost stringByAppendingString:@"/visual/"];
//        imagename = [test stringByAppendingString:imagename];
//        NSURL *imgurl=[NSURL URLWithString:imagename];
//        NSLog(@"imagename %@",imagename);
//        NSData *imaged = [[NSData alloc] initWithContentsOfURL:imgurl];
//        detailsVC.mainImage.image = [UIImage imageWithData: imaged];
//        detailsVC.imageName = imagename;
//        [slider setValue:0.5];
//        //[mbProcess hide:YES];
//        [self resultsView:nil];
//        });
    });

}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [mbProcess removeFromSuperview];
}
- (void)doTextSearch:(NSString *)text{
    NSLog(@"%@",text);
    if ([text length] == 0) {
        [resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    else{
    NSURL *url =[NSURL URLWithString:serverhost];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setShouldAttemptPersistentConnection:YES];
    [ASIHTTPRequest setDefaultTimeOutSeconds:300];
    [request setPostValue:[NSString stringWithFormat:@"%@",text] forKey:@"query"];
    //[request setDelegate:self];
    [request startSynchronous];
    [resultsVC.imgarray removeAllObjects];
    [resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *responseString = [request responseString];
    //NSLog(@"%@",responseString);
    NSData *returnData = [request responseData];
    NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",jsonString);
    
    NSError *e = nil;
    
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSLog(@"%@", json);
    
        

        
    //Number of rows in the list of images

    //NSLog(@"%d",[resultsVC.imgarray count]);

    //NSLog(@"%d",numrows);
    float numImagesPerColumn = 3;    
    int initialXPos = 10;
    int initialYPos = 30; //30 to begin with
    int numrows = 0;
    int arraycounter=0;
    UIImageView *tempImageView;
    
   
    for (int i=0; i<4; i++) {
        NSLog(@"i = : %d", i);
        [jsonobjects addObject:[json valueForKey:[labels objectAtIndex:i]]];
        collection = [json valueForKey:@"collection"];
        name = [json valueForKey:@"name"];
        manufacturer = [json valueForKey:@"manufacturer"];
        articleno = [json valueForKey:@"articleno"];
        NSLog(@"In:  %@",[labels objectAtIndex:i]);
        int count = 0;
        
        UILabel *category = [[UILabel alloc ] initWithFrame:CGRectMake(10.0, initialYPos-28, 472.0, 28.0) ];
        category.textColor = [UIColor blackColor];
        [category setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [resultsVC.resultsScroll addSubview:category];
        category.text = [NSString stringWithFormat: @"%@", [[labels objectAtIndex:i] capitalizedString]];
        
        //category.text = @"Collection";
        
        //[noOFobjects addObject:[[json valueForKey:[labels objectAtIndex:i]] count]];
        for (id key in [json valueForKey:[labels objectAtIndex:i]]) {
            if ((count % 3) == 0 && count!= 0) {
                NSLog(@"Divisible by 3! %d",count);
                
                initialYPos = initialYPos + 145 + 9 + 15;
                initialXPos = 10;
            }
            NSLog(@"Arraycounter: %d", arraycounter);
            NSLog(@"key: %@", key);
            NSLog(@"img: %@", [key objectForKey:@"img"]);
            [resultsVC.imgarray addObject:[key objectForKey:@"img"]];
            
            //int numrows = ceil([[key objectForKey:@"img"] count]/numImagesPerColumn);
            //NSLog(@"%d",numrows);
            //if (numrows == 0) {
            //    numrows = 1;
            //}
        
            NSString *test = [serverhost stringByAppendingString:@"/img/"];
            //if (arraycounter < [resultsVC.imgarray count]) {
            //    NSLog(@"inside the if, not NULL");
            test1 = [test stringByAppendingString:[key objectForKey:@"img"]];
            //}
            //else{
            //    NSLog(@"inside the else, NULL");
            //   break;
            //}
            NSLog(@"%@",test1);
            NSURL *imgurl=[NSURL URLWithString:test1];
            
            UIImage *image1;
            CGRect image1Frame;
            image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
            
            image1Frame = CGRectMake(initialXPos,initialYPos, 145, 145);
            tempImageView = [[UIImageView alloc] initWithFrame:image1Frame];
            //tempImageView.image=image1;
            [tempImageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            tempImageView.tag = arraycounter;
            
            tempImageView.layer.shouldRasterize = YES;
            [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
            [tempImageView.layer setBorderWidth: 1.0];
            //tempImageView.layer.borderColor = [[UIColor grayColor] CGColor];
            //tempImageView.layer.borderWidth = 1.2f;
            //NSLog(@"%d", tempImageView.tag);
            tempImageView.userInteractionEnabled = YES;
            
            

            
            
                       
            [resultsVC.resultsScroll addSubview:tempImageView];
            arraycounter=arraycounter+1;
            count += 1;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [tempImageView addGestureRecognizer:tap];
            
            UILabel *tempcats = [[UILabel alloc ] initWithFrame:CGRectMake(initialXPos, initialYPos+145 + 3, 145.0, 15.0) ];
            tempcats.textColor = [UIColor blackColor];
            tempcats.textAlignment = NSTextAlignmentCenter;
            tempcats.text = [NSString stringWithFormat: @"%@", [[key objectForKey:[labels objectAtIndex:i]] capitalizedString]];
            [tempcats setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
            [resultsVC.resultsScroll addSubview:tempcats];
            initialXPos = initialXPos + 145 + 9;


            //NSLog(@"key: %@", [json valueForKey: [labels objectAtIndex:count]]);
            //NSLog(@"name objects: %@",[[jsonobjects valueForKey: [labels objectAtIndex:i]] valueForKey:@"name"]);
            //NSLog(@"collection objects: %@",[[jsonobjects valueForKey: [labels objectAtIndex:i]] valueForKey:@"collection"]);
            //NSLog(@"img objects: %@",[[jsonobjects valueForKey: [labels objectAtIndex:i]] valueForKey:@"img"]);
        
            //NSLog(@"JSON Objects 1: %@",[json valueForKey:[labels objectAtIndex:i]]);
            
            //NSLog(@"JSON Objects 2: %@",[jsonobjects objectAtIndex:i]);
            
            //NSLog(@"Collection object: %@",collection);
            //NSLog(@"Name Object: %@",name);
            //NSLog(@"Manufacturer object: %@",manufacturer);
            //NSLog(@"Articleno object: %@",articleno);
            //NSLog(@"manufacturer objects: %@",[[json valueForKey: [labels objectAtIndex:count]] valueForKey:@"manufacturer"]);
            //NSLog(@"articleno objects: %@",[[json valueForKey: [labels objectAtIndex:count]] valueForKey:@"articleno"]);
            //for (id k in key) {
            //    NSLog(@"name objec: %@", [k valueForKey: @"name"]);
            //}
            //resultsVC.name = [[key valueForKey: [labels objectAtIndex:i]] valueForKey:@"name"];
            //resultsVC.collection = [[key valueForKey: [labels objectAtIndex:i]] valueForKey:@"collection"];
            //resultsVC.imgarray = [[json valueForKey: [labels objectAtIndex:i]] valueForKey:@"img"];
            //[resultsVC.imgarray addObject: [[key valueForKey:[labels objectAtIndex:i]] valueForKey:@"img"]];
            //resultsVC.name = [json valueForKey: @"name"];
            //resultsVC.collection = [json valueForKey: @"collection"];
            //resultsVC.manufacturer = [json valueForKey: @"manufacturer"];
            //resultsVC.articleno = [json valueForKey: @"articleno"];
            //resultsVC.imgarray = [json valueForKey: @"img"];
            //count += 1;
            }
        
        initialXPos=10;
        initialYPos = initialYPos + 145 + 9 + 55 +15;
    }
    int contsize = (arraycounter) * (145 + 9) + 10;
    [resultsVC.resultsScroll setContentSize:CGSizeMake(0, contsize)];
    resultsVC.resultsScroll.maximumZoomScale = 4.0;
    resultsVC.resultsScroll.minimumZoomScale = 0.75;
    resultsVC.resultsScroll.showsVerticalScrollIndicator = YES;
    [resultsVC.resultsScroll flashScrollIndicators];
    resultsVC.resultsScroll.clipsToBounds = YES;
    [resultsVC.resultsScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    //NSLog(@"Jsonobjects: %@", jsonobjects);
        
    //NSLog(@"img objects: %@", resultsVC.imgarray);
        
    //for (id key in jsonobjects) {
    //
    //    resultsVC.name = [json valueForKey:@"name"];
    //    resultsVC.collection = [json valueForKey: @"collection"];
    //    resultsVC.imgarray = [json valueForKey: @"img"];
    //}
    //[resultsVC.resultsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSLog(@"img objects: %@", resultsVC.imgarray);
    //Number of images in these two rows, that is the length of the results divided by number of rows
    //float numImagesPerColumn = 3;
    
    //Number of rows in the list of images
    //int numrows = ceil([resultsVC.imgarray count]/numImagesPerColumn);
    //NSLog(@"%d",[resultsVC.imgarray count]);
    //NSLog(@"%d",numrows);
    //if (numrows == 0) {
    //    numrows = 1;
    //}
    //NSLog(@"%d",numrows);
    
    //int initialXPos = 0;
    //int initialYPos = 30; //30 to begin with
    
    //int arraycounter=0;
    //UIImageView *tempImageView;
    
//    for (int i=0; i<numrows; i++)
//    {
//        NSLog(@"%d", i);
//        for (int j=0; j<numImagesPerColumn; j++)
//        {
//            NSLog(@"Disp images (num rows,i): %d", i);
//            NSLog(@"Number of columns: %d", j);
//            NSLog(@"ID Arraycounter %d",arraycounter);
//            NSString *test = [serverhost stringByAppendingString:@"/visual/"];
//            if (arraycounter < [resultsVC.imgarray count]) {
//                NSLog(@"inside the if, not NULL");
//                test1 = [test stringByAppendingString:[resultsVC.imgarray objectAtIndex:arraycounter]];
//            }
//            else{
//                NSLog(@"inside the else, NULL");
//                break;
//            }
//            
//            
//            NSURL *imgurl=[NSURL URLWithString:test1];
            //NSLog(@"key: %@", imgurl);
            //NSLog(@"key: %@", test1);
            //NSSet * imgURL = [NSSet setWithArray:[jsonArray valueForKey:@"img"]];
            
            //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
            
            //NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
            
            //Set a unique name to each created UIimageview to enable each image to get a unique tap recognizer?
            
//            UIImage *image1;
//            CGRect image1Frame;
//            image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
//            
//            image1Frame = CGRectMake(initialXPos,initialYPos, 145, 145);
//            tempImageView = [[UIImageView alloc] initWithFrame:image1Frame];
//            //tempImageView.image=image1;
//            [tempImageView setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//            tempImageView.tag = arraycounter;
//            
//            tempImageView.layer.shouldRasterize = YES;
//            [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
//            [tempImageView.layer setBorderWidth: 1.0];
//            //tempImageView.layer.borderColor = [[UIColor grayColor] CGColor];
//            //tempImageView.layer.borderWidth = 1.2f;
//            //NSLog(@"%d", tempImageView.tag);
//            tempImageView.userInteractionEnabled = YES;
//            initialXPos = initialXPos + 145 + 9;
//            [resultsVC.resultsScroll addSubview:tempImageView];
//            arraycounter=arraycounter+1;
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
//            [tempImageView addGestureRecognizer:tap];
            // UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(tapped:)];
            //[tapRecognizer setNumberOfTapsRequired:1];
            
            //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(imageTapped:)];
            
            //[tempImageView addGestureRecognizer:tapRecognizer];
            
//        }
//        UILabel *category = [[UILabel alloc ] initWithFrame:CGRectMake(0.0, initialYPos-28, 472.0, 28.0) ];
//        category.textColor = [UIColor whiteColor];
//        category.backgroundColor = [UIColor blackColor];
//        [resultsVC.resultsScroll addSubview:category];
//        //category.text = [NSString stringWithFormat: @"%@", [resultsVC.collection objectAtIndex:0]];
//        category.text = @"Collection";
//        initialXPos=0;
//        initialYPos = initialYPos + 145 + 9;
//    }
//    int contsize = numrows * (145 + 9) + 10;
//    [resultsVC.resultsScroll setContentSize:CGSizeMake(0, contsize)];
//    resultsVC.resultsScroll.maximumZoomScale = 4.0;
//    resultsVC.resultsScroll.minimumZoomScale = 0.75;
//    resultsVC.resultsScroll.showsVerticalScrollIndicator = YES;
//    [resultsVC.resultsScroll flashScrollIndicators];
//    resultsVC.resultsScroll.clipsToBounds = YES;
//    [resultsVC.resultsScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
- (void)pushViewController {
    NSLog(@"push view");
    
    PSStackedViewController* stack = [self stackController];
    
    [stack pushViewController:searchVC fromViewController:self animated:YES];
    [stack pushViewController:resultsVC fromViewController:searchVC animated:YES];
    
    NSLog(@"%u",[stack.viewControllers count]);
    
    //viewController = [[ExampleViewController2 alloc] initWithStyle:UITableViewStylePlain];
    //((ExampleViewController2 *)viewController).indexNumber = [stackController.viewControllers count];
    //[[self stackController] pushViewController:testVC fromViewController:self animated:YES];
}
- (IBAction)tapSource:(id)sender{
    
    NSLog(@"tapSource");
    UIViewController *SourceImageViewController = [[UIViewController alloc] init];
    UIImageView *sourceImageFull = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,175, 175)]; //create ImageView
    
    [SourceImageViewController.view addSubview: sourceImageFull];
    sourceImageFull.image = sourceImage.image;
    sourcePopoverController = [[UIPopoverController alloc] initWithContentViewController:SourceImageViewController];
    [sourcePopoverController setDelegate:self];
    [sourcePopoverController setPopoverContentSize:CGSizeMake(175, 175)];
    [sourcePopoverController presentPopoverFromRect:sourceImage.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}
- (void)tapDetails:(NSInteger *)tag {
    NSLog(@"Tapped image");
    
    [favouriteButton setSelected:NO];
    [searchButton setSelected:NO];
    [resultsButton setSelected:YES];

    NSString * imagename = [resultsVC.imgarray objectAtIndex:tag];

    
    int r = arc4random() % 6;

    detailsVC.prodName.text = [detailsVC.productName objectAtIndex:r];
    detailsVC.prodDetails.text = [detailsVC.productDetails objectAtIndex:r];
    [detailsVC.prodDetails setLineBreakMode:NSLineBreakByWordWrapping];
    detailsVC.prodDetails.numberOfLines = 0;
    [detailsVC.prodDetails sizeToFit];


    NSString *test = [serverhost stringByAppendingString:@"/img/"];
    NSLog(@"%@", test);
    imagename = [test stringByAppendingString:imagename];
    detailsVC.imageName = imagename;

    NSURL *imgurl=[NSURL URLWithString:imagename];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
    detailsVC.mainImage.image = [UIImage imageWithData: imageData];
    
    PSStackedViewController* stack = [self stackController];
    [stack pushViewController:detailsVC fromViewController:resultsVC animated:YES];
}
- (void)favoritesSelected:(NSString *)favorite{
    NSLog(@"favs Selected");
    NSLog(@"%@",favorite);
    detailsVC.imageName = favorite;
    
    NSURL *imgurl=[NSURL URLWithString:favorite];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgurl];
    detailsVC.mainImage.image = [UIImage imageWithData: imageData];
}
- (void)addFavorite:(NSString *)image{
    NSLog(@"Added to Favorites");
    [favoritesVC.tableView reloadData];
    [favoritesVC.favouritesimages addObject:image];
    [favoritesVC.favourites addObject:detailsVC.prodName.text];
    [favoritesVC.favouritesdetails addObject:detailsVC.prodDetails.text];
    [favoritesVC.tableView reloadData];
}
- (void)showMap{
    PSStackedViewController* stack = [self stackController];
    [stack pushViewController:mapsVC fromViewController:detailsVC animated:YES];
}
- (void)initialLoad{
    [self performSelector:@selector(initialLoadDelay) withObject:self afterDelay:0.01 ];
}
- (void)initialLoadDelay{
    
    [favouriteButton setSelected:NO];
    [searchButton setSelected:YES];
    [resultsButton setSelected:NO];

    PSStackedViewController* stack = [self stackController];

    [stack pushViewController:searchVC fromViewController:self animated:YES];
    [stack pushViewController:resultsVC fromViewController:searchVC animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"view loaded");
    serverhost = @"http://www.styleio.se/beta4";
    
    //add labels for text search
    labels = [[NSMutableArray alloc]init];
    [labels addObject:@"collection"];
    [labels addObject:@"name"];
    [labels addObject:@"manufacturer"];
    [labels addObject:@"articleno"];
    
    jsonobjects = [[NSMutableArray alloc]init];
    name = [[NSMutableArray alloc]init];
    collection = [[NSMutableArray alloc]init];
    articleno = [[NSMutableArray alloc]init];
    manufacturer = [[NSMutableArray alloc]init];
    
    
    //set background 
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    //slider customization
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    slider.transform = trans;
    
    //make source image interactive
    sourceImage.userInteractionEnabled = YES;
    [sourceImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [sourceImage.layer setBorderWidth: 0.8];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSource:)];
    [sourceImage addGestureRecognizer:tap];
    

    
    //instantiate all view controllers and delegates
    UIStoryboard *storyboard = self.storyboard;
    resultsVC = [storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
    searchVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    detailsVC = [storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    favoritesVC = [storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    mapsVC = [storyboard instantiateViewControllerWithIdentifier:@"MapsViewController"];
    sideVC = [storyboard instantiateViewControllerWithIdentifier:@"SidebarViewController"];
    settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];

    [resultsVC setDelegate:self];
    [searchVC setDelegate:self];
    [favoritesVC setDelegate:self];
    [mapsVC setDelegate:self];
    [detailsVC setDelegate:self];
    [settingsVC setDelegate:self];
    
    
    //set default database
    selectedDB1 = @"wallpapers";
    //[self initialLoad];
    
    //PSStackedViewController* stack = [self stackController];
    
    //[stack pushViewController:favoritesVC fromViewController:self animated:YES];
    //[stack pushViewController:detailsVC fromViewController:favoritesVC animated:YES];
    

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
