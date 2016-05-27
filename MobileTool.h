//
//  MobileTool.h
//  iMobileSecondaryBuy
//
//  Created by 张金海 on 14-10-22.
//  Copyright (c) 2014年 damai. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <math.h>
//配置提示语文字
#define PasswordMin 6
#define PasswordMax 16
FOUNDATION_EXPORT NSString * const t_PhoneNULL;
FOUNDATION_EXPORT NSString * const t_PhoneError;
FOUNDATION_EXPORT NSString * const t_VcodeNULL;
FOUNDATION_EXPORT NSString * const t_NickNULL;
FOUNDATION_EXPORT NSString * const t_PasswordNULL;
FOUNDATION_EXPORT NSString * const t_PasswordError;
FOUNDATION_EXPORT NSString * const t_PasswordDifferent;
FOUNDATION_EXPORT NSString * const t_PasswordRegex;
@interface MobileTool : NSObject
+ (NSString*)stringWithNewUUID;
+ (NSString *)md5:(NSString *)str;
+ (NSString*)getDocumentPath;
+ (NSString *) getStringFromDateTime:(NSString *)date  andDataFormat:(NSString *)dateFormat;
+ (CGFloat)calculateHeight:(CGFloat)width text:(NSString*)str font:(UIFont*)font;
+ (BOOL) connectedToNetwork;
//+ (NSData*) gzipData: (NSData*)pUncompressedData;
//+ (NSData *)ungzipData:(NSData *)compressedData;
+ (NSString *)getScreen;
+ (NSData *)defaultImageData;
+ (void)showAlert:(NSString *)message;
+ (NSString *)getCityId:(NSString *)name;
+(BOOL)isMoney:(NSString *)string;
+(BOOL)isPhone:(NSString *)str;
+(BOOL)isStringAndNumber:(NSString *)str;
+(BOOL)isChineseAndStringAndNumber:(NSString *)str;
+(BOOL)isUserName:(NSString *)str;
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;
+(NSString *)distanceStrWithDistance:(double)distance;
+(NSString *)getTitle:(NSString *)second_category;
+(void)getCity:(NSMutableArray *)arr;
+(NSMutableArray *)getProvinceArr;
#pragma mark -- 通过省查询相应的省id
+ (NSString *) getProvinceId:(NSString *)provinceName;
//根据省ID查询市
+(NSMutableArray *)getCityArr:(NSString *)provinceId;
+(NSString *)getCitySecondId:(NSString *)name;
+(NSString *)getNameById:(NSString *)ID;
+(NSString *)getTime :(NSString *)endTimeStr startTimeStr:(NSString *)startTimeStr;
//+ (NSString *)changeNSNull:(id)str;
+(NSString *)changeNSNull:(NSString *)str;
//获取订单状态
+ (NSString *)stringWithOrderStatus:(NSString *)order_status;

+(NSInteger)getPayType:(NSInteger)payType;
//身份证校验
+(BOOL)isIdentityCard:(NSString *)str;
//银行卡校验
+(BOOL)isBankCard:(NSString *)str;
////百度坐标转换成其他坐标
//+(CLLocationCoordinate2D)bd_encrypt:(double)gg_lat lon:(double)gg_lon bdLat:(double)bd_lat bdLon:(double)bd_lon;
//
//
////转换成百度坐标算法
//+(CLLocationCoordinate2D)getbaiduWithlat:(double)lat withLog:(double)log;
+ (NSString *)getMessageInfoStatus:(int)status;
+(void)SaveSysConfig;

//分享时随机返回一段文字用于显示
+ (NSString *)getRandomShareText;
//初始化 富文本类
+ (void)initEMStringWithdefaultFont:(CGFloat)defaultFont strongFont:(CGFloat)strongFont defaultTextColor:(NSString *)defaultTextColor strongTextColor:(NSString *)strongTextColor;
+(BOOL)stringisNULL:(NSString *)str;
//字典转字符串
+(NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;
//字符串转字典
+(NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;
#pragma mark -- 获取相机的权限
+(BOOL)getTheCameraPermissions;
#pragma mark -- 根据时间戳获取星期几
+(NSString *)getWeekDayFordateString:(NSString *)dataString;
#pragma mark -- 根据时间戳获取2016.06.25 星期六19:30的格式
+(NSString *)getDateAndWeekAndTimeForDateString:(NSString *)dataString;
#pragma mark -- 与现在对比相隔时间
+ (int)intervalSinceNow:(NSString *)theDate;
#pragma mark -- 把手机号换4位*显示
+(NSString *)changeEncryptionMobile:(NSString *)mobile;
+(CGSize)sizeOfTextContent:(NSString *)textContent text_w:(CGFloat)text_w text_h:(CGFloat)text_h text_font:(NSInteger)text_font;
@end
