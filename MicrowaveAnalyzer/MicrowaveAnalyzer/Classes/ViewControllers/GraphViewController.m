//
//  GraphViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.04.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GraphViewController.h"
#import "MainTheme.h"
#import "S2PSelectViewController.h"
#import "SelectCharacteristicViewController.h"
#import "GraphDataSource.h"
#import "ABCDCharacteristic.h"
#import "NFMinCharacteristic.h"
#import "Measurement.h"
#import "GraphsInfoViewController.h"
#import "FootnoteView.h"
#import "GMaxCharacteristic.h"
#import "SmithChartView.h"
#import "GTCharacteristic.h"
#import "NFCharacteristic.h"
#import "EditFileViewController.h"

@interface Plot : CPTScatterPlot <NSCopying>

@end

@implementation Plot

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end



@interface GraphViewController ()

@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphHostingView;
@property (nonatomic, strong) IBOutlet UIView *touchedView;
@property (nonatomic, strong) IBOutlet SmithChartView *smithChartView;
@property (nonatomic) BOOL editing;

@end

@implementation GraphViewController {
    CPTXYGraph *_graph;
    NSDictionary *_measurements;
    UIPopoverController *_popover;
    GraphDataSource *_dataSource;
    NSArray *_allCharacteristics;
    NSArray *_graphCharacteristics;
    
    UIBarButtonItem *_addBarButtonItem;
    UIBarButtonItem *_editBarButtonItem;
    UIBarButtonItem *_doneEditingBarButtonItem;
    NSArray *_rightBarButtonsWithInfo;
    NSArray *_rightBarButtonsWithoutInfo;
    FootnoteView *_activeFootnoterView;
    
    NSMutableArray *_allFootnoters;
    
    NSString *_frequencyString;
    
    NSString *_s2pFileName;
}

- (id)initWithMeasurements:(NSDictionary *)measurements fileName:(NSString *)fileName {
    if ((self = [super init])) {
        _measurements = measurements;
        _s2pFileName = fileName;
        
        UIBarButtonItem *fileButton = [[UIBarButtonItem alloc] initWithTitle:@"File"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(onFileButtonTap:)];
        
        _addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(onListButtonTap:)];
        _rightBarButtonsWithoutInfo = @[_addBarButtonItem, fileButton];
        
        _editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                           target:self
                                                                           action:@selector(onEditButtonTap:)];
        
        _doneEditingBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(onDoneEditingButtonTap:)];
        
        _allFootnoters = [NSMutableArray new];
        
        _rightBarButtonsWithInfo = @[_addBarButtonItem,
                                     [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(onInfoButtonTap:)],
                                     fileButton];
        
        _frequencyString = _measurements[@"fString"];
        
        _dataSource = [[GraphDataSource alloc] initWithFreq:((Measurement *)[[_measurements allValues] lastObject]).freq];
        NSMutableArray *allCharacteristics = [NSMutableArray new];
        
        Measurement *s = _measurements[@"S"];
        double R = [_measurements[@"R"] doubleValue];
        
        NSArray *portCassesStrings = @[@"ABCDCharacteristic", @"SPortCharacteristic", @"ZPortCharacteristic", @"YPortCharacteristic", @"HPortCharacteristic"];
        
        for (NSString *className in portCassesStrings) {
            [allCharacteristics addObject:[[NSClassFromString(className) alloc] initWithMeasurement:s R:R]];
        }
        NFMinCharacteristic *NFmin = [[NFMinCharacteristic alloc] initWithMeasurement:_measurements[@"NFmin(dB)"]];
        [allCharacteristics addObject:NFmin];
        [allCharacteristics addObject:[[GMaxCharacteristic alloc] initWithMeasurement:s]];
        [allCharacteristics addObject:[[GTCharacteristic alloc] initWithMeasurement:s]];
        
        Measurement *gammaMag = _measurements[@"Mag(GammaOpt)"];
        Measurement *gammaAng = _measurements[@"Ang(GammaOpt)(deg)"];
        NSMutableArray *gammaValues = [NSMutableArray new];
        
        [gammaMag.freq enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [gammaValues addObject:[[ComplexNumber alloc] initWithAng:[[gammaAng measurementForFrequency:obj] doubleValue]
                                                                  mag:[[gammaMag measurementForFrequency:obj] doubleValue]]];
        }];
        
        [allCharacteristics addObject:[[NFCharacteristic alloc] initWithSParams:s
                                                                             rn:_measurements[@"rn(normalized_by_ref._impedance)"]
                                                                       gammaOpt:[[Measurement alloc] initWithFreq:gammaMag.freq values:gammaValues]
                                                                          NFMin:NFmin]];
        
        _allCharacteristics = [allCharacteristics copy];
    }
    return self;
}

-(void)plotSpace:(CPTPlotSpace *)space didChangePlotRangeForCoordinate:(CPTCoordinate)coordinate {
    [self refreshFootnotes];
}

- (void)setEditing:(BOOL)editing {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.delegate = self;
    plotSpace.allowsUserInteraction = editing;
    
    NSMutableArray *items = [_rightBarButtonsWithInfo mutableCopy];
    [self.navigationItem setRightBarButtonItems:nil animated:YES];
    
    if (editing) {
        [items addObject:_doneEditingBarButtonItem];
        //[self.touchedView removeFromSuperview];
        self.touchedView.userInteractionEnabled = NO;
    } else {
        [items addObject:_editBarButtonItem];
        self.touchedView.frame = self.view.bounds;
        //[self.view addSubview:self.touchedView];
        self.touchedView.userInteractionEnabled = YES;
    }
    [self.navigationItem setRightBarButtonItems:items animated:YES];
}

- (void)onEditButtonTap:(id)sender {
    self.editing = YES;
}

- (void)onFileButtonTap:(id)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[EditFileViewController alloc] initWithFileName:_s2pFileName]]
                       animated:YES
                     completion:nil];
}

- (void)onDoneEditingButtonTap:(id)sender {
    self.editing = NO;
}

- (void)addActiveFootnoteViewIfNeededForharacteristic:(BaseCharacteristic *)ch {
    if (_activeFootnoterView == nil) {
        _activeFootnoterView = [FootnoteView view];
        _activeFootnoterView.characteristic = ch;
        [_allFootnoters addObject:_activeFootnoterView];
        [_activeFootnoterView addTarget:self action:@selector(onFootnoterViewTap:) forControlEvents:UIControlEventTouchDown];
        __weak id activeView = _activeFootnoterView;
        __weak id allViews = _allFootnoters;
        _activeFootnoterView.onCloseButtonTap = ^ {
            [activeView removeFromSuperview];
            [allViews removeObject:activeView];
        };
    }
}

#define POINT_IS_EMPTY(point) CGPointEqualToPoint((point), CGPointZero)

- (IBAction)onTouchedViewTouch:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:_graph.hostingView];
    
    if (!self.smithChartView.isHidden) {
        if (!_activeFootnoterView) {
            [self.smithChartView beginTouch:point];
        }
        
        ComplexPoint *cPoint = [self.smithChartView pointForTouchedPoint:point];
        if (!POINT_IS_EMPTY(cPoint.realPoint)) {
            CGPoint footnotePoint = [self.view convertPoint:cPoint.realPoint fromView:self.smithChartView];
            [self addActiveFootnoteViewIfNeededForharacteristic:self.smithChartView.currentCharacteristic];
            if (!_activeFootnoterView.superview) {
                _activeFootnoterView.center = footnotePoint;
                [self.touchedView addSubview:_activeFootnoterView];
            } else {
                [UIView animateWithDuration:_activeFootnoterView.superview ? 0.2 : 0. animations:^{
                    _activeFootnoterView.center = footnotePoint;
                }];
            }
            [_activeFootnoterView setFrequency:[cPoint.freq doubleValue]
                                 complexNumber:cPoint.complexNumber
                          frequencyMeasurement:_frequencyString];
            
        }
    } else {
        double *graphPoint = malloc(2 * sizeof(double));
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
        CGPoint plotAreaPoint = [_graph convertPoint:point toLayer:_graph.plotAreaFrame.plotArea];
        
        //WTF???
        plotAreaPoint.y = point.y;
        
        plotAreaPoint.y = _graph.hostingView.frame.size.height - plotAreaPoint.y;
        [plotSpace doublePrecisionPlotPoint:graphPoint forPlotAreaViewPoint:plotAreaPoint];
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            [_dataSource beginTouch:graphPoint];
            [self addActiveFootnoteViewIfNeededForharacteristic:_dataSource.nearestCharacteristic];
        }
        [_dataSource convertPointToNearestValues:graphPoint];
        
        CGPoint result = [self graphPointToViewPoint:graphPoint];
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            _activeFootnoterView.center = result;
            [self.touchedView addSubview:_activeFootnoterView];
            _activeFootnoterView.deleteButton.hidden = YES;
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                _activeFootnoterView.center = result;
            }];
        }
        
        [_activeFootnoterView setGraphPoint:graphPoint];
        
        free(graphPoint);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded
        || recognizer.state == UIGestureRecognizerStateCancelled
        || recognizer.state == UIGestureRecognizerStateFailed) {
        _activeFootnoterView.deleteButton.hidden = NO;
        _activeFootnoterView = nil;
    }
}

- (CGPoint)graphPointToViewPoint:(double *)graphPoint {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    CGPoint result = [_graph convertPoint:[plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:graphPoint] fromLayer:_graph.plotAreaFrame.plotArea];
    result.y = _graph.hostingView.frame.size.height - result.y;
    return result;
}

- (void)onFootnoterViewTap:(id)sender {
    _activeFootnoterView = sender;
    [_activeFootnoterView.superview bringSubviewToFront:_activeFootnoterView];
}

- (void)onInfoButtonTap:(id)sender {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:
                                   [[GraphsInfoViewController alloc] initWithCharacteristicsByColor:[_dataSource characteristicsByColor]]];
    nvc.modalPresentationStyle = UIModalPresentationFormSheet;
    nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onCompleSelectCharacteristics:(NSArray *)result {
    if (IS_IPAD) {
        [_popover dismissPopoverAnimated:YES];
    }
    _graphCharacteristics = result;
    [self reload];
}

- (void)onListButtonTap:(id)sender {
    SelectCharacteristicViewController *selectVC = [[SelectCharacteristicViewController alloc] initWithCharacteristics:_allCharacteristics
                                                                                               selectedCharacteristics:_graphCharacteristics];
    __weak id this = self;
    selectVC.onComplete = ^(NSArray *selectedItems) {
        [this onCompleSelectCharacteristics:selectedItems];
    };
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:selectVC];
    
    if (IS_IPAD) {
        if (!_popover) {
            _popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
        } else {
            [_popover setContentViewController:navVC animated:_popover.popoverVisible];
        }
        if (!_popover.popoverVisible) {
            [_popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    } else {
        [self presentViewController:navVC
                           animated:YES
                         completion:nil];
    }
}

- (void)refreshFootnotes {
    [UIView animateWithDuration:0.3 animations:^{
        for (FootnoteView *v in _allFootnoters) {
            if (self.smithChartView.hidden) {
                v.center = [self graphPointToViewPoint:v.graphPoint];
            } else {
                v.center = [self.view convertPoint:[self.smithChartView convertComplexToViewPoint:v.complexNumber] fromView:self.smithChartView];;
            }
        }
    }];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self refreshFootnotes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_popover dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    _graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];
    CPTTheme *theme = [[MainTheme alloc] init];
    [_graph applyTheme:theme];
    
    ((CPTXYAxisSet *)_graph.axisSet).xAxis.title = [NSString stringWithFormat:@"Frequency (%@)", _frequencyString];
    ((CPTXYAxisSet *)_graph.axisSet).xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:30.0];
    ((CPTXYAxisSet *)_graph.axisSet).yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:30.0];
    
    self.graphHostingView.hostedGraph = _graph;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Graph", @"Smith chart"]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self action:@selector(onGraphTypeSegmentChange:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self onGraphTypeSegmentChange:segmentedControl];
}

- (void)onGraphTypeSegmentChange:(UISegmentedControl *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.touchedView.alpha = sender.selectedSegmentIndex;
        self.touchedView.backgroundColor = sender.selectedSegmentIndex ? [UIColor whiteColor] : [UIColor clearColor];
        
        for (FootnoteView *v in _allFootnoters) {
            BOOL isHidden = !((sender.selectedSegmentIndex && v.complexNumber) || (!sender.selectedSegmentIndex && !v.complexNumber));
            [UIView animateWithDuration:0.3 animations:^{
                v.alpha = !isHidden;
            } completion:^(BOOL finished) {
                v.hidden = isHidden;
            }];
        }
    } completion:^(BOOL finished) {
        self.smithChartView.hidden = !sender.selectedSegmentIndex;
        self.touchedView.alpha = 1.f;
    }];
    
    [self reload];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    
    UIImage *image = [UIImage imageNamed:@"smith_chart"];
    self.smithChartView.image = image;
    self.smithChartView.dataSource = _dataSource;
    CGRect frame = self.smithChartView.frame;
    frame.size = image.size;
    self.smithChartView.frame = frame;
    self.smithChartView.center = self.view.center;
}

- (void)removeFootnotesForCharacteristic:(BaseCharacteristic *)characteristic {
    NSArray *r = [_allFootnoters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.characteristic == %@", characteristic]];
    for (UIView *v in r) {
        [v removeFromSuperview];
    }
    [_allFootnoters removeObjectsInArray:r];
}

- (void)reload {    
//    for (UIView *v in _allFootnoters) {
//        [v removeFromSuperview];
//    }
//    [_allFootnoters removeAllObjects];

    
    if ([_graphCharacteristics count] > 0) {
        [self.navigationItem setRightBarButtonItems:_rightBarButtonsWithInfo animated:YES];
        self.editing = NO;
    } else {
        self.editing = NO;
        self.navigationItem.rightBarButtonItems = nil;
        [self.navigationItem setRightBarButtonItems:_rightBarButtonsWithoutInfo animated:YES];
    }
    
    NSMutableArray *lastCharacteristics = [[_dataSource.characteristics allValues] mutableCopy];
    
    NSMutableDictionary *characteristics = [NSMutableDictionary new];
    
    for (BaseCharacteristic *characteristic in _graphCharacteristics) {
        Plot *plot = (Plot *)[_graph plotWithIdentifier:characteristic.fullTitle];
        if (!plot) {
            plot = [Plot new];
            plot.identifier = characteristic.fullTitle;
            plot.dataSource = _dataSource;
            [_graph addPlot:plot];
            characteristics[plot] = characteristic;
        }
        
        CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
        lineStyle.lineWidth = characteristic.lineWidth;
        lineStyle.lineColor = [CPTColor colorWithCGColor:characteristic.lineColor.CGColor];
        plot.dataLineStyle = lineStyle;
        
        characteristics[plot] = characteristic;
        [lastCharacteristics removeObject:characteristic];
    }
    
    for (BaseCharacteristic *c in lastCharacteristics) {
        [_graph removePlot:[_graph plotWithIdentifier:c.fullTitle]];
        [self removeFootnotesForCharacteristic:c];
    }
    
//    
//    
//    for (BaseCharacteristic *characteristic in _graphCharacteristics) {
//        Plot *boundLinePlot = [[Plot alloc] init];
//        boundLinePlot.identifier = characteristic.fullTitle;
//
//        CPTMutableLineStyle *lineStyle = [boundLinePlot.dataLineStyle mutableCopy];
//        lineStyle.lineWidth         = characteristic.lineWidth;
//        lineStyle.lineColor         = [CPTColor colorWithCGColor:characteristic.lineColor.CGColor];
//        boundLinePlot.dataLineStyle = lineStyle;
//        
//        boundLinePlot.dataSource = _dataSource;
//        [_graph addPlot:boundLinePlot];
//        
//        characteristics[boundLinePlot] = characteristic;
//    }
    _dataSource.characteristics = [characteristics copy];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = self.editing;
    plotSpace.xRange = [_dataSource xRange];
    plotSpace.yRange = [_dataSource yRange];
    
    [_graph reloadDataIfNeeded];
    
    if (!self.smithChartView.isHidden) {
        [self.smithChartView setNeedsDisplay];
    }
}

@end
