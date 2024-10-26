import { addOrder, companion, companion_hospital, getCompanion, return_companion_type } from '../api/createOrder';
import Schedule from '../component/schedule';
import { JSON } from '@kit.ArkTS';
import { DateUtil, DialogUtil } from '@pura/harmony-utils';
import { CustomDateDialogContent, CustomDialogContent, CustomQrDialogContent } from '../component/dialogs';
import { router } from '@kit.ArkUI';
import BackBtn from '../component/backBtn';

@Entry
@Component
 struct CreateOrderPage {
  @State orderData: return_companion_type | undefined = undefined;
  @State @Watch('changeForm') form_list: form_list_type = {
    hospital_name: '请选择医院',
    starttime: undefined,
    companion_name: '请选择陪诊师',
    receiveAddress: '请填写就诊人地址',
    tel: '请填写您的联系电话',
    demand: '请简单描述你要就诊的科室',
    hospital_id: undefined,
    companion_id: undefined,
    time: '请选择就诊时间'
  }
  @State ruleTip : boolean = false;


  list: obj_list = {
    hospital_name: '就诊医院',
    time: '就诊时间',
    companion_name: '陪诊师',
    receiveAddress: '接送地址',
    tel: '联系电话'
  }

  aboutToAppear(): void {
    getCompanion().then((res) => {
      this.orderData = res;
      if (router.getParams()) {
       let p =  router.getParams() as params;
       if(p.id){
         let hospital = this.orderData.hospitals.find((item) => item.id === p.id)
         this.form_list.hospital_name = hospital?.name || '';
         this.form_list.hospital_id = hospital?.id
       }
      }
    })
  }

  changeForm(){
    this.ruleTip = false;
  }

  openDialog(contentType: string): void {
    console.log('1111', contentType)
    //选择时间
    if('time' === contentType){
      let controller: CustomDialogController = new CustomDialogController({
        builder: CustomDateDialogContent({
          orderData: this.orderData,
          selected: this.form_list.starttime == undefined ? undefined: new Date(this.form_list.starttime!),
          confirm: (obj: Date) => {
            console.log('1111', JSON.stringify(obj))
            Reflect.set(this.form_list, 'starttime', obj.getTime())
            Reflect.set(this.form_list, 'time', DateUtil.getFormatDateStr(obj, 'yyyy-MM-dd'))
            controller.close();
          },
          cancel: () => {
            controller.close();
          }
        }),
        offset: { dx: 0, dy: 200 }
      });
      controller.open()
      return;
    }
    // 选择医院、陪诊师
    let controller: CustomDialogController = new CustomDialogController({
      builder: CustomDialogContent({
        contentType: contentType,
        orderData: this.orderData,
        selectedIdx: 'hospital_name' === contentType ?
        this.orderData?.hospitals.findIndex((item) => item.id === this.form_list.hospital_id) :
        this.orderData?.companion.findIndex((item) => item.id === this.form_list.companion_id),
        confirm: (obj: companion | companion_hospital | undefined) => {
          console.log('1111', JSON.stringify(obj))
          if('hospital_name' === contentType){
            Reflect.set(this.form_list, 'hospital_name', obj?.name)
            Reflect.set(this.form_list, 'hospital_id', obj?.id)
          } else if('companion_name' === contentType){
            Reflect.set(this.form_list, 'companion_name', obj?.name)
            Reflect.set(this.form_list, 'companion_id', obj?.id)
          }
          controller.close();
        },
        cancel: () => {
          controller.close();
        }
      }),
      offset: { dx: 0, dy: 200 }
    });
    controller.open()
  }

  build() {
    Stack({ alignContent: Alignment.TopStart}){
      Column() {
        // 服务进度
        Schedule({ typeIndex: 0 })

        // 服务内容
        Row() {
          Row({ space: 10 }) {
            Image(this.orderData?.service.serviceImg).width(25)
            Text(this.orderData?.service.serviceName)
          }

          Text('服务内容>').fontSize(15).fontColor('#969799')
        }
        .margin(5)
        .padding(15)
        .backgroundColor(Color.White)
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 服务列表
        ForEach(Object.keys(this.list), (item: string, index) => {
          Row({ space: 10 }) {
            Text(Reflect.get(this.list, item))
            if (item === 'tel' || item === 'receiveAddress') {
              TextInput({ placeholder: `${Reflect.get(this.form_list, item)}>` })
                .backgroundColor(Color.White)
                .padding(0)
                .borderRadius(0)
                .width('50%')
                .fontSize(13)
                .textAlign(TextAlign.End)
                .onChange((value) => {
                  Reflect.set(this.form_list, item, value)
                  console.log('888', JSON.stringify(this.form_list))
                })
                .type(item === 'tel' ? InputType.PhoneNumber : InputType.Normal)
            } else {
              Text(`${Reflect.get(this.form_list, item)}>`).fontColor('#969799')
                .onClick(() => this.openDialog(item))
            }
          }
          .margin(index == 0 ? 5 : 0)
          .backgroundColor(Color.White)
          .padding({left:15,right:15,top:10,bottom:10})
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        })

        // 服务需求标题
        Row() {
          Text('服务需求').fontColor(Color.Gray)
        }
        .padding(10)
        .justifyContent(FlexAlign.Start)
        .width('100%')

        // 服务需求表单
        Row() {
          TextArea({ placeholder: '请简单描述你要就诊的科室' })
            .height('100%')
            .backgroundColor(Color.White)
            .borderRadius(0)
            .fontSize(15)
            .onChange((value) => {
              Reflect.set(this.form_list, 'demand', value)
              console.log('888', JSON.stringify(this.form_list))
            })

        }
        .padding(5)
        .margin(5)
        .width('100%')
        .height(100)

        if (this.ruleTip){
          Text('请确认医院、就诊时间、陪诊师都选择了！！！')
            .fontColor(Color.Red)
            .fontSize(12)
            .margin({ top: 5 })
            .textAlign(TextAlign.Start)
            .width('100%')
            .padding({left:15})
        }

        // 提交按钮
        Row() {
          Button('提交订单', { type: ButtonType.Normal })
            .borderRadius(5)
            .width('100%')
            .margin({ top: 10 })
            .onClick(() => this.submitOrder(this.form_list))
        }
        .width('90%')

      }
      .backgroundColor('#f0f0f0').height('100%')

      // 返回按钮
      BackBtn()
    }
  }


  submitOrder(form_list: form_list_type){
    let itemArr:string[] = ['hospital_id', 'companion_id','starttime', 'hospital_name','demand','receiveAddress','tel']
    for (const element of itemArr) {
      if (!Reflect.get(form_list,element)) {
        this.ruleTip = true;
        DialogUtil.showDialog({
          title: '提示',
          message: '请确认医院、就诊时间、陪诊师都选择了！！！' + element,
          backgroundColor: Color.White,
        });
        return;
      }
    }
    addOrder({
      hospital_id: Reflect.get(form_list,'hospital_id') as number,
      companion_id: Reflect.get(form_list,'companion_id') as number,
      starttime: Reflect.get(form_list,'starttime') as number,
      demand: Reflect.get(form_list,'demand'),
      receiveAddress: Reflect.get(form_list,'receiveAddress'),
      tel: Reflect.get(form_list,'tel'),
      hospital_name: Reflect.get(form_list,'hospital_name'),
    })
    .then((value) => {
      let controller: CustomDialogController = new CustomDialogController({
        builder: CustomQrDialogContent({
            qrData: value.wx_code,
            cancel: () => {
              controller.close();
              router.back({
                url: 'pages/Index',
                params: {
                  index: 1,
                }
              })
            }
        }),
        offset: { dx: 0, dy: 200 }
      });
      controller.open()
    })
  }

}

interface params{
  id: number;
}

interface obj_list {
  hospital_name: string;
  time: string;
  companion_name: string;
  receiveAddress: string;
  tel: string;
}

interface form_list_type {
  hospital_name: string;
  starttime: number | undefined;
  companion_name: string;
  receiveAddress: string;
  tel: string;
  demand: string;
  hospital_id: number | undefined;
  companion_id: number | undefined;
  time: string;
}
