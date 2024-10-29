import axios, { AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios";
import PreferencesUtils from "../utils/preferences";
import { promptAction, router } from "@kit.ArkUI";
import { common, Want } from '@kit.AbilityKit';
import hilog from "@ohos.hilog";
import { BusinessError } from "@kit.BasicServicesKit";

export interface options_type {
  method?: string;
  headers?: object;
  url: string;
  data?: object;
  params?: object;
}

interface request_dataType {
  code: number;
  message?: string;
  data?: object | null;
}

let request = axios.create(
  {
    baseURL: "http://159.75.169.224:3321/v3pz",
    headers: { Terminal: 'h5' }
  }
)
request.interceptors.request.use(async (req: InternalAxiosRequestConfig) => {
  req.headers['h-token'] = await PreferencesUtils.get('token',"");
  return req;
})

function http(options: options_type) {
  let method = options.method ?? 'GET'
  if (method.toLowerCase() === 'get') {
    options.params = options.data
  }
  return request(options)
}

const context = getContext(this) as common.UIAbilityContext;
const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[Page_UIAbilityComponentsInteractive]';

export default async function test<T> (options: options_type): Promise<T> {
  let result: AxiosResponse<request_dataType> = await http(options)
  let res = result.data;
  let code = res.code;
  console.log('服务器返回:' ,JSON.stringify(res))
  if (code === 10000) {
    return res.data as T ;
  }
  if (code === -2 && res.message === 'token错误') {
    // router.replaceUrl({
    //   url: 'pages/LoginPage'
    // })
    toLoginAbility();
    throw new Error(res.message)
  }
  throw new Error(res.message)
}

function toLoginAbility() {
  let wantInfo: Want = {
    deviceId: '', // deviceId为空表示本设备
    bundleName: 'com.example.myhostapp',
    moduleName: 'login', // moduleName非必选
    abilityName: 'LoginAbility',
    parameters: {
      // 自定义信息
      info: '来自EntryAbility Page_UIAbilityComponentsInteractive页面',
      router: 'pages/TestPage'
    },
  };

  //带返回值
  const RESULT_CODE: number = 1001;
  context.startAbilityForResult(wantInfo).then((data) => {
    if (data?.resultCode === RESULT_CODE) {
      // 解析被调用方UIAbility返回的信息
      let token = data.want?.parameters?.token;
      let userInfo = data.want?.parameters?.userInfo;
      hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(token) ?? '');
      hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(userInfo) ?? '');
      if (token !== null) {
        promptAction.showToast({
          message: JSON.stringify(token)
        });
        PreferencesUtils.set('token', token?.toString() as string)
        PreferencesUtils.set('userInfo', userInfo?.toString() as string)
        //onSuccess();
      }
    }
    hilog.info(DOMAIN_NUMBER, TAG, JSON.stringify(data.resultCode) ?? '');
  }).catch((err: BusinessError) => {
    hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability for result. Code is ${err.code}, message is ${err.message}`);
  });
}