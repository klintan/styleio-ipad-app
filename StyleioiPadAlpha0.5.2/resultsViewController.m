//
//  resultsViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "resultsViewController.h"

@interface resultsViewController ()

@end

@implementation resultsViewController
@synthesize delegate,imgarray,patarray,colarray,resultsScroll,collection,manufacturer,name,articleno;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)back:(id)sender{
    NSLog(@"Back touched");
    [[self delegate] goBack];
}

-(void)tapImage:(id)sender {
	NSLog(@"Tapped image");
    
    NSLog(@"%d", ((UIGestureRecognizer *)sender).view.tag);
    
    int tag = ((UIGestureRecognizer *)sender).view.tag;
    [[self delegate] tapDetails:(NSInteger *)tag];
    
    //NSString * imagename = [imgarray objectAtIndex:tag];
    
    //[[self delegate] showDetails:(NSString *)imagename];

}


- (void)viewDidAppear
{
    NSLog(@"Results viewDidAppear");
}

- (void)viewWillAppear
{
    NSLog(@"Results viewWillAppear");
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Results viewDidLoad");
    imgarray = [[NSMutableArray alloc] init];
    patarray = [[NSMutableArray alloc] init];
    colarray = [[NSMutableArray alloc] init];
    
    name = [[NSMutableArray alloc] init];
    articleno = [[NSMutableArray alloc] init];
    manufacturer = [[NSMutableArray alloc] init];
    collection = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.styleio.se/beta4/initial_images.php"]];
    
    // Create a connection
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // Store incoming data into a string
    NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    NSError *e = nil;
    
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    NSLog(@"%@", json);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    imgarray = json;
    
    //for (id key in json) {
    
    //NSLog(@"key: %@", key);
    //NSLog(@"key: %@", [jsonArray valueForKey: @"img"]);
    //    imgarray = [json valueForKey: @""];
    //}
    
    //Number of images in these two rows, that is the length of the results divided by number of rows
    int numImagesPerColumn = 3;
    
    //Number of rows in the list of images
    int numrows = round([imgarray count]/numImagesPerColumn);
    
    
    
    int initialXPos = 0;
    int initialYPos = 0; //30 to begin with
    
    int arraycounter=0;
    UIImageView *tempImageView;
    
    for (int i=0; i<numrows; i++)
    {
        for (int j=0; j<numImagesPerColumn; j++)
        {
            NSString *test = @"http://www.styleio.se/beta4/";
            NSString *test1 = [test stringByAppendingString:[imgarray objectAtIndex:arraycounter]];
            
            
            NSURL *imgurl=[NSURL URLWithString:test1];
            
            NSLog(@"imgurls: %@", imgurl);
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
            tempImageView.image=image1;
            tempImageView.tag = arraycounter;
            //tempImageView.layer.borderColor = [[UIColor grayColor] CGColor];
            //tempImageView.layer.borderWidth = 1.2f;
            NSLog(@"%d", tempImageView.tag);
            tempImageView.userInteractionEnabled = YES;
            
            [resultsScroll addSubview:tempImageView];
            arraycounter=arraycounter+1;
            
            tempImageView.layer.shouldRasterize = YES;
            [tempImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
            [tempImageView.layer setBorderWidth: 1.0];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
            [tempImageView addGestureRecognizer:tap];
            // UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(tapped:)];
            //[tapRecognizer setNumberOfTapsRequired:1];
            
            //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:tempImageView action:@selector(imageTapped:)];
            
            //[tempImageView addGestureRecognizer:tapRecognizer];
            initialXPos = initialXPos + 145 + 9;
        }
        initialXPos=0;
        initialYPos = initialYPos + 145 + 9;
    }
    
    int contsize = numrows * (145+9);
    [resultsScroll setContentSize:CGSizeMake(0, contsize)];
    resultsScroll.maximumZoomScale = 4.0;
    resultsScroll.minimumZoomScale = 0.75;
    resultsScroll.clipsToBounds = YES;
    resultsScroll.showsVerticalScrollIndicator = YES;
    //resultsScroll.delegate = self;
    [resultsScroll setDelegate:self];
    [resultsScroll flashScrollIndicators];
    
    //[[self delegate] initialLoad];
        
        
    });
    [self.view setNeedsDisplay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
