//
//  CollectionTableView.m
//  moolti
//
//  Created by Eugene Watson on 11/19/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CollectionTableView.h"
#import "CollectionCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RACAFNetworking.h"
#import "MONActivityIndicatorView.h"



static NSString *const BaseURLString = @"https://moolti.herokuapp.com/";

@interface CollectionTableView () <UITableViewDelegate,MWPhotoBrowserDelegate,MONActivityIndicatorViewDelegate> {
    NSMutableArray *_selections;
    NSUInteger _currentPageIndex;
}
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) UIActivityViewController *activityViewController;

@property (strong, nonatomic) NSMutableArray *thumbs;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableDictionary *collectionsDictionary;
@property (strong, nonatomic) NSMutableArray *collectionImageURLs;


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define ShowHUD(view) [MBProgressHUD showHUDAddedTo:view animated:YES]

@end

@implementation CollectionTableView
{
    NSArray *tableData;
    NSArray *thumbnails;
    NSArray *titles;
}


-(id)initWithStyle:(UITableViewStyle)style {
    if (self=[super initWithStyle:style]) {
        self.title = @"Collections";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor =[UIColor clearColor];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    titles = @[@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg", @"Chloe",@"Celine"];
    tableData = @[@"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg",@"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ch1.jpg",@"ce1.jpg"];
    [self makeCollectionRequest];
    
    [self.tableView reloadData];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    // For a random background color for a particular circle
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)makeMONActivityIndicator
{
    MONActivityIndicatorView *indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 5;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 3;
    indicatorView.duration = 0.8;
    indicatorView.delay = 0.2;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark - Requests

-(void)makeCollectionRequest
{
    
    [self makeMONActivityIndicator];
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/collections/media", BaseURLString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    self.collectionsDictionary = [responseObject objectForKey:@"data"];
        NSMutableDictionary *json = self.collectionsDictionary;
        //need to make array of thumbs and large images for collectionview population. Current method sucks.
        NSMutableArray *urlArray = [NSMutableArray new];
        for (NSMutableDictionary *dict in json)
        {
            [urlArray addObject:[dict valueForKey:@"thumb_url"]];
        }
        self.collectionImageURLs = urlArray;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@", error);
        
    }];
    [op start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger rows = 1;
    @synchronized(_assets) {
        if (_assets.count) rows++;
    }
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return [self.collectionImageURLs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionCell";
    CollectionCell *cell = (CollectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //cell labels
    cell.CollectionName.text = [titles objectAtIndex:indexPath.row];
    cell.CollectionSubLabel.text = @"Spring 2015 Ready-to-Wear";
    cell.CollectionName.font = [UIFont fontWithName:@"Avenir-Light" size:17.0];
    cell.CollectionName.textColor = [UIColor whiteColor];
    cell.CollectionSubLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12.0];
    cell.CollectionSubLabel.textColor = [UIColor whiteColor];
    
    //general cell settings
    cell.backgroundColor = [UIColor blackColor];
    //cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell image
    cell.CollectionImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.CollectionImage.clipsToBounds = YES;
    id hud = ShowHUD(cell.CollectionImage);
    [hud setLabelText:NSLocalizedString(@"Updating Collections", nil)];
    NSMutableArray *appendedURLArray = [[NSMutableArray alloc]init];
    for (NSString *imgURL in self.collectionImageURLs)
    {
        [appendedURLArray addObject:[NSString stringWithFormat:@"http://%@", imgURL]];
    }
    [cell.CollectionImage sd_setImageWithURL:[appendedURLArray objectAtIndex:indexPath.row]];
    [hud hide:YES];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    switch (indexPath.row) {
        
        case 0:
            //photos
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/original/kFunLHXoEMa6zB8lCZJf.jpg"]];
            photo.caption = @"Look 1";
            [photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://d2e8drp4ztoqol.cloudfront.net/collections/1/original/6Rune37NJhY4ww8XEwby.jpg"]];
            photo.caption = @"Look 2";
            [photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/original/85IAEMWp0hmpksCbvQKD.jpg"]];
            photo.caption = @"Look 3";
            [photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/original/p5Vcu8FdNJKperV8WJ2w.jpg"]];
            photo.caption = @"Look 4";
            [photos addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/original/IWvk0UHgSWOoC0lJTlDD.jpg"]];
            photo.caption = @"Look 5";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce6" ofType:@"jpg"]]];
            photo.caption = @"Look 6";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce7" ofType:@"jpg"]]];
            photo.caption = @"Look 7";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce8" ofType:@"jpg"]]];
            photo.caption = @"Look 8";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce9" ofType:@"jpg"]]];
            photo.caption = @"Look 9";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce10" ofType:@"jpg"]]];
            photo.caption = @"Look 10";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce10" ofType:@"jpg"]]];
            photo.caption = @"Look 11";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce12" ofType:@"jpg"]]];
            photo.caption = @"Look 12";
            [photos addObject:photo];
            
            //thumbs
            
             photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/thumb/kFunLHXoEMa6zB8lCZJf.jpg"]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/thumb/f69StMuMQllIDtUpswCs.jpg"]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/thumb/85IAEMWp0hmpksCbvQKD.jpg"]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/thumb/p5Vcu8FdNJKperV8WJ2w.jpg"]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://cdn.runofshow.com/collections/1/thumb/IWvk0UHgSWOoC0lJTlDD.jpg"]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce5" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"house" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce6" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce7" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce8" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce9" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce10" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce10" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce12" ofType:@"jpg"]]];
            [thumbs addObject:photo];

            //options
            
            break;
    
        case 1: {
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch1" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch2" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch3" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch4" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch5" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch6" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch7" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch8" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch9" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch10" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch11" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch12" ofType:@"jpg"]]];
            [photos addObject:photo];
            
            //thumbs
            
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch2" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch3" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch4" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch5" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch6" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch7" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch8" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch9" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch10" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch11" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ch12" ofType:@"jpg"]]];
            [thumbs addObject:photo];

            break;
            
        case 2: {
            
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv1" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv2" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv3" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv4" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv5" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv6" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv7" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv8" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv9" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv10" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv11" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv12" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv13" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv14" ofType:@"jpg"]]];
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv15" ofType:@"jpg"]]];
            [photos addObject:photo];
            
            //thumbs
            
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv2" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv3" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv4" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv5" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv6" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv7" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv8" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv9" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv10" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv11" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv12" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv13" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv14" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dv15" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            
            }
        }

    }
            //photo brower settings
    
            self.photos = photos;
            self.thumbs = thumbs;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            [browser showNextPhotoAnimated:YES];
            [browser showPreviousPhotoAnimated:YES];
            browser.enableGrid = YES;
            browser.startOnGrid = YES;
            browser.displayActionButton = YES;
            browser.displaySelectionButtons = NO;
            [browser setCurrentPhotoIndex:1];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:nc animated:YES completion:nil];
    }


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

- (void)actionButtonPressed:(id)sender {
    if (_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex animated:YES];
        
    }else {
        _selections = [NSMutableArray new];
        for (int i=0; i <_thumbs.count; i++) {
            [_selections addObject:[_photos objectAtIndex:_thumbs.count]];
        }
        
        _activityViewController = [[UIActivityViewController alloc]initWithActivityItems:_selections applicationActivities:nil];
    }
    
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
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
