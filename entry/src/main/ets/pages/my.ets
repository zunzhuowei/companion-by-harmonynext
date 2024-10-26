import { DialogUtil } from "@pura/harmony-utils";
import { userInfo } from "../api/login"
import { router } from "@kit.ArkUI";
import PreferencesUtils from "../utils/preferences";

@Component
export default struct My {
  changeTabIndex: (indexTabIdx: number, orderTabIdx?: number) => void = () => {
  };
  @State userInfo: userInfo | undefined = {
    avatar: 'http://159.75.169.224:5500/avatar.jpeg',
    name: '小明',
  }

  async aboutToAppear() {
    this.userInfo = JSON.parse(await PreferencesUtils.get('userInfo', '') as string)
  }

  @Styles
  cardStyle(){
    .backgroundColor(Color.White)
    .borderRadius(10)
    .padding(5)
  }

  build() {
    Column() {
      //身份卡片
      Column() {
        Image(this.userInfo?.avatar).width(100)
        Text(this.userInfo?.name)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(10)
      .padding(30)

      // 分割线
      Column().width('100%').height(10)

      //我的订单
      Column() {
        Row() {
          Text('我的订单').fontWeight(FontWeight.Bold)
          Text('全部').fontColor(Color.Gray)
            .onClick(() => this.changeTabIndex(1, 0))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(10)
        .width('100%')
        .border({ width: { bottom: 1, }, color: '#ffebedf0' })

        Row() {
          this.orderIconBuilder(new OrderIcon($r('app.media.startIcon'), '待支付', 0))
          this.orderIconBuilder(new OrderIcon($r('app.media.startIcon'), '待服务', 1))
          this.orderIconBuilder(new OrderIcon($r('app.media.startIcon'), '已完成', 2))
          this.orderIconBuilder(new OrderIcon($r('app.media.startIcon'), '已取消', 3))
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding({ left: 20, right: 20 })
        .margin({ top: 20, bottom: 20 })
      }
      .width('100%')
      .cardStyle()

      // 分割线
      Column().width('100%').height(10)
      //服务管理对象
      //分享转发
      Column() {
        this.listItemBuilder(new ListItem(1, '服务对象管理'))
        this.listItemBuilder(new ListItem(2, '分享转发'))
      }
      .width('100%')
      .cardStyle()

      //退出登录按钮
      Button('退出登录')
        .width('80%')
        .height(40)
        .margin({ top: 30 })
        .type(ButtonType.Normal)
        .borderRadius(10)
        .backgroundColor(Color.Red)
        .onClick(async () => {
          await PreferencesUtils.delete('token')
          await PreferencesUtils.delete('userInfo')
          DialogUtil.showDialog({
            title: '退出登录',
            message: '您确定要退出登录吗？',
            backgroundColor: '#ffffff',
            onAction: (index:number) => {
              if(index == -2){
                router.replaceUrl({
                  url: 'pages/LoginPage'
                })
              }
            }
          })
        })

    }
    .backgroundColor('#f0f0f0')
    .padding(10)
    .height('100%')
    .width('100%')
  }

  @Builder
  orderIconBuilder(orderIcon: OrderIcon) {
    Column() {
      Image(orderIcon.icon).height(40).width(40).margin({ bottom: 5 })
      Text(orderIcon.text).fontColor('#999').fontSize(13)
    }
    .onClick(() => {
      let type = orderIcon.type
      if (type == 0) {
        this.changeTabIndex(1, 1)
      }
      if (type == 1) {
        this.changeTabIndex(1, 2)
      }
      if (type == 2) {
        this.changeTabIndex(1, 3)
      }
      if (type == 3) {
        this.changeTabIndex(1, 4)
      }
    })
  }

  @Builder
  listItemBuilder(item: ListItem) {
    Row() {
      Text(item.name)
      Text('>')
    }
    .width('100%')
    .padding(10)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

class OrderIcon {
  icon: Resource;
  text: string;
  type: number;

  constructor(icon: Resource, text: string, type: number) {
    this.icon = icon;
    this.text = text;
    this.type = type;
  }
}

class ListItem {
  type: number;
  name: string;

  constructor(type: number, name: string) {
    this.type = type;
    this.name = name;
  }
}