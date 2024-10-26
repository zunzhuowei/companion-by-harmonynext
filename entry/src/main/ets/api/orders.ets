import request from "./request";

export interface return_order_type {
  serviceImg: string;
  service_name: string;
  hospital_name: string;
  starttime: string;
  trade_state:string;
  order_start_time: number;
  out_trade_no: string;
}

interface order_type{
  state:number
}

export function getOrderList(data:order_type){
  return request<Array<return_order_type>>({
    url:'/order/list',
    method:'get',
    data
  })
}

interface detail_type{
  oid:string
}

interface client {
  name:string
  mobile:string
}
export interface return_detail_type{
  service_name:string
  hospital_name:string
  starttime:string
  client:client
  receiveAddress:string
  demand:string
  order_start_time:number
  price:string
  out_trade_no:string
  trade_state:string
  code_url:string
}
export function getDetail(data:detail_type){
  return request<return_detail_type>({
    url:'/order/detail',
    method:'get',
    data
  })
}