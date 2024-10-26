import HomePage from './HomePage';
import Orders from './orders';
import { router } from '@kit.ArkUI';
import My from './my';

interface params {
  index: number;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State changeFlag: boolean = true;
  @State currentTabIndex: number = 0;
  @State currentOrderTabIndex: number = 0;
  tabController: TabsController = new TabsController()

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
          HomePage()
        }
        .tabBar('首页')

        TabContent() {
          Orders({ pageStatus: this.changeFlag, orderTabIdx: this.currentOrderTabIndex })
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
}