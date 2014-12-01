//
//  CollectionTableView.m
//  moolti
//
//  Created by Eugene Watson on 11/19/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CollectionTableView.h"
#import "CollectionCell.h"

@interface CollectionTableView () <UITableViewDelegate,MWPhotoBrowserDelegate> {
    NSMutableArray *_selections;
}

@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *photos;
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
    
    [self.tableView reloadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor =[UIColor clearColor];
    
//    self.tableView.estimatedRowHeight = 78.0;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    titles = @[@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg",@"Celine", @"Chloe", @"Diane von Furstenberg"];
    tableData = @[@"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg", @"ce1.jpg", @"ch1.jpg",@"dv1.jpg"];
   
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger rows = 1;
    @synchronized(_assets) {
        if (_assets.count) rows++;
    }
    return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableData count];
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
    cell.CollectionName.textColor = [UIColor whiteColor];
    cell.CollectionSubLabel.textColor = [UIColor whiteColor];
    
    //cell image
    cell.CollectionImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.CollectionImage.clipsToBounds = YES;
    cell.CollectionImage.image = [UIImage imageNamed:[tableData objectAtIndex:indexPath.row]];

    //general cell settings
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Light" size:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    
    switch (indexPath.row) {
        
        case 0:
            //photos
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce1" ofType:@"jpg"]]];
            photo.caption = @"Look 1";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce2" ofType:@"jpg"]]];
            photo.caption = @"Look 2";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce3" ofType:@"jpg"]]];
            photo.caption = @"Look 3";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce4" ofType:@"jpg"]]];
            photo.caption = @"Look 4";
            [photos addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce5" ofType:@"jpg"]]];
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
             photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce2" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce3" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo1" ofType:@"jpg"]]];
            [thumbs addObject:photo];
            photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ce4" ofType:@"jpg"]]];
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
            
            //options
            displayActionButton = YES;
            displayNavArrows = YES;
            enableGrid = YES;
            startOnGrid = YES;
            
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
            
            displayActionButton = YES;
            displayNavArrows = YES;
            enableGrid = YES;
            startOnGrid = YES;
            
            }
        }

    }
            //photo brower settings
            self.photos = photos;
            self.thumbs = thumbs;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            [browser showNextPhotoAnimated:YES];
            [browser showPreviousPhotoAnimated:YES];
            browser.startOnGrid = YES;
            browser.displayActionButton = YES;
            browser.alwaysShowControls = YES;
            browser.displaySelectionButtons =NO;
            [browser setCurrentPhotoIndex:1];
            [self.navigationController pushViewController:browser animated:YES];
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

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

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
