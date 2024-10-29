import HomePage from './HomePage';
import Orders from './orders';
import { promptAction, router } from '@kit.ArkUI';
import My from './my';
import { common, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import { BusinessError } from '@kit.BasicServicesKit';

interface params {
  index: number;
}
const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_UIAbilityComponentsInteractive]';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State changeFlag: boolean = true;
  @State currentTabIndex: number = 0;
  @State currentOrderTabIndex: number = 0;
  tabController: TabsController = new TabsController()
  private context = getContext(this) as common.UIAbilityContext;

  onPageShow(): void {
    if (router.getParams()) {
      let index = (router.getParams() as params).index;
      this.tabController.changeIndex(index)
    }
    this.changeFlag = true;
  }

  onPageHide(): void {
    this.changeFlag = false;
  }

  changeTabIndex(indexTabIdx: number, orderTabIdx?: number): void {
    this.currentTabIndex = indexTabIdx
    this.currentOrderTabIndex = orderTabIdx ?? 0
    this.tabController.changeIndex(this.currentTabIndex)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabController, index: this.currentTabIndex }) {
        TabContent() {
          if(this.changeFlag){
            HomePage()
          } else {
            Text('loading ...')
          }
        }
        .tabBar('首页')

        TabContent() {
          Orders({ pageStatus: this.changeFlag, orderTabIdx: this.currentOrderTabIndex })
            .onClick(() => this.toOrderAbility())
        }
        .tabBar('订单')

        TabContent() {
          My({
            changeTabIndex: (indexTabIdx: number, orderTabIdx?: number) => this.changeTabIndex(indexTabIdx, orderTabIdx)
          })
        }
        .tabBar('我的')
      }
    }
    .height('100%')
    .width('100%')
  }

  toOrderAbility() {
    // context为Ability对象的成员，在非Ability对象内部调用需要
    // 将Context对象传递过去
    let wantInfo: Want = {
      deviceId: '', // deviceId为空表示本设备
      bundleName: 'com.example.myhostapp',
      moduleName: 'orders', // moduleName非必选
      abilityName: 'OrdersAbility',
      parameters: {
        // 自定义信息
        info: '来自EntryAbility Page_UIAbilityComponentsInteractive页面',
        router: 'pages/TestPage'
      },
    };

    // context为调用方UIAbility的UIAbilityContext
    // this.context.startAbility(wantInfo).then(() => {
    //   hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
    // }).catch((error: BusinessError) => {
    //   hilog.error(DOMAIN_NUMBER, TAG, 'startAbility failed.');
    // });

    //带返回值
    const RESULT_CODE: number = 1001;
    this.context.startAbilityForResult(wantInfo).then((data) => {
      if (data?.resultCode === RESULT_CODE) {
        // 解析被调用方UIAbility返回的信息
        let info = data.want?.parameters?.info;
        hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(info) ?? '');
        if (info !== null) {
          promptAction.showToast({
            message: JSON.stringify(info)
          });
        }
      }
      hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(data.resultCode) ?? '');
    }).catch((err: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability for result. Code is ${err.code}, message is ${err.message}`);
    });
  }

  // 隐式调用
  toOrderAbility2(){
    let wantInfo: Want = {
      action: 'ohos.want.action.home',
      entities: ['entity.system.home'],
      uri: 'https://www.baidu.com',
    };

    this.context.startAbility(wantInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, 'startAbility failed.');
    });
  }

}