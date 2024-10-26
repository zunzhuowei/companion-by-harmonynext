import { router } from '@kit.ArkUI';
import { DateUtil } from '@pura/harmony-utils';
import { getDetail, return_detail_type } from '../api/orders';
import BackBtn from '../component/backBtn';
import counter from '../component/counter';
import { CustomQrDialogContent } from '../component/dialogs';
import Schedule from '../component/schedule';

interface params {
  oid: string;
}

@Entry
@Component
struct OrderDetailPage {
  @State oid: string = 'O-WEmaG00134';
  @State order?: return_detail_type = undefined;
  typeArr: Record<string, number> = {
    '待支付': 1,
    '待服务': 2,
    '已完成': 3,
    '已取消': 4
  }
  appointment_form: Record<string, string> = {
    'service_name': '预约服务',
    'hospital_name': '就诊医院',
    'starttime': '期望预约时间',
    'client.name': '就诊人',
    'client.mobile': '就诊人电话',
    'receiveAddress': '接送地址',
    'demand': '其他需求',
  }
  order_from: Record<string, string> = {
    'client.mobile': '联系电话',
    'order_start_time': '下单时间',
    'price': '应付金额',
    'out_trade_no': '订单编号',
    'other': '联系客服',
  }

  aboutToAppear(): void {
    if (router.getParams()) {
      let p: params = router.getParams() as params
      this.oid = p.oid
      this.getOrderDetail(this.oid)
    } else {
      this.getOrderDetail(this.oid)
    }
  }

  async getOrderDetail(id: string) {
    this.order = await getDetail({ oid: id })
  }

  getTypeIndex(type: string): number {
    return this.typeArr[type]
  }

  getValue(key: string): string {
    let strArr = key.split('.')
    if (key === 'order_start_time') {
      return DateUtil.getFormatDateStr(this.order?.order_start_time as number, 'yyyy-MM-dd')
    }
    if (key === 'other') {
      return '疑问或投诉 >'
    }
    if (strArr.length > 1) {
      let result: object | string = this.order as return_detail_type;
      for (const element of strArr) {
        result = Reflect.get(result as object, element)
      }
      return result as string;
    }
    return Reflect.get(this.order as return_detail_type, key)
  }

  @Builder
  orderCardBuilder(title: string, record: Record<string, string>) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .border({ width: { left: 5 } })
        .padding({ left: 5 })
        .borderColor(Color.Red)
        .width('100%')
      List() {
        ForEach(Object.keys(record), (item: string, index) => {
          ListItem() {
            Row() {
              Text(record[item]).fontSize(15).fontWeight(FontWeight.Bold)
              Text(this.getValue(item)).fontSize(13).fontColor(Color.Gray)
            }
            .padding(10)
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .border({ width: { top: index === 0 ? 0 : 1 } })
            .borderColor('#ff7c7474')
          }
        })
      }
    }
    .padding(10)
    .backgroundColor(Color.White)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart}){
      Scroll() {
        Column() {
          // 标题
          Text('订单详情')
            .padding(5)
            .border({ width: { top: 1 }, color: Color.Gray })
            .width('100%')
            .textAlign(TextAlign.Center)
            .borderStyle(BorderStyle.Dotted)
          // 服务进度
          Schedule({ typeIndex: this.getTypeIndex(this.order?.trade_state || '已取消') })

          if (this.order) {
            Column() {
              // 订单状态
              this.orderStatusBuilder(this.order)
              //预约信息
              Column() {
                this.orderCardBuilder('预约信息', this.appointment_form)
              }
              .margin({ bottom: 10 })

              this.orderCardBuilder('订单信息', this.order_from)
            }.backgroundColor('#f0f0f0')
            .height('100%')
          }
        }
      }
      .height('100%')
      .width('100%')
      .scrollBar(BarState.Off)

      // 返回按钮
      BackBtn()
    }
  }

  @Builder
  orderStatusBuilder(order?: return_detail_type) {
    if (order?.trade_state === '待支付') {
      Column() {
        Column() {
          Text(this.getOrderStatusInfo(order?.trade_state)[0])
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Gray)
            .margin({ bottom: 5 })
          Row() {
            Text(this.getOrderStatusInfo(order?.trade_state)[1]).fontSize(13).fontColor(Color.Gray)
            //倒计时
            counter({ allSeconds: order?.order_start_time + 7200000 - Date.now()})
            Text(this.getOrderStatusInfo(order?.trade_state)[2]).fontSize(13).fontColor(Color.Gray)
          }

          Row() {
            Button(`立即支付${order.price}元`, { type: ButtonType.Normal, stateEffect: true })
              .backgroundColor(Color.Green)
              .borderRadius(10)
              .onClick(() => this.payOrder(order.code_url))
          }.width('100%').justifyContent(FlexAlign.Center).padding(10)
        }.width('100%').alignItems(HorizontalAlign.Start)
      }
      .padding(10)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .margin({ bottom: 5 })
    } else {
      Column() {
        Text(this.getOrderStatusInfo(order?.trade_state)[0])
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Gray)
          .margin({ bottom: 5 })
        Text(this.getOrderStatusInfo(order?.trade_state)[1]).fontSize(13).fontColor(Color.Gray)
      }
      .padding(10)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .margin({ bottom: 5 })
    }
  }

  getOrderStatusInfo(state: string): string[] {
    if (state === '已取消') {
      return ['订单已取消', '期待下次为您服务，如需帮助可咨询客服']
    }
    if (state === '待服务') {
      return ['正在为您安排服务专员...', '请保持手机畅通，稍后将有服务专员与您联系']
    }
    if (state === '已完成') {
      return ['服务已完成', '感谢您的使用，如有售后问题请联系客服']
    }
    return ['订单待支付', '请在', '内完成支付，超时订单自动取消']
  }

  payOrder(wxCode: string){
    let controller: CustomDialogController = new CustomDialogController({
      builder: CustomQrDialogContent({
        qrData: wxCode,
        cancel: () => {
          controller.close();
          this.getOrderDetail(this.oid)
        }
      }),
      offset: { dx: 0, dy: 200 }
    });
    controller.open()
  }

}