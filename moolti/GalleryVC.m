//
//  GalleryVC.m
//  moolti
//
//  Created by Eugene Watson on 11/18/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "GalleryVC.h"


@interface GalleryVC ()

@property (strong, nonatomic) MWPhotoBrowser *browser;

@end

@implementation GalleryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_b.jpg"]];
    photo.caption = @"Tube";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3779/9522424255_28a5a9d99c_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_b.jpg"]];
    photo.caption = @"Flat White at Elliot's";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3777/9522276829_fdea08ffe2_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8379/8530199945_47b386320f_b.jpg"]];
    photo.caption = @"Woburn Abbey";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8379/8530199945_47b386320f_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8364/8268120482_332d61a89e_b.jpg"]];
    photo.caption = @"Frosty walk";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm9.static.flickr.com/8364/8268120482_332d61a89e_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm8.static.flickr.com/7109/7604416018_f23733881b_b.jpg"]];
    photo.caption = @"Jury's Inn";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm8.static.flickr.com/7109/7604416018_f23733881b_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm7.static.flickr.com/6002/6020924733_b21874f14c_b.jpg"]];
    photo.caption = @"Heavy Rain";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm7.static.flickr.com/6002/6020924733_b21874f14c_q.jpg"]]];
    photo = [MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm5.static.flickr.com/4012/4501918517_5facf1a8c4_b.jpg"]];
    photo.caption = @"iPad Application Sketch Template v1";
    [photos addObject:photo];
    [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm5.static.flickr.com/4012/4501918517_5facf1a8c4_q.jpg"]]];
    displayActionButton = YES;
    displaySelectionButtons = YES;
    displayNavArrows = YES;
    enableGrid = YES;
    startOnGrid = YES;
    
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    [self.navigationController pushViewController:browser animated:YES];
   
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Do any additional setup after loading the view.
}

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
