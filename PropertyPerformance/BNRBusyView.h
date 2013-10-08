//
//  BNRBusyView.h
//  PropertyPerformance
//
//  Created by John Gallagher on 9/5/13.
//  Copyright (c) 2013 BigNerdRanch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRBusyView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

// keyPaths for KVO observers of our class.
extern NSString *const BNRBusyViewKeyLoopStyle;
extern NSString *const BNRBusyViewKeyLoopSize;
extern NSString *const BNRBusyViewKeyLog2LoopSize;

// Different kinds of inner loop styles.
typedef NS_ENUM(NSInteger, BNRBusyViewLoopStyle) {
    BNRBusyViewLoopStyleProperties,
    BNRBusyViewLoopStyleIVars,
    BNRBusyViewLoopStyleConstant,
    BNRBusyViewLoopStyleVolatileIVar,
#ifdef __ARM_NEON__
    BNRBusyViewLoopStyleNeon64,
    BNRBusyViewLoopStyleNeon128,
#endif
    BNRBusyViewNumLoopStyles // Sentinel
};

// Properities controlling the inner loop size and style.
@property (nonatomic, assign) BNRBusyViewLoopStyle loopStyle;

// NOTE: log2LoopSize is the base 2 log of the actual loopSize; e.g., setting log2LoopSize
// to 10 sets loopSize to 2^10 = 1024.
@property (nonatomic, assign) NSUInteger log2LoopSize;
@property (nonatomic, readonly) NSUInteger loopSize;

// Load loopSize and loopStyle from NSUserDefaults.
- (void)loadSettingsFromDefaults;

@end
