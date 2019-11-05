# Python 爬虫 - Scrapy

- git : https://github.com/scrapy/scrapy
- docs : http://docs.scrapy.org/en/latest/index.html

## 基础

- 基础教程：http://docs.scrapy.org/en/latest/intro/tutorial.html

- 使用 `LinkExtractor` 来提取 response 中的链接，以实现递归爬取整个网站，可以通过配置一系列规则来限制爬取的范围

  - http://docs.scrapy.org/en/latest/topics/link-extractors.html
  - https://www.jianshu.com/p/3346983e3419

  ```python
  from scrapy.linkextractors import linkExtractor
  
  class exampleSpider(scrapy.Spider):
      name = 'example'
      start_urls = ['https://www.example.com/']
  
      def parse(self, response):
          link_extractor = LinkExtractor()
          links=link_extractor.extract_links(response)
          
          for link in links:
              print(link.url,link.text)
              yield scrapy.Request(url=link.url, callback=self.parse)
  ```

## 进阶

- 使用 splash 来爬取带有 javascript 渲染的页面
  - 文档介绍：http://docs.scrapy.org/en/latest/topics/dynamic-content.html
  - scrapy-splash：https://github.com/scrapy-plugins/scrapy-splash
  - splash 项目：https://github.com/scrapinghub/splash

- 修改 user-agent 来避免被反爬虫

  - 使用 fake-useragent

  ```python
  > pip install fake-useragent
  
  _______
  
  >>> from fake_useragent import UserAgent
  >>> ua = UserAgent(use_cache_server=False) # 参数为禁止缓存，不加会卡一会，网络有问题会报错
  >>> ua.chrome
  'Mozilla/5.0 (Windows NT 6.4; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2225.0 Safari/537.36'
  >>> ua.ie
  'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)'
  >>> ua.random
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17'
  >>> ua.random
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1664.3 Safari/537.36'
  >>> ua.random
  'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0.6'
  ```

  

  - 或使用常用 user-agent

  ```python
  import random
  
  user_agent = [
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
      "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-us) AppleWebKit/534.50 (KHTML, like Gecko) Version/5.1 Safari/534.50",
      "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0",
      "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 3.0.30729; .NET CLR 3.5.30729; InfoPath.3; rv:11.0) like Gecko",
      "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
      "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)",
      "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
      "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
      "Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; en) Presto/2.8.131 Version/11.11",
      "Opera/9.80 (Windows NT 6.1; U; en) Presto/2.8.131 Version/11.11",
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Maxthon 2.0)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; TencentTraveler 4.0)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; The World)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; SE 2.X MetaSr 1.0; SE 2.X MetaSr 1.0; .NET CLR 2.0.50727; SE 2.X MetaSr 1.0)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; 360SE)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Avant Browser)",
      "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
      "Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
      "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
      "Mozilla/5.0 (iPad; U; CPU OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5",
      "Mozilla/5.0 (Linux; U; Android 2.3.7; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
      "MQQBrowser/26 Mozilla/5.0 (Linux; U; Android 2.3.7; zh-cn; MB200 Build/GRJ22; CyanogenMod-7) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
      "Opera/9.80 (Android 2.3.4; Linux; Opera Mobi/build-1107180945; U; en-GB) Presto/2.8.149 Version/11.10",
      "Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13",
      "Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; en) AppleWebKit/534.1+ (KHTML, like Gecko) Version/6.0.0.337 Mobile Safari/534.1+",
      "Mozilla/5.0 (hp-tablet; Linux; hpwOS/3.0.0; U; en-US) AppleWebKit/534.6 (KHTML, like Gecko) wOSBrowser/233.70 Safari/534.6 TouchPad/1.0",
      "Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaN97-1/20.0.019; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebKit/525 (KHTML, like Gecko) BrowserNG/7.1.18124",
      "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; HTC; Titan)",
      "UCWEB7.0.2.37/28/999",
      "NOKIA5700/ UCWEB7.0.2.37/28/999",
      "Openwave/ UCWEB7.0.2.37/28/999",
      "Mozilla/4.0 (compatible; MSIE 6.0; ) Opera/UCWEB7.0.2.37/28/999",
      # iPhone 6：
  	"Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25",
  
  ]
  
  headers = {'User-Agent': random.choice(user_agent)}
  
  
  # 随机获取一个请求头
  def get_user_agent():
      return random.choice(USER_AGENTS)
  
  # 进行请求时加入headers
  yield scrapy.Request(url=url, headers={'User-Agent':get_user_agent()}, callback=self.parse)
  ```

- 使用代理进行爬取
  - Linux 下使用 shadowsocks-libev 挂上 socks5 代理，见`./shadowsocks.md`
  - 由于 scrapy 不支持 socks5 代理，需要将 socks5 转发到 http，使用 privoxy:
    - 官网： https://www.privoxy.org/
    - 教程： http://einverne.github.io/post/2018/03/privoxy-forward-socks-to-http.html
  - **与 scrapy-splash 一起使用**
    - 在SplashRequest里写 `args={'proxy': http:ip:port}`
    - splash的docker需要使用参数 `--network=host` 或者在以上的ip中使用docker内可以访问的地址，原因是在 SplashRequest 中使用代理的情况下，请求是先发送给 splash 的docker 内的，而使用常用的 `127.0.0.1` 在docker无法正常访问
    - splash的容器会随着爬取页面占用大量内存，需要手动释放或者限制爬取数量

