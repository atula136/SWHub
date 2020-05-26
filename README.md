<p align="center">
  GitHub iOS client in RxSwift and ReactorKit architecture.
</p>

## Screenshots

<img alt="home" src="https://github.com/tospery/SWHub/blob/master/screenshots/home.jpeg?raw=true" width="280">&nbsp;
<img alt="setting" src="https://github.com/tospery/SWHub/blob/master/screenshots/setting.jpeg?raw=true" width="280">&nbsp;

## Concept
* **一、框架**: 采用RxSwift和ReactorKit的响应式单向流框架，详情参见：https://github.com/ReactorKit/ReactorKit
* **二、存储**: 采用UserDefaults和Realm数据库方案：1、部分全局数据（与用户无关），如App主题等，使用UserDefaults。2、用户数据使用Realm，以便切换用户后，能还原用户的状态
* **三、第三方框架**: 1、RxSwift：响应式框架 2、ReactorKit：单向流框架 3、RealmSwift：Realm数据库

## Coffee
<img alt="02_repository_details_screen" src="https://github.com/tospery/SWHub/blob/master/screenshots/coffee.jpeg?raw=true" width="300">&nbsp;