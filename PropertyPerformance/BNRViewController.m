//
//  BNRViewController.m
//  PropertyPerformance
//
//  Created by John Gallagher on 9/5/13.
//  Copyright (c) 2013 BigNerdRanch. All rights reserved.
//

#import "BNRViewController.h"
#import "BNRBusyView.h"

// Context used for KVO observing.
static char *BNRViewControllerContext;

@interface BNRViewController ()

@property (weak, nonatomic) IBOutlet BNRBusyView *busyView;
@property (weak, nonatomic) IBOutlet UILabel *loopSizeLabel;
@property (weak, nonatomic) IBOutlet UISlider *loopSizeSlider;
@property (weak, nonatomic) IBOutlet UIPickerView *loopStylePicker;

- (IBAction)loopSizeSliderChanged:(UISlider *)sender;

@end

@implementation BNRViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.busyView addObserver:self
                    forKeyPath:BNRBusyViewKeyLoopSize
                       options:NSKeyValueObservingOptionNew
                       context:&BNRViewControllerContext];
    [self.busyView addObserver:self
                    forKeyPath:BNRBusyViewKeyLoopStyle
                       options:NSKeyValueObservingOptionNew
                       context:&BNRViewControllerContext];
    [self.busyView addObserver:self
                    forKeyPath:BNRBusyViewKeyLog2LoopSize
                       options:NSKeyValueObservingOptionNew
                       context:&BNRViewControllerContext];

    [self.busyView loadSettingsFromDefaults];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &BNRViewControllerContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:BNRBusyViewKeyLoopSize]) {
        NSUInteger loopSize = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        self.loopSizeLabel.text = [NSString stringWithFormat:@"Loop Size: %u", loopSize];
    } else if ([keyPath isEqualToString:BNRBusyViewKeyLog2LoopSize]) {
        NSUInteger log2LoopSize = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        [self.loopSizeSlider setValue:(float)log2LoopSize animated:NO];
    } else if ([keyPath isEqualToString:BNRBusyViewKeyLoopStyle]) {
        NSInteger style = [change[NSKeyValueChangeNewKey] integerValue];
        [self.loopStylePicker selectRow:style inComponent:0 animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)loopSizeSliderChanged:(UISlider *)sender {
    // Round to nearest integer
    self.busyView.log2LoopSize = (NSUInteger)(sender.value + 0.5f);
}

@end
