//
//  ViewController.m
//  WeatherReport
//
//  Created by MAEDA HAJIME on 2014/04/10.
//  Copyright (c) 2014年 HAJIME MAEDA. All rights reserved.
//
//  XML参照先 http://www.drk7.jp/weather/xml/27.xml を解析表示する。
//  要素値のelementName（要素）がキーポイントでこれを使って判定していくことが重要である。
//  要素の解析開始後/要素の解析終了後/要素値の発見時

/*
 <weatherforecast>
 <info date="2014/04/10">　// info
 <weather>晴れ</weather>   // weather
 <img>http://www.drk7.jp/MT/images/MTWeather/100.gif</img>   // img
 </info>
 </weatherforecast>
*/

#import "ViewController.h"

@interface ViewController () <NSXMLParserDelegate> {
    
    // XMLパーサー オブジェクト
    NSXMLParser *_prs; // 解析するもの
    
    // 解析中の要素名
    NSMutableString *_nowElm;
    
    // 日付インデックス
    int _idxDay;
    
    // ラベルTemp
    NSString *vwText;
    
    // ラベルTemp
    NSString *vwText2;
}

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ivWether;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbWether;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 準備処理
    [self doReady];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 準備処理
- (void)doReady {
    
    // 日付インデックス
    _idxDay = 0;
    
    // 対象ファイルの読込
//    NSBundle *bnd = [NSBundle mainBundle];
//    NSString *pth = [bnd pathForResource:@"test"
//                                  ofType:@"xml"];
    
    NSString *pth = @"http://www.drk7.jp/weather/xml/27.xml";
    NSURL *url = [NSURL URLWithString:pth];
    
    // XMLパーサー生成
    _prs = [[NSXMLParser alloc] initWithContentsOfURL:url ];
    
    // 設定（デリゲート）
    _prs.delegate = self;
    
    // 解析開始
    [_prs parse];
    
}

#pragma mark - NSXMLParserDelegate Method

// 要素の解析開始後（上から読んでいる）
// elementName:要素
// attributeDict:属性
- (void)     parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
       namespaceURI:(NSString *)namespaceURI
      qualifiedName:(NSString *)qName
         attributes:(NSDictionary *)attributeDict {
    
    // スタート
    //NSLog(@"start：%@", elementName);
    
    // 解析中の「_nowElm = elementName:要素名」の保持
    _nowElm = [NSMutableString stringWithString:elementName];
    
    // 解析中の「elementName:要素名」要素名の判定
    if ([_nowElm isEqualToString:@"info"]) {
        
        // 天気ラベル → vwラベルの生成と移行　[_idxDay]日付インデックス
        UILabel *vw = (UILabel *)self.lbWether[_idxDay];
        
        // vwラベルに日付を代入
        vw.text = attributeDict[@"date"];
    }
}

// 要素の解析終了後（上から読んでいる）
- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
    
    // エンド
    //NSLog(@"end：%@", elementName);
    
    // 解析中の要素名の判定
    if ([elementName isEqualToString:@"info"]) {
        
        // 日付インデックス インクリメント
        _idxDay++;

    }
    
    // 解析中の要素名の保持解除
    _nowElm = [NSMutableString string];
    
}

// 要素値の発見時
- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    
    // 解析中の「_nowElm = elementName:要素名」要素名の判定
    if ([_nowElm isEqualToString:@"img"]) {
        
        NSURL *url = [NSURL URLWithString:string];
        // XML内のURL
        NSData *dat = [NSData dataWithContentsOfURL:url];
        // 画像データ取得
        UIImage *img = [UIImage imageWithData:dat];
        
        UIImageView *vw = (UIImageView *) self.ivWether[_idxDay];
        
        // 画像データ表示
        vw.image =img;
        
    } else if ([_nowElm isEqualToString:@"weather"]) {
        
        // 天気 → vwラベルの生成と移行　[_idxDay]日付インデックス
        UILabel *vw = (UILabel *)self.lbWether[_idxDay];
        
        vw.text = [vw.text stringByAppendingFormat:@"\n%@",string];

    }
}

@end
