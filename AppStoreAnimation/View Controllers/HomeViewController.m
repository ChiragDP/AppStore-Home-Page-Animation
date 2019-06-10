//
//  HomeViewController.m
//  AppStoreAnimation
//
//  Created by Chirag Paneliya on 06/06/19.
//  Copyright © 2019 CugnusSoftTech. All rights reserved.
//

#import "HomeViewController.h"
#import "CardContentViewModel.h"
#import "CardCollectionViewCell.h"
#import "CardDetailViewController.h"
#import "AppStoreAnimation-Swift.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray<CardContentViewModel *> *cardModels;
@property (nonatomic, retain) CardTransition *transition;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cardModels = [[NSMutableArray alloc] init];
    
    CardContentViewModel *model = [[CardContentViewModel alloc] init];
    model.primary = @"GAME OF THE DAY";
    model.secondary = @"Minecraft makes a splash";
    model.modelDescription = @"The ocean is a big place. Tap to read how Minecraft's just got even bigger.";
    model.image = [UIImage imageNamed:@"Image-1"];
    [self.cardModels addObject:model];
    
    model = [[CardContentViewModel alloc] init];
    model.primary = @"You won't believe this guy";
    model.secondary = @"Something we want";
    model.modelDescription = @"They have something we want which is not something we need.";
    model.image = [UIImage imageNamed:@"Image-3"];
    [self.cardModels addObject:model];
    
    model = [[CardContentViewModel alloc] init];
    model.primary = @"LET'S PLAY";
    model.secondary = @"Cats, cats, cats!";
    model.modelDescription = @"Play these games right meow.";
    model.image = [UIImage imageNamed:@"Image-2"];
    [self.cardModels addObject:model];
    
    // Make it responds to highlight state faster
    self.collectionView.delaysContentTouches = false;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 64, 0);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = false;
}

#pragma mark - UICollectionView Datasource and Delegate Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCollectionViewCell *cardCell = (CardCollectionViewCell *)cell;
    cardCell.cardContentView.viewModel = self.cardModels[indexPath.row];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cardHorizontalOffset = 20;
    CGFloat cardHeightByWidthRatio = 1.2;
    CGFloat width = collectionView.bounds.size.width - 2 * cardHorizontalOffset;
    CGFloat height = width * cardHeightByWidthRatio;
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell freezeAnimations];
    
    // Get current frame on screen
    CGRect currentCellFrame = cell.layer.presentationLayer.frame;
    
    // Convert current frame to screen's coordinates
    CGRect cardPresentationFrameOnScreen = [cell.superview convertRect:currentCellFrame toView: nil];
    
    // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
    CGPoint center = cell.center;
    CGSize size = cell.bounds.size;
    CGRect r = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
    CGRect cardFrameWithoutTransform = [cell.superview convertRect:r toView: nil];
    
    CardContentViewModel *cardModel = self.cardModels[indexPath.row];
    
    CardDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CardDetailViewController"];
    vc.cardViewModel = cardModel;
    vc.unhighlightedCardViewModel = cardModel; // Keep the original one to restore when dismiss
    
    self.transition = [[CardTransition alloc] initWithFromCardFrame:cardPresentationFrameOnScreen fromCardFrameWithoutTransform:cardFrameWithoutTransform fromCell:cell];
    vc.transitioningDelegate = self.transition;
    vc.modalPresentationCapturesStatusBarAppearance = true;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:true completion:^{
        // Unfreeze
        [cell unfreezeAnimations];
    }];
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
