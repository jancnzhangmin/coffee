WxPay.appid = 'wx44ae3920658b6382'
WxPay.key = '35b85b57e6f245348581806369c828b3'
WxPay.mch_id = '1602265071'
WxPay.debug_mode = true # default is `true`
#WxPay.sandbox_mode = true
WxPay.appsecret = '002df0c1e07f357e5891b2b2b231ee03'
#WxPay.set_apiclient_by_pkcs12(File.read('/mnt/d/cert/yjmh/apiclient_cert.p12'), '1494143422')
#WxPay.set_apiclient_by_pkcs12(File.read('/home/cert/yjmh/apiclient_cert.p12'), '1494143422')
WxPay.extra_rest_client_options = {timeout: 20, open_timeout: 30}