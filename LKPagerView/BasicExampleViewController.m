//
//  BasicExampleViewController.m
//  FSPagerViewExample-Objc
//
//  Created by Wenchao Ding on 19/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

#import "BasicExampleViewController.h"
#import "LKPagerView.h"

@interface BasicExampleViewController () <UITableViewDataSource,UITableViewDelegate,LKPagerViewDataSource,LKPagerViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *sectionTitles;
@property (strong, nonatomic) NSArray<NSString *> *configurationTitles;
@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (assign, nonatomic) NSInteger numberOfItems;

@property (weak  , nonatomic) IBOutlet UITableView *tableView;
@property (weak  , nonatomic) IBOutlet LKPagerView *pagerView;
@property (weak  , nonatomic) IBOutlet LKPageControl *pageControl;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end

@implementation BasicExampleViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionTitles = @[@"Configurations", @"Item Size", @"Interitem Spacing", @"Number Of Items"];
    self.configurationTitles = @[@"Automatic sliding", @"Infinite"];
    self.imageNames = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg"];
    self.numberOfItems = 7;
    
    [self.pagerView registerClass:[LKPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.pagerView.itemSize = self.pagerView.frame.size;
    self.pageControl.numberOfPages = self.imageNames.count;
    self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.configurationTitles.count;
        case 1:
        case 2:
        case 3:
            return 1;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            // Configurations
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.text = self.configurationTitles[indexPath.row];
            if (indexPath.row == 0) {
                // Automatic Sliding
                cell.accessoryType = self.pagerView.automaticSlidingInterval > 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            } else if (indexPath.row == 1) {
                // IsInfinite
                cell.accessoryType = self.pagerView.isInfinite ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
            return cell;
        }
        case 1: {
            // Item Spacing
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            UISlider *slider = cell.contentView.subviews.firstObject;
            slider.tag = indexPath.section;
            slider.value = ({
                CGFloat scale = self.pagerView.itemSize.width/self.pagerView.frame.size.width;
                CGFloat value = (scale-0.5)*2;
                value;
            });
            slider.continuous = YES;
            return cell;
        }
        case 2: {
            // Interitem Spacing
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            UISlider *slider = cell.contentView.subviews.firstObject;
            slider.tag = indexPath.section;
            slider.value = self.pagerView.interitemSpacing / 20.0;
            slider.continuous = YES;
            return cell;
        }
        case 3: {
            // Number Of Items
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            UISlider *slider = cell.contentView.subviews.firstObject;
            slider.tag = indexPath.section;
            slider.value = self.numberOfItems / 7.0;
            slider.minimumValue = 1.0 / 7;
            slider.maximumValue = 1.0;
            slider.continuous = NO;
            return cell;
        }
        default:
            break;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                // Automatic Sliding
                self.pagerView.automaticSlidingInterval = 3.0 - self.pagerView.automaticSlidingInterval;
            } else if (indexPath.row == 1) {
                // IsInfinite
                self.pagerView.isInfinite = !self.pagerView.isInfinite;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 40 : 20;
}

#pragma mark - LKPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(LKPagerView *)pagerView
{
    return self.numberOfItems;
}

- (LKPagerViewCell *)pagerView:(LKPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    LKPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@(index),@(index)];
    return cell;
}

#pragma mark - LKPagerView Delegate

- (void)pagerView:(LKPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
    self.pageControl.currentPage = index;
}

- (void)pagerViewDidScroll:(LKPagerView *)pagerView
{
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
    }
}

#pragma mark - Target actions

- (void)sliderValueChanged:(UISlider *)sender
{
    switch (sender.tag) {
        case 1: {
            CGFloat scale = 0.5 * (1 + sender.value); // [0.5 - 1.0]
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, CGAffineTransformMakeScale(scale, scale));
            break;
        }
        case 2: {
            self.pagerView.interitemSpacing = sender.value * 20; // [0 - 20]
            break;
        }
        case 3: {
            self.numberOfItems = roundf(sender.value * 7);
            self.pageControl.numberOfPages = self.numberOfItems;
            [self.pagerView reloadData];
            break;
        }
        default:
            break;
    }
}

@end

