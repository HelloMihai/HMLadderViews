//
//  ViewController.m
//  HMLadderExample
//
//  Created by HelloMihai on 9/7/14.
//  Available under the MIT License. See the LICENSE file for more.
//

#import "ViewController.h"
#import "HMLadderViews.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray* ladderViews;
@property (strong, nonatomic) HMLadderViews* ladder;

@property (strong, nonatomic) IBOutlet UIView* ladderView5;
@property (strong, nonatomic) IBOutlet UIView* ladderView4;
@property (strong, nonatomic) IBOutlet UIView* ladderView3;
@property (strong, nonatomic) IBOutlet UIView* ladderView2;
@property (strong, nonatomic) IBOutlet UIView* ladderView1;
@end

@implementation ViewController

#pragma mark : accessors

- (HMLadderViews*)ladder
{
    if (!_ladder) {
        // view orders matters how they are displayed
        NSArray* views = @[ self.ladderView5,
                            self.ladderView4,
                            self.ladderView3,
                            self.ladderView2,
                            self.ladderView1 ];
        _ladder = [[HMLadderViews alloc] initWithViews:views
                                             andHolder:self.view
                                          andTopOffset:50
                                       andBottomOffset:50
                                       useTopNavButton:YES
                                    useBottomNavButton:YES
                                  fadeViewsOutOfCenter:YES
                                useSwipesForNavigation:YES
                                     maxEdgeViewHeight:50];
        
        [_ladder currentIndexChangedBlock:^(int index) {
            NSLog(@"ladder current index changed to %d", index);
        }];
    }
    return _ladder;
}

#pragma mark : view controller life cycle

-(void)viewDidLayoutSubviews
{
    [self.view layoutIfNeeded];
    int indexOfFirstViewToShow = [self.ladder lastViewIndex];
    [self.ladder initializeOnceToViewIndex:indexOfFirstViewToShow];
}

#pragma mark : actions

- (IBAction)tappedUp:(id)sender
{
    [self.ladder showPrevious];
}

- (IBAction)tappedDown:(id)sender
{
    [self.ladder showNext];
}

@end
