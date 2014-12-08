//
//  SMSDataModel.m
//  moolti
//
//  Created by Eugene Watson on 12/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "SMSDataModel.h"

@implementation SMSDataModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray new];
    }
    
    else {
        NSLog(@"These are fake Messages");
    }
    
    JSQMessagesAvatarImage *ewImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"EW" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                                       textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                       font:[UIFont systemFontOfSize:14.0f]
                                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *raImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"EW" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                       textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                            font:[UIFont systemFontOfSize:14.0f]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *kfImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"EW" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                       textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                            font:[UIFont systemFontOfSize:14.0f]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    JSQMessagesAvatarImage *ew2Image = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"EW" backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                       textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                            font:[UIFont systemFontOfSize:14.0f]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
    self.avatars = @{kAvatarIdEugene : ewImage,
                     kAvatarIdRoss : raImage,
                     kAvatarIdKevin : kfImage,
                     kAvatarNameElliott : ew2Image};
    
    
    
    self.users = @{kAvatarIdEugene : kAvatarNameEugene,
                   kAvatarIdRoss : kAvatarNameRoss,
                   kAvatarIdKevin : kAvatarNameKevin,
                   kAvatarIdElliott : kAvatarNameElliott};
    
    
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc]init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];

    return self;

}

- (void)loadFakeMessages

{
    self.messages = [[NSMutableArray alloc]initWithObjects:
                     
                     [[JSQMessage alloc]initWithSenderId:kAvatarIdEugene
                                       senderDisplayName:kAvatarNameEugene
                                                    date:[NSDate distantPast]
                                                    text:@"This is the first text message I've made on my own!"],
                    
                     [[JSQMessage alloc]initWithSenderId:kAvatarIdElliott
                                       senderDisplayName:kAvatarNameElliott
                                                    date:[NSDate distantPast]
                                                    text:@"Yo this app is sweet!"],
                     
                     [[JSQMessage alloc]initWithSenderId:kAvatarIdRoss
                                       senderDisplayName:kAvatarNameRoss
                                                    date:[NSDate date]
                                                    text:@"Moolti is gonna be HUGE!"],
                     
                     nil];
    
    [self addPhotoMedia];
    
    
    NSArray *copyOfMessages = [self.messages copy];
    for(NSUInteger i = 0; i < 4; i++) {
        [self.messages addObjectsFromArray:copyOfMessages];
    }
}

-(void)addPhotoMedia

{
    
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"ce1"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kAvatarIdEugene displayName:kAvatarNameEugene media:photoItem];
    
    [self.messages addObject:photoMessage];
    
}











@end
