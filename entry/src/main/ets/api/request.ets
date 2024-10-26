import axios, { AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios";
import PreferencesUtils from "../utils/preferences";
import { router } from "@kit.ArkUI";

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

export default async function test<T> (options: options_type): Promise<T> {
  let result: AxiosResponse<request_dataType> = await http(options)
  let res = result.data;
  let code = res.code;
  console.log('服务器返回:' ,JSON.stringify(res))
  if (code === 10000) {
    return res.data as T ;
  }
  if (code === -2 && res.message === 'token错误') {
    router.replaceUrl({
      url: 'pages/LoginPage'
    })
    throw new Error(res.message)
  }
  throw new Error(res.message)
}
