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
    if (!_ladder)
        _ladder = [[HMLadderViews alloc] initWithViews:self.ladderViews
                                             andHolder:self.view
                                          andTopOffset:50
                                       andBottomOffset:50
                                       useTopNavButton:YES
                                    useBottomNavButton:YES
                                  fadeViewsOutOfCenter:YES];
    return _ladder;
}

- (NSArray*)ladderViews
{
    if (!_ladderViews)
        _ladderViews = @[ self.ladderView5,
                          self.ladderView4,
                          self.ladderView3,
                          self.ladderView2,
                          self.ladderView1 ];
    return _ladderViews;
}

#pragma mark : view controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    int firstCardIndex = (int)([self.ladderViews count] - 1);
    [self.ladder showViewIndex:firstCardIndex withAnimationTime:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
