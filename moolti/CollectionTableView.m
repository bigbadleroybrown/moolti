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

//static NSString *const BaseURLString = @"https://moolti.herokuapp.com/";
static NSString *const BaseURLString = @"http://localhost:8080";

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

@implementation CollectionTableView {
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
  
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor                     = [UIColor clearColor];
    self.view.backgroundColor                         = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
  
    titles = @[
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Celine",
      @"Chloe",
      @"Diane von Furstenberg",
      @"Chloe",
      @"Celine"
    ];
  
    tableData = @[
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ce1.jpg",
      @"ch1.jpg",
      @"dv1.jpg",
      @"ch1.jpg",
      @"ce1.jpg"
    ];
  
    [self makeCollectionRequest];
    [self.tableView reloadData];
}

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index {
  
    // For a random background color for a particular circle
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
  
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Dispose of any resources that can be recreated.
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

-(void)makeCollectionRequest {
  
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
      NSString *urlString   = [NSString stringWithFormat:@"%@/collections/1/images", BaseURLString];
      NSURL    *url         = [NSURL URLWithString:urlString];
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
      AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
      
      op.responseSerializer = [AFJSONResponseSerializer serializer];
      [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.collectionsDictionary = [responseObject objectForKey:@"data"];
        NSMutableDictionary *json = self.collectionsDictionary;
        
        //need to make array of thumbs and large images for collectionview population. Current method sucks.
        NSMutableArray *urlArray = [NSMutableArray new];
      
        for (NSMutableDictionary *dict in json) {
          [urlArray addObject:[dict valueForKey:@"thumb_url"]];
        }
      
        self.collectionImageURLs = urlArray;
        [self.tableView reloadData];
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@", error);
      }];
      
      [op start];
    
      dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      });
    });
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    cell.CollectionName.text          = [titles objectAtIndex:indexPath.row];
    cell.CollectionSubLabel.text      = @"Spring 2015 Ready-to-Wear";
    cell.CollectionName.font          = [UIFont fontWithName:@"Avenir-Light" size:17.0];
    cell.CollectionName.textColor     = [UIColor whiteColor];
    cell.CollectionSubLabel.font      = [UIFont fontWithName:@"Avenir-Light" size:12.0];
    cell.CollectionSubLabel.textColor = [UIColor whiteColor];
    
    //general cell settings
    cell.backgroundColor  = [UIColor blackColor];
    //cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:12];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    //cell image
    cell.CollectionImage.contentMode   = UIViewContentModeScaleAspectFit;
    cell.CollectionImage.clipsToBounds = YES;
  
    id hud = ShowHUD(cell.CollectionImage);
    [hud setLabelText:NSLocalizedString(@"Updating Collections", nil)];
  
    NSMutableArray *appendedURLArray = [[NSMutableArray alloc]init];
  
    for (NSString *imgURL in self.collectionImageURLs) {
      //[appendedURLArray addObject:[NSString stringWithFormat:@"http://%@", imgURL]];
      [appendedURLArray addObject: imgURL];
    }
  
    [cell.CollectionImage sd_setImageWithURL:[appendedURLArray objectAtIndex:indexPath.row]];
    [hud hide:YES];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    switch (indexPath.row) {
      case 0:

        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4112/5059627346_a699d5f6c1.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4112/5059627346_a699d5f6c1_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5201/5258698580_4d9389f39d_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5201/5258698580_4d9389f39d.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm2.staticflickr.com/1431/4720856789_d9a4a7080a_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm2.staticflickr.com/1431/4720856789_d9a4a7080a.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6206/6047707288_2e0ce76b90_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6206/6047707288_2e0ce76b90_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm2.staticflickr.com/1364/1407364070_8ff720cbe5_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm2.staticflickr.com/1364/1407364070_8ff720cbe5_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6199/6080612847_0a57dca311_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6199/6080612847_0a57dca311_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7162/6828211591_2502e4b3ed_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7162/6828211591_2502e4b3ed.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3328/3447420954_cb39562d73_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3328/3447420954_6aa454dbcd.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5449/13934394169_0ed97f0ca1_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5449/13934394169_f09e5caca1_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7054/13943474072_4e2483014d_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7054/13943474072_0d8e51dfa6_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7372/13942083010_2f4e29d121_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7372/13942083010_6f9b9fd42a_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2564/3765609882_9292c3e063_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2564/3765609882_9292c3e063.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3635/3659906401_456fb60db6_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3635/3659906401_456fb60db6.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3706/12361431713_e4156bba5a_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3706/12361431713_1f1ee933b7.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2589/3862450348_1490c1f534_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2589/3862450348_1490c1f534.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7004/6832228399_93ec8ab465_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7004/6832228399_93ec8ab465.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5517/12637401594_28d228b2b5_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5517/12637401594_c3d7e6ba30_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5114/14100218351_e0b5ed0da6_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5114/14100218351_09c86048ea_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7002/6723254925_59dc7ff967_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7002/6723254925_59dc7ff967_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3855/14157253777_5674faec43_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3855/14157253777_c318b9b971_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8426/7712643758_d9690d28b5_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8426/7712643758_d9690d28b5_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7096/13969302764_90fce8745c_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7096/13969302764_b155eb6202_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3601/5843267867_0d27685abe_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3601/5843267867_0d27685abe_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5516/11746249954_efbe50b0b4_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5516/11746249954_6c21411e5c_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7226/7216721302_9aabf8cecc_z.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7226/7216721302_9aabf8cecc.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3746/10136210884_6ea41af630_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3746/10136210884_9df2bf0956_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7341/12996785903_ac3351e10f_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7341/12996785903_d2789d1e23.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7425/11493319325_4f5716d1fe_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7425/11493319325_3a7523b827_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3701/12114659296_2b7bae984e_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3701/12114659296_466d685994_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7438/13664592213_305463b49e_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7438/13664592213_4a235740d2_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7360/9753324203_0fd973e41d_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7360/9753324203_b101f535be.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2905/14058780214_61e8f94ff9_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2905/14058780214_db285a466f_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7410/9741539400_7e53ebcbac_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7410/9741539400_ae300e1661_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7022/6533813769_351972b584_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7022/6533813769_351972b584_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8514/8570921284_f200a2e4a9_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8514/8570921284_f200a2e4a9.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3543/3686426996_6b3c12d5c8_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3543/3686426996_6b3c12d5c8.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8375/8570989174_40c47ee5bb_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8375/8570989174_40c47ee5bb.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4027/4503193080_3b4d072302_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4027/4503193080_3b4d072302_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7418/11120228073_07f855d887_o.png  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7418/11120228073_0d92982e6e_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7420/10684550553_f6d55374ac_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7420/10684550553_cfaa310d83.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7160/6589530193_d79a82d3ec_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7160/6589530193_d79a82d3ec_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7454/10186254295_a1d3e433bf_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7454/10186254295_c040f25989_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2829/10052435334_fe804bc631_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2829/10052435334_3964f0268a_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8391/8481886482_ee05c73261_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8391/8481886482_47c38a7330_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3938/15568558810_ef946edea4_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3938/15568558810_643ce7201a.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8367/8452799885_23e9f51e0b_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8367/8452799885_23e9f51e0b_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7204/7122278257_d225d8aef7_z.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7204/7122278257_d225d8aef7.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2571/3685621549_d43ceb0a96.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2571/3685621549_d43ceb0a96.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2618/3686413068_fd219a87bd_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2618/3686413068_fd219a87bd.jpg"]];
        [thumbs addObject:photo];

        break;
    
      case 1:
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7028/6828211551_31e5c7900c_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7028/6828211551_31e5c7900c.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8474/8113207602_f27b6b24e8_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8474/8113207602_f27b6b24e8.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6215/6242185035_c7fc3510e2_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6215/6242185035_c7fc3510e2_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8100/8582154990_ab113ba458_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8100/8582154990_ab113ba458.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8173/8034420477_8c39fc74b4_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8173/8034420477_8c39fc74b4.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8382/8558005281_41bd837506_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8382/8558005281_41bd837506.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4021/5123470237_be30519922_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4021/5123470237_be30519922.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4144/5028321930_d07b084440_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4144/5028321930_d07b084440.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7001/6754901723_1beb4495a8_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7001/6754901723_1beb4495a8_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2902/14163998354_5ce0a4bf38_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2902/14163998354_776464d3d5_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7023/6724289603_9084a42439_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7023/6724289603_9084a42439_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3205/2285170686_46438b9ee8_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3205/2285170686_0420095869.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3626/3470769868_8a52364d23_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3626/3470769868_8a52364d23.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2532/3921049202_93a373ff5e_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2532/3921049202_93a373ff5e.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7147/6828211573_14dfdfc83b_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7147/6828211573_14dfdfc83b.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6137/5939632031_2b7d0f6c8a_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6137/5939632031_b661673826.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2444/5802430614_9c48a2be22_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2444/5802430614_9c48a2be22_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3567/3686422678_871f8a9606.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3567/3686422678_871f8a9606.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2505/3685622001_558f7ed348_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2505/3685622001_558f7ed348.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6169/6175306733_b0d664ec66_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6169/6175306733_b0d664ec66_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4045/4557150339_2637438406_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4045/4557150339_eeebf089de_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3638/3685622071_d2565edc2e.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3638/3685622071_d2565edc2e.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8374/8543507244_e6238f5ed4_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8374/8543507244_e6238f5ed4.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3538/3686426502_7d94f7e85d.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3538/3686426502_7d94f7e85d.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2647/3685607301_35a2d87591.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2647/3685607301_35a2d87591.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2591/3686426438_0849cb3731.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2591/3686426438_0849cb3731.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2424/3686425586_3b1aa634ff_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2424/3686425586_3b1aa634ff_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2457/3685619485_809266253e_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2457/3685619485_809266253e.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8060/8237346041_475838ae28_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8060/8237346041_475838ae28_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4105/5039665424_e79e4b6dce_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4105/5039665424_e79e4b6dce.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7159/6832228375_a47f6f7fa4_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7159/6832228375_a47f6f7fa4_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2426/3685607657_aa1ca4276a_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2426/3685607657_aa1ca4276a.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3578/3686412492_d30fa4b646.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3578/3686412492_d30fa4b646.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3180/2691480675_ca73a3f139_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3180/2691480675_9721240707.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5543/11485240236_d3429b1133_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5543/11485240236_5e5a75dbe6.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3337/3672818332_eaeac516bf_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3337/3672818332_eaeac516bf.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2670/3686420188_1f18fefe5f_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2670/3686420188_1f18fefe5f_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3582/3686422790_4fb43139a0_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3582/3686422790_4fb43139a0.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2522/3686412636_3f73f20696.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2522/3686412636_3f73f20696.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7307/13431987833_ba4a75a9d5_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7307/13431987833_d23ee0a972.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8222/8270731310_ca14395e4f_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8222/8270731310_ca14395e4f.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5013/5474573840_64ac02a8dc_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5013/5474573840_64ac02a8dc_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6026/5896058891_d933b7e3f6_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6026/5896058891_1bb4cf66d9_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8620/15911461121_4992d2a4b7_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8620/15911461121_db79934e93_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3616/3686426562_d6a021e59b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3616/3686426562_d6a021e59b.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm7.staticflickr.com/6140/5940186382_601beef731_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm7.staticflickr.com/6140/5940186382_3a8bebb0d4_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2516/3686412382_6fb35ab4fc.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2516/3686412382_6fb35ab4fc.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2548/3686422902_ea4349264b_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2548/3686422902_ea4349264b.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2672/3686426650_9886e2cede.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2672/3686426650_9886e2cede.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2657/4046568328_9c12ab005e_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2657/4046568328_9c12ab005e.jpg"]];
        [thumbs addObject:photo];
        break;
            
      case 2:
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7037/7035079361_d71ac1a359_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7037/7035079361_f7a187a51f.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7027/6479781627_97b028bb61_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7027/6479781627_561d3180d3.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3424/3947815592_451893bac2_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3424/3947815592_694c5057e8.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8194/8092437124_6300099186_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8194/8092437124_6300099186.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3746/13435503555_d1a6fd136a_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3746/13435503555_122129245c_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2803/4112341275_2776278cd3_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2803/4112341275_2776278cd3.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2237/2211087900_4c7f5c91e7_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2237/2211087900_f981dfcb23.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2543/4130273539_eac353457d_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2543/4130273539_e815614101.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2721/4127545433_e89f47bc6a_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2721/4127545433_6da9f6b9cb.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4021/5124676576_c51b3754f0_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4021/5124676576_fe59d222a6_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8530/8551798637_341f36b2a3_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8530/8551798637_341f36b2a3.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3127/3425616314_10040e21bb_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3127/3425616314_10040e21bb.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8252/8484230573_52375b3c26_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8252/8484230573_9d90fc48d1.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3190/3727023321_d558c6f6d8.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3190/3727023321_d558c6f6d8.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3355/12986254275_f97d09f72f_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3355/12986254275_0344959bb1.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8241/8540931812_294348697f_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8241/8540931812_294348697f.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7088/7205481258_b89bcaa0b0_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7088/7205481258_df30cd29b2_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2444/3685611827_ae8cb8bb57_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2444/3685611827_ae8cb8bb57_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3713/13493993723_1e30dc3b70_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3713/13493993723_c6f4ebe965_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2649/3947033019_25952952f2_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2649/3947033019_6a69df39ea.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2553/4485073000_6aea9290da_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2553/4485073000_a87a0b488f.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2431/3947814280_4f19a1b1bb_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2431/3947814280_899693d8c4.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3898/14675215530_78dcfd53d1_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3898/14675215530_ea4b4da764_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3608/3685613897_c2af55678f_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3608/3685613897_c2af55678f.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2454/3685606993_3acf600842_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2454/3685606993_3acf600842.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4119/4860463601_83ef4625b2_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4119/4860463601_83ef4625b2_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4139/4902448842_5bd4246748_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4139/4902448842_5bd4246748_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3062/3015192712_c461ea2024_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3062/3015192712_c461ea2024.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm2.staticflickr.com/1216/560720817_61fc268cba_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm2.staticflickr.com/1216/560720817_7e5444d194.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2938/14681536872_260e1d70dd_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2938/14681536872_260e1d70dd.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2510/4052399419_9f38182753_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2510/4052399419_9f38182753.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2469/3901594192_8efb24c5e7_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2469/3901594192_8efb24c5e7.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8202/8193007788_14e2d39045_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8202/8193007788_d227542db3.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2564/4190555089_392c0b38b6_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2564/4190555089_392c0b38b6.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7445/10634186623_640b7738bf_k.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7445/10634186623_807a6830dc.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7304/9635410097_b3b55705d6_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7304/9635410097_b3b55705d6_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3824/9036121782_9365a6dd0c_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3824/9036121782_f1c2ed7a17_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2515/4343582721_9fa7a0ee8a_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2515/4343582721_44f50ce34b.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8377/8544195318_7b9b80c63c_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8377/8544195318_7b9b80c63c.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2734/4388169066_f5f4636ec1_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2734/4388169066_f5f4636ec1.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3112/3098786567_fd38f52886_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3112/3098786567_ec07bd61c7.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3274/2922562023_c8d1aa1733_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3274/2922562023_996a7e2831.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm8.staticflickr.com/7305/9631454060_92700df6a5_h.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm8.staticflickr.com/7305/9631454060_29efb78eba_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3538/3417067461_aa31226a8d_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3538/3417067461_aa31226a8d.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8003/7631649390_f6f07b267c_o.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8003/7631649390_f6fd8bb688.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm4.staticflickr.com/3603/3501008360_76660e078e_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm4.staticflickr.com/3603/3501008360_76660e078e.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm6.staticflickr.com/5147/5600872583_941bb1d17b_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm6.staticflickr.com/5147/5600872583_941bb1d17b.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm3.staticflickr.com/2416/2159905310_a439a228cb_z.jpg?zz=1  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm3.staticflickr.com/2416/2159905310_a439a228cb.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm9.staticflickr.com/8512/8578311601_7767b1e6f8_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8512/8578311601_7767b1e6f8_n.jpg"]];
        [thumbs addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@" https://farm5.staticflickr.com/4083/5030009075_761b5b7c62_b.jpg  "]];
        [photos addObject:photo];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"https://farm5.staticflickr.com/4083/5030009075_761b5b7c62.jpg"]];
        [thumbs addObject:photo];
      }
  
      // MWPhotoBrowser Settings
      self.photos = photos;
      self.thumbs = thumbs;
  
      MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
      [browser showNextPhotoAnimated     : YES];
      [browser showPreviousPhotoAnimated : YES];
      [browser setCurrentPhotoIndex      :   1];
       browser.enableGrid                =  YES;
       browser.startOnGrid               =  YES;
       browser.displayActionButton       =  YES;
       browser.displaySelectionButtons   =   NO;
  
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
    } else {
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