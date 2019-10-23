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

  

- 使用 splash 来爬取带有 javascript 渲染的页面
  - 文档介绍：http://docs.scrapy.org/en/latest/topics/dynamic-content.html
  - scrapy-splash：https://github.com/scrapy-plugins/scrapy-splash
  - splash 项目：https://github.com/scrapinghub/splash