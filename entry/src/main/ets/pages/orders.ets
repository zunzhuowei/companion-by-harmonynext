import OrderList from "../component/orderList"

@Component
export default struct Orders {
  @Prop pageStatus: boolean = true;
  @Prop orderTabIdx: number;
  tabList: Array<string> = ['全部', '待支付', '待服务', '已完成', '已取消']


  build() {
    Column() {
      Text('我的订单').fontWeight(FontWeight.Bold).fontSize(20).padding(5)
      Tabs({index: this.orderTabIdx}) {
        ForEach(this.tabList, (item: string, index: number) => {
          TabContent() {
            //解决页面缓存问题
            if(this.pageStatus){
              OrderList({ orderTypeIdx: index })
            }
          }.tabBar(item)
          .backgroundColor('#f0f0f0')
          .height('100%')
        })
      }
    }
    .height('100%')
    .width('100%')

    //.backgroundColor(Color.Gray)
  }
}