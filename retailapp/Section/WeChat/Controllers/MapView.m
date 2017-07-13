//
//  MapView.m
//  retailapp
//
//  Created by 张佳磊 on 15/10/19.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "MapView.h"
#import <CoreLocation/CoreLocation.h>
#import "MyPoint.h"
#import "XHAnimalUtil.h"
#import "NSString+Estimate.h"

@interface MapView ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property(strong, nonatomic)NSString *adress;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,weak) MKMapView *mapView;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) SaveBlock saveBlock;
@property (nonatomic, strong) MyPoint *point;
@end

@implementation MapView

- (void)loadDataWithlatitude:(NSString *)latitude longitude:(NSString *)longitude Address:(NSString *)address saveBlock:(SaveBlock)saveBlock {
    self.latitude = latitude;
    self.longitude = longitude;
    self.adress = address;
    self.saveBlock = saveBlock;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigate];
    [self initMainView];
}

- (void)initNavigate {
    self.titleBox=[NavigateTitle2 navigateTitle:self];
    [self.titleBox initWithName:@"选择位置" backImg:Head_ICON_CANCEL moreImg:Head_ICON_OK];
    [self.titleDiv addSubview:self.titleBox];
}

-(void) onNavigateEvent:(Direct_Flag)event {
    if (event==2){
        self.saveBlock(self.point);
    }
    [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)initMainView {
    self.locationManager = [[CLLocationManager alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
         [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    CGRect rect = CGRectMake(0, 64, 320, 504);
    MKMapView *mapView =[[MKMapView alloc]initWithFrame:rect];
    mapView.mapType=MKMapTypeStandard;
    mapView.delegate=self;
    if ([NSString isNotBlank:self.adress]) {
        [self getCoordinateByAddress:self.adress];
    } else {
         [mapView setShowsUserLocation:YES];
    }
     [self.view addSubview:mapView];
    self.mapView = mapView;
    //在地图中添加一个手势，这个手势是一个点击动作，点击时会调用tapPress这个方法
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(tapPress:)];
    dropPin.minimumPressDuration = 0.1;
    [mapView addGestureRecognizer:dropPin];
}

#pragma mark - MapView委托方法
//当定位自身时调用****用户位置发生改变时触发（第一次定位到用户位置也会触发该方法）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [mapView setShowsUserLocation:NO];
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    [mapView setRegion:MKCoordinateRegionMake(loc, MKCoordinateSpanMake(0.01,0.01)) animated:YES];
    //
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:loc.latitude longitude:loc.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        self.adress = placemark.name;
        self.point = [[MyPoint alloc] initWithCoordinate:loc andTitle:self.adress];
        [mapView removeAnnotations:mapView.annotations];
        [mapView addAnnotation:self.point];
        [mapView selectAnnotation:self.point animated:YES];
    }];
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        CLLocation *location=placemark.location;//位置
        CLLocationCoordinate2D loc=location.coordinate;
        self.adress = placemark.name;
        self.point = [[MyPoint alloc] initWithCoordinate:loc andTitle:self.adress];
        //添加标注
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.point];
        [self.mapView selectAnnotation:self.point animated:YES];
        //放大地图到自身的经纬度位置。
        [self.mapView setRegion:MKCoordinateRegionMake(loc, MKCoordinateSpanMake(0.01,0.01))];
        
    }];
}


//点击地图获取经纬度
- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    //创建标题
    [_mapView setShowsUserLocation:NO];
     CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =[_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
    CLLocation *location=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        self.adress = placemark.name;
         self.point = [[MyPoint alloc] initWithCoordinate:touchMapCoordinate andTitle:self.adress];            //添加标注
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.point];
        [self.mapView selectAnnotation:self.point animated:YES];
         [self.mapView setRegion:MKCoordinateRegionMake(touchMapCoordinate,MKCoordinateSpanMake(0.01,0.01))];
    }];
}

//显示大头针时触发，返回大头针视图，通常自定义大头针可以通过此方法进行
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView * view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    //设置标注的图片
    view.image=[UIImage imageNamed:@"pin.png"];
    //点击显示图详情视图 必须MJPointAnnotation对象设置了标题和副标题
    view.canShowCallout=YES;
    //设置拖拽 可以通过点击不放进行拖拽
    view.draggable=YES;
    return view;
 
}

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //    获取定位的经纬度
    CLLocationCoordinate2D loc=CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView setRegion:MKCoordinateRegionMake(loc, MKCoordinateSpanMake(0.01,0.01))];
    //反地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        self.adress = placemark.name;
        self.point = [[MyPoint alloc] initWithCoordinate:loc andTitle:self.adress];            //添加标注
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.point];
        [self.mapView selectAnnotation:self.point animated:YES];
        [self.mapView setRegion:MKCoordinateRegionMake(loc,MKCoordinateSpanMake(0.01,0.01))];

        
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if ([error code]==kCLErrorDenied) {
        [XHAnimalUtil animal:self.navigationController type:kCATransitionPush direction:kCATransitionFromLeft];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
}




@end
